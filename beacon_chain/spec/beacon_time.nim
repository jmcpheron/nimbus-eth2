# beacon_chain
# Copyright (c) 2018-2022 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at https://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

{.push raises: [Defect].}

# References to `vFuture` refer to the pre-release proposal of the libp2p based
# light client sync protocol. Conflicting release versions are not in use.
# https://github.com/ethereum/consensus-specs/pull/2802

import
  std/[hashes, typetraits],
  chronicles,
  chronos/timer,
  json_serialization,
  ./presets

export hashes, timer, json_serialization, presets

# A collection of time units that permeate the spec - common to all of them is
# that they expressed relative to the genesis of the chain at varying
# granularities:
#
# * BeaconTime - nanoseconds since genesis
# * Slot - SLOTS_PER_SECOND seconds since genesis
# * Epoch - EPOCHS_PER_SLOT slots since genesis
# * SyncCommitteePeriod - EPOCHS_PER_SYNC_COMMITTEE_PERIOD epochs since genesis

type
  BeaconTime* = object
    ## A point in time, relative to the genesis of the chain
    ##
    ## Implemented as nanoseconds since genesis - negative means before
    ## the chain started.
    ns_since_genesis*: int64

  TimeDiff* = object
    nanoseconds*: int64
    ## Difference between two points in time with nanosecond granularity
    ## Can be negative (unlike timer.Duration)

const
  # Earlier spec versions had these at a different slot
  GENESIS_SLOT* = Slot(0)
  GENESIS_EPOCH* = Epoch(0) # compute_epoch_at_slot(GENESIS_SLOT)

  # https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/phase0/fork-choice.md#constant
  INTERVALS_PER_SLOT* = 3

  FAR_FUTURE_BEACON_TIME* = BeaconTime(ns_since_genesis: int64.high())
  FAR_FUTURE_SLOT* = Slot(not 0'u64)
  # FAR_FUTURE_EPOCH* = Epoch(not 0'u64) # in presets
  FAR_FUTURE_PERIOD* = SyncCommitteePeriod(not 0'u64)

  NANOSECONDS_PER_SLOT = SECONDS_PER_SLOT * 1_000_000_000'u64

# TODO when https://github.com/nim-lang/Nim/issues/14440 lands in Status's Nim,
# switch proc {.noSideEffect.} to func.
template ethTimeUnit*(typ: type) {.dirty.} =
  proc `+`*(x: typ, y: uint64): typ {.borrow, noSideEffect.}
  proc `-`*(x: typ, y: uint64): typ {.borrow, noSideEffect.}
  proc `-`*(x: uint64, y: typ): typ {.borrow, noSideEffect.}

  # Not closed over type in question (Slot or Epoch)
  proc `mod`*(x: typ, y: uint64): uint64 {.borrow, noSideEffect.}
  proc `div`*(x: typ, y: uint64): uint64 {.borrow, noSideEffect.}
  proc `div`*(x: uint64, y: typ): uint64 {.borrow, noSideEffect.}
  proc `-`*(x: typ, y: typ): uint64 {.borrow, noSideEffect.}

  proc `*`*(x: typ, y: uint64): uint64 {.borrow, noSideEffect.}

  proc `+=`*(x: var typ, y: typ) {.borrow, noSideEffect.}
  proc `+=`*(x: var typ, y: uint64) {.borrow, noSideEffect.}
  proc `-=`*(x: var typ, y: typ) {.borrow, noSideEffect.}
  proc `-=`*(x: var typ, y: uint64) {.borrow, noSideEffect.}

  # Comparison operators
  proc `<`*(x: typ, y: typ): bool {.borrow, noSideEffect.}
  proc `<`*(x: typ, y: uint64): bool {.borrow, noSideEffect.}
  proc `<`*(x: uint64, y: typ): bool {.borrow, noSideEffect.}
  proc `<=`*(x: typ, y: typ): bool {.borrow, noSideEffect.}
  proc `<=`*(x: typ, y: uint64): bool {.borrow, noSideEffect.}
  proc `<=`*(x: uint64, y: typ): bool {.borrow, noSideEffect.}

  proc `==`*(x: typ, y: typ): bool {.borrow, noSideEffect.}
  proc `==`*(x: typ, y: uint64): bool {.borrow, noSideEffect.}
  proc `==`*(x: uint64, y: typ): bool {.borrow, noSideEffect.}

  # Nim integration
  proc `$`*(x: typ): string {.borrow, noSideEffect.}
  proc hash*(x: typ): Hash {.borrow, noSideEffect.}

  template asUInt64*(v: typ): uint64 = distinctBase(v)
  template shortLog*(v: typ): auto = distinctBase(v)

  # Serialization
  proc writeValue*(writer: var JsonWriter, value: typ)
                  {.raises: [IOError, Defect].}=
    writeValue(writer, uint64 value)

  proc readValue*(reader: var JsonReader, value: var typ)
                 {.raises: [IOError, SerializationError, Defect].} =
    value = typ reader.readValue(uint64)

ethTimeUnit Slot
ethTimeUnit Epoch
ethTimeUnit SyncCommitteePeriod

template `<`*(a, b: BeaconTime): bool = a.ns_since_genesis < b.ns_since_genesis
template `<=`*(a, b: BeaconTime): bool = a.ns_since_genesis <= b.ns_since_genesis
template `<`*(a, b: TimeDiff): bool = a.nanoseconds < b.nanoseconds
template `<=`*(a, b: TimeDiff): bool = a.nanoseconds <= b.nanoseconds
template `<`*(a: TimeDiff, b: Duration): bool = a.nanoseconds < b.nanoseconds

func toSlot*(t: BeaconTime): tuple[afterGenesis: bool, slot: Slot] =
  if t == FAR_FUTURE_BEACON_TIME:
    (true, FAR_FUTURE_SLOT)
  elif t.ns_since_genesis >= 0:
    (true, Slot(uint64(t.ns_since_genesis) div NANOSECONDS_PER_SLOT))
  else:
    (false, Slot(uint64(-t.ns_since_genesis) div NANOSECONDS_PER_SLOT))

template `+`*(t: BeaconTime, offset: Duration | TimeDiff): BeaconTime =
  BeaconTime(ns_since_genesis: t.ns_since_genesis + offset.nanoseconds)

template `-`*(t: BeaconTime, offset: Duration | TimeDiff): BeaconTime =
  BeaconTime(ns_since_genesis: t.ns_since_genesis - offset.nanoseconds)

template `-`*(a, b: BeaconTime): TimeDiff =
  TimeDiff(nanoseconds: a.ns_since_genesis - b.ns_since_genesis)

template `+`*(a: TimeDiff, b: Duration): TimeDiff =
  TimeDiff(nanoseconds: a.nanoseconds + b.nanoseconds)

const
  # Offsets from the start of the slot to when the corresponding message should
  # be sent
  # https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/phase0/validator.md#attesting
  attestationSlotOffset* = TimeDiff(nanoseconds:
    NANOSECONDS_PER_SLOT.int64 div INTERVALS_PER_SLOT)
  # https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/phase0/validator.md#broadcast-aggregate
  aggregateSlotOffset* = TimeDiff(nanoseconds:
    NANOSECONDS_PER_SLOT.int64  * 2 div INTERVALS_PER_SLOT)
  # https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/altair/validator.md#prepare-sync-committee-message
  syncCommitteeMessageSlotOffset* = TimeDiff(nanoseconds:
    NANOSECONDS_PER_SLOT.int64  div INTERVALS_PER_SLOT)
  # https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/altair/validator.md#broadcast-sync-committee-contribution
  syncContributionSlotOffset* = TimeDiff(nanoseconds:
    NANOSECONDS_PER_SLOT.int64  * 2 div INTERVALS_PER_SLOT)
  # https://github.com/ethereum/consensus-specs/blob/vFuture/specs/altair/sync-protocol.md#block-proposal
  optimisticLightClientUpdateSlotOffset* = TimeDiff(nanoseconds:
    NANOSECONDS_PER_SLOT.int64 div INTERVALS_PER_SLOT)

func toFloatSeconds*(t: TimeDiff): float =
  float(t.nanoseconds) / 1_000_000_000.0

func start_beacon_time*(s: Slot): BeaconTime =
  # The point in time that a slot begins
  const maxSlot = Slot(
    uint64(FAR_FUTURE_BEACON_TIME.ns_since_genesis) div NANOSECONDS_PER_SLOT)
  if s > maxSlot: FAR_FUTURE_BEACON_TIME
  else: BeaconTime(ns_since_genesis: int64(uint64(s) * NANOSECONDS_PER_SLOT))

func block_deadline*(s: Slot): BeaconTime =
  s.start_beacon_time
func attestation_deadline*(s: Slot): BeaconTime =
  s.start_beacon_time + attestationSlotOffset
func aggregate_deadline*(s: Slot): BeaconTime =
  s.start_beacon_time + aggregateSlotOffset
func sync_committee_message_deadline*(s: Slot): BeaconTime =
  s.start_beacon_time + syncCommitteeMessageSlotOffset
func sync_contribution_deadline*(s: Slot): BeaconTime =
  s.start_beacon_time + syncContributionSlotOffset
func optimistic_light_client_update_time*(s: Slot): BeaconTime =
  s.start_beacon_time + optimisticLightClientUpdateSlotOffset

func slotOrZero*(time: BeaconTime): Slot =
  let exSlot = time.toSlot
  if exSlot.afterGenesis: exSlot.slot
  else: Slot(0)

# https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/phase0/beacon-chain.md#compute_epoch_at_slot
func epoch*(slot: Slot): Epoch = # aka compute_epoch_at_slot
  ## Return the epoch number at ``slot``.
  if slot == FAR_FUTURE_SLOT: FAR_FUTURE_EPOCH
  else: Epoch(slot div SLOTS_PER_EPOCH)

# https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/phase0/fork-choice.md#compute_slots_since_epoch_start
func since_epoch_start*(slot: Slot): uint64 = # aka compute_slots_since_epoch_start
  ## How many slots since the beginning of the epoch (`[0..SLOTS_PER_EPOCH-1]`)
  (slot mod SLOTS_PER_EPOCH)

template is_epoch*(slot: Slot): bool =
  slot.since_epoch_start == 0

# https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/phase0/beacon-chain.md#compute_start_slot_at_epoch
func start_slot*(epoch: Epoch): Slot = # aka compute_start_slot_at_epoch
  ## Return the start slot of ``epoch``.
  const maxEpoch = Epoch(FAR_FUTURE_SLOT div SLOTS_PER_EPOCH)
  if epoch >= maxEpoch: FAR_FUTURE_SLOT
  else: Slot(epoch * SLOTS_PER_EPOCH)

# https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/phase0/beacon-chain.md#get_previous_epoch
func get_previous_epoch*(current_epoch: Epoch): Epoch =
  ## Return the previous epoch (unless the current epoch is ``GENESIS_EPOCH``).
  if current_epoch == GENESIS_EPOCH:
    current_epoch
  else:
    current_epoch - 1

iterator slots*(epoch: Epoch): Slot =
  let start_slot = start_slot(epoch)
  for slot in start_slot ..< start_slot + SLOTS_PER_EPOCH:
    yield slot

# https://github.com/ethereum/consensus-specs/blob/v1.1.10/specs/altair/validator.md#sync-committee
template sync_committee_period*(epoch: Epoch): SyncCommitteePeriod =
  if epoch == FAR_FUTURE_EPOCH: FAR_FUTURE_PERIOD
  else: SyncCommitteePeriod(epoch div EPOCHS_PER_SYNC_COMMITTEE_PERIOD)

template sync_committee_period*(slot: Slot): SyncCommitteePeriod =
  if slot == FAR_FUTURE_SLOT: FAR_FUTURE_PERIOD
  else: SyncCommitteePeriod(slot div SLOTS_PER_SYNC_COMMITTEE_PERIOD)

func since_sync_committee_period_start*(slot: Slot): uint64 =
  ## How many slots since the beginning of the epoch (`[0..SLOTS_PER_SYNC_COMMITTEE_PERIOD-1]`)
  (slot mod SLOTS_PER_SYNC_COMMITTEE_PERIOD)

func since_sync_committee_period_start*(epoch: Epoch): uint64 =
  ## How many slots since the beginning of the epoch (`[0..EPOCHS_PER_SYNC_COMMITTEE_PERIOD-1]`)
  (epoch mod EPOCHS_PER_SYNC_COMMITTEE_PERIOD)

template is_sync_committee_period*(slot: Slot): bool =
  slot.since_sync_committee_period_start() == 0

template is_sync_committee_period*(epoch: Epoch): bool =
  epoch.since_sync_committee_period_start() == 0

template start_epoch*(period: SyncCommitteePeriod): Epoch =
  ## Return the start epoch of ``period``.
  const maxPeriod = SyncCommitteePeriod(
    FAR_FUTURE_EPOCH div EPOCHS_PER_SYNC_COMMITTEE_PERIOD)
  if period >= maxPeriod: FAR_FUTURE_EPOCH
  else: Epoch(period * EPOCHS_PER_SYNC_COMMITTEE_PERIOD)

template start_slot*(period: SyncCommitteePeriod): Slot =
  ## Return the start slot of ``period``.
  const maxPeriod = SyncCommitteePeriod(
    FAR_FUTURE_SLOT div SLOTS_PER_SYNC_COMMITTEE_PERIOD)
  if period >= maxPeriod: FAR_FUTURE_SLOT
  else: Slot(period * SLOTS_PER_SYNC_COMMITTEE_PERIOD)

func `$`*(t: BeaconTime): string =
  if t.ns_since_genesis >= 0:
    $(timer.nanoseconds(t.ns_since_genesis))
  else:
    "-" & $(timer.nanoseconds(-t.ns_since_genesis))

func `$`*(t: TimeDiff): string =
  if t.nanoseconds >= 0:
    $(timer.nanoseconds(t.nanoseconds))
  else:
    "-" & $(timer.nanoseconds(-t.nanoseconds))

func shortLog*(t: BeaconTime | TimeDiff): string = $t

chronicles.formatIt BeaconTime: it.shortLog
chronicles.formatIt TimeDiff: it.shortLog
chronicles.formatIt Slot: it.shortLog
chronicles.formatIt Epoch: it.shortLog
chronicles.formatIt SyncCommitteePeriod: it.shortLog
