# beacon_chain
# Copyright (c) 2022 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at https://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

# `wss_sim` loads a state and a set of validator keys, then simulates a
# beacon chain running with the given validators producing blocks
# and attesting when they're supposed to.

import
  std/[strformat, options, sequtils, tables],
  chronicles,
  confutils,
  stew/io2,
  ../tests/testblockutil,
  ../beacon_chain/networking/network_metadata,
  ../beacon_chain/[beacon_clock, sszdump],
  ../beacon_chain/spec/eth2_apis/eth2_rest_serialization,
  ../beacon_chain/spec/datatypes/[phase0, altair, bellatrix],
  ../beacon_chain/spec/[
    beaconstate, crypto, forks, helpers, signatures, state_transition],
  ../beacon_chain/validators/[keystore_management, validator_pool]

template findIt*(s: openArray, predicate: untyped): int =
  var res = -1
  for i, it {.inject.} in s:
    if predicate:
      res = i
      break
  res

proc findValidator(validators: seq[Validator], pubKey: ValidatorPubKey):
    Option[ValidatorIndex] =
  let idx = validators.findIt(it.pubKey == pubKey)
  if idx == -1:
    none(ValidatorIndex)
  else:
    some(idx.ValidatorIndex)

cli do(validatorsDir: string, secretsDir: string,
       startState: string, network: string):
  let
    cfg = getMetadataForNetwork(network).cfg
    state =
      newClone(readSszForkedHashedBeaconState(
        cfg, readAllBytes(startState).tryGet()))
    finalizedEpoch = getStateField(state[], finalized_checkpoint).epoch

  var
    clock = BeaconClock.init(getStateField(state[], genesis_time))
    validators: Table[ValidatorIndex, ValidatorPrivKey]
    validatorKeys: Table[ValidatorPubKey, ValidatorPrivKey]

  for item in listLoadableKeystores(validatorsDir, secretsDir, true,
                                    {KeystoreKind.Local}):
    let
      pubkey = item.privateKey.toPubKey().toPubKey()
      idx = findValidator(getStateField(state[], validators).toSeq, pubkey)
    if idx.isSome():
      notice "Loaded validator", pubkey
      validators[idx.get()] = item.privateKey
      validatorKeys[pubkey] = item.privateKey
    else:
      warn "Unkownn validator", pubkey

  var
    blockRoot = withState(state[]): state.latest_block_root
    cache: StateCache
    info: ForkedEpochInfo
    aggregates: seq[Attestation]
    syncAggregate = SyncAggregate.init()

  let
    genesis_validators_root = getStateField(state[], genesis_validators_root)

  block:
    let
      active = withState(state[]):
        get_active_validator_indices_len(state.data, state.data.slot.epoch)

    notice "Let's play",
      validators = validators.len(),
      active

  while true:
    # Move to slot
    let
      slot = getStateField(state[], slot) + 1
    process_slots(cfg, state[], slot, cache, info, {}).expect("works")

    if start_beacon_time(slot) > clock.now():
      notice "Ran out of time",
        epoch = slot.epoch
      break

    var exited: seq[ValidatorIndex]
    for k, v in validators:
      if getStateField(state[], validators).asSeq[k].exit_epoch != FAR_FUTURE_EPOCH:
        exited.add k
    for k in exited:
      warn "Validator exited", k

      validatorKeys.del(getStateField(state[], validators).asSeq[k].pubkey)
      validators.del(k)

    if slot.epoch != (slot - 1).epoch:
      let
        active = withState(state[]):
          get_active_validator_indices_len(state.data, slot.epoch)
        balance = block:
          var b: uint64
          for k, _ in validators:
            if is_active_validator(getStateField(state[], validators).asSeq[k], slot.epoch):
              b += getStateField(state[], balances).asSeq[k]
          b
        validators = block:
          var b: int
          for k, _ in validators:
            if is_active_validator(getStateField(state[], validators).asSeq[k], slot.epoch):
              b += 1
          b
        avgBalance = balance.int64 div validators.int64

      notice "Processing epoch",
        epoch = slot.epoch,
        active,
        epochsSinceFinality =
          slot.epoch - getStateField(state[], finalized_checkpoint).epoch,
        balance,
        validators,
        avgBalance

      if slot.epoch mod 32 == 0:
        withState(state[]): dump(".", state)

    let
      fork = getStateField(state[], fork)
      proposer = get_beacon_proposer_index(state[], cache, slot).get()

    if proposer in validators:
      let
        blockAggregates = aggregates.filterIt(
          it.data.slot + MIN_ATTESTATION_INCLUSION_DELAY <= slot and
          slot <= it.data.slot + SLOTS_PER_EPOCH)
        randao_reveal =
            validators[proposer].genRandaoReveal(
              fork, genesis_validators_root, slot).toValidatorSig()
        message = makeBeaconBlock(
          cfg,
          state[],
          proposer,
          randao_reveal,
          getStateField(state[], eth1_data),
          GraffitiBytes.init("insecura"),
          blockAggregates,
          @[],
          BeaconBlockExits(),
          syncAggregate,
          default(ExecutionPayload),
          noRollback,
          cache).get()

      case message.kind
      of BeaconBlockFork.Phase0:
        blockRoot = hash_tree_root(message.phase0Data)
        let signedBlock = phase0.SignedBeaconBlock(
          message: message.phase0Data,
          root: blockRoot,
          signature: get_block_signature(
            fork, genesis_validators_root, slot, blockRoot,
            validators[proposer]).toValidatorSig())
        dump(".", signedBlock)
      of BeaconBlockFork.Altair:
        blockRoot = hash_tree_root(message.altairData)
        let signedBlock = altair.SignedBeaconBlock(
          message: message.altairData,
          root: blockRoot,
          signature: get_block_signature(
            fork, genesis_validators_root, slot, blockRoot,
            validators[proposer]).toValidatorSig())
        dump(".", signedBlock)
      of BeaconBlockFork.Bellatrix:
        blockRoot = hash_tree_root(message.bellatrixData)
        let signedBlock = bellatrix.SignedBeaconBlock(
          message: message.bellatrixData,
          root: blockRoot,
          signature: get_block_signature(
            fork, genesis_validators_root, slot, blockRoot,
            validators[proposer]).toValidatorSig())
        dump(".", signedBlock)
      notice "Block proposed", message, blockRoot

      aggregates.setLen(0)

    syncAggregate = SyncAggregate.init()

    withState(state[]):
      let committees_per_slot = get_committee_count_per_slot(
        state.data, slot.epoch, cache)
      for committee_index in get_committee_indices(committees_per_slot):
        let committee = get_beacon_committee(state.data, slot, committee_index, cache)

        var
          attestation = Attestation(
            data: makeAttestationData(
              state.data, slot, committee_index, blockRoot),
            aggregation_bits: CommitteeValidatorsBits.init(committee.len))
          agg: AggregateSignature

        for index_in_committee, validator_index in committee:
          if validator_index notin validators:
            continue

          let
            signature = get_attestation_signature(
              fork, genesis_validators_root, attestation.data,
              validators[validator_index])
          if attestation.aggregation_bits.countOnes() == 0:
            agg = AggregateSignature.init(signature)
          else:
            agg.aggregate(signature)
          attestation.aggregation_bits.setBit(index_in_committee)

        if attestation.aggregation_bits.countOnes() > 0:
          attestation.signature = agg.finish().toValidatorSig()

          if aggregates.len == 128:
            aggregates.delete(0)

          aggregates.add(attestation)

      when stateFork >= BeaconStateFork.Altair:
        let
          nextSlot = slot + 1
          pubkeys =
            if slot.sync_committee_period == nextSlot.sync_committee_period:
              state.data.current_sync_committee.pubkeys
            else:
              state.data.next_sync_committee.pubkeys

        var
          agg: AggregateSignature
          inited = false

        for i, pubkey in pubkeys.pairs():
          validatorKeys.withValue(pubkey, privkey):
            let sig = get_sync_committee_message_signature(
              fork, genesis_validators_root, slot, blockRoot, privkey[])

            if inited:
              agg.aggregate(sig)
            else:
              agg = AggregateSignature.init(sig)
              inited = true
            sync_aggregate.sync_committee_bits.setBit(i)

        if inited:
          sync_aggregate.sync_committee_signature = finish(agg).toValidatorSig()
