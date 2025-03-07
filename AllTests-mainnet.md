AllTests-mainnet
===
## Attestation pool processing [Preset: mainnet]
```diff
+ Attestations may arrive in any order [Preset: mainnet]                                     OK
+ Attestations may overlap, bigger first [Preset: mainnet]                                   OK
+ Attestations may overlap, smaller first [Preset: mainnet]                                  OK
+ Attestations should be combined [Preset: mainnet]                                          OK
+ Can add and retrieve simple attestations [Preset: mainnet]                                 OK
+ Everyone voting for something different [Preset: mainnet]                                  OK
+ Fork choice returns block with attestation                                                 OK
+ Fork choice returns latest block with no attestations                                      OK
+ Trying to add a block twice tags the second as an error                                    OK
+ Trying to add a duplicate block from an old pruned epoch is tagged as an error             OK
+ Working with aggregates [Preset: mainnet]                                                  OK
```
OK: 11/11 Fail: 0/11 Skip: 0/11
## Backfill
```diff
+ backfill to genesis                                                                        OK
+ reload backfill position                                                                   OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## Beacon chain DB [Preset: mainnet]
```diff
+ empty database [Preset: mainnet]                                                           OK
+ find ancestors [Preset: mainnet]                                                           OK
+ sanity check Altair and cross-fork getState rollback [Preset: mainnet]                     OK
+ sanity check Altair blocks [Preset: mainnet]                                               OK
+ sanity check Altair states [Preset: mainnet]                                               OK
+ sanity check Altair states, reusing buffers [Preset: mainnet]                              OK
+ sanity check Bellatrix and cross-fork getState rollback [Preset: mainnet]                  OK
+ sanity check Bellatrix blocks [Preset: mainnet]                                            OK
+ sanity check Bellatrix states [Preset: mainnet]                                            OK
+ sanity check Bellatrix states, reusing buffers [Preset: mainnet]                           OK
+ sanity check genesis roundtrip [Preset: mainnet]                                           OK
+ sanity check phase 0 blocks [Preset: mainnet]                                              OK
+ sanity check phase 0 getState rollback [Preset: mainnet]                                   OK
+ sanity check phase 0 states [Preset: mainnet]                                              OK
+ sanity check phase 0 states, reusing buffers [Preset: mainnet]                             OK
+ sanity check state diff roundtrip [Preset: mainnet]                                        OK
```
OK: 16/16 Fail: 0/16 Skip: 0/16
## Beacon state [Preset: mainnet]
```diff
+ Smoke test initialize_beacon_state_from_eth1 [Preset: mainnet]                             OK
+ dependent_root                                                                             OK
+ get_beacon_proposer_index                                                                  OK
+ latest_block_root                                                                          OK
+ process_slots                                                                              OK
```
OK: 5/5 Fail: 0/5 Skip: 0/5
## Beacon time
```diff
+ basics                                                                                     OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## Block pool altair processing [Preset: mainnet]
```diff
+ Invalid signatures [Preset: mainnet]                                                       OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## Block pool processing [Preset: mainnet]
```diff
+ Adding the same block twice returns a Duplicate error [Preset: mainnet]                    OK
+ Simple block add&get [Preset: mainnet]                                                     OK
+ basic ops                                                                                  OK
+ updateHead updates head and headState [Preset: mainnet]                                    OK
+ updateState sanity [Preset: mainnet]                                                       OK
```
OK: 5/5 Fail: 0/5 Skip: 0/5
## Block processor [Preset: mainnet]
```diff
+ Reverse order block add & get [Preset: mainnet]                                            OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## Block quarantine
```diff
+ Unviable smoke test                                                                        OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## BlockId and helpers
```diff
+ atSlot sanity                                                                              OK
+ parent sanity                                                                              OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## BlockRef and helpers
```diff
+ get_ancestor sanity                                                                        OK
+ isAncestorOf sanity                                                                        OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## BlockSlot and helpers
```diff
+ atSlot sanity                                                                              OK
+ parent sanity                                                                              OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## DeleteKeys requests [Preset: mainnet]
```diff
+ Deleting not existing key [Preset: mainnet]                                                OK
+ Invalid Authorization Header [Preset: mainnet]                                             OK
+ Invalid Authorization Token [Preset: mainnet]                                              OK
+ Missing Authorization header [Preset: mainnet]                                             OK
```
OK: 4/4 Fail: 0/4 Skip: 0/4
## DeleteRemoteKeys requests [Preset: mainnet]
```diff
+ Deleting existing local key and remote key [Preset: mainnet]                               OK
+ Deleting not existing key [Preset: mainnet]                                                OK
+ Invalid Authorization Header [Preset: mainnet]                                             OK
+ Invalid Authorization Token [Preset: mainnet]                                              OK
+ Missing Authorization header [Preset: mainnet]                                             OK
```
OK: 5/5 Fail: 0/5 Skip: 0/5
## Diverging hardforks
```diff
+ Non-tail block in common                                                                   OK
+ Tail block only in common                                                                  OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## EF - SSZ generic types
```diff
  Testing basic_vector inputs - invalid                                                      Skip
+ Testing basic_vector inputs - valid                                                        OK
+ Testing bitlist      inputs - invalid                                                      OK
+ Testing bitlist      inputs - valid                                                        OK
  Testing bitvector    inputs - invalid                                                      Skip
+ Testing bitvector    inputs - valid                                                        OK
+ Testing boolean      inputs - invalid                                                      OK
+ Testing boolean      inputs - valid                                                        OK
+ Testing containers   inputs - invalid - skipping BitsStruct                                OK
+ Testing containers   inputs - valid - skipping BitsStruct                                  OK
+ Testing uints        inputs - invalid                                                      OK
+ Testing uints        inputs - valid                                                        OK
```
OK: 10/12 Fail: 0/12 Skip: 2/12
## Eth1 monitor
```diff
+ Rewrite HTTPS Infura URLs                                                                  OK
+ Roundtrip engine RPC and consensus ExecutionPayload representations                        OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## Eth2 specific discovery tests
```diff
+ Invalid attnets field                                                                      OK
+ Subnet query                                                                               OK
+ Subnet query after ENR update                                                              OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## Exit pool testing suite
```diff
+ addExitMessage/getAttesterSlashingMessage                                                  OK
+ addExitMessage/getProposerSlashingMessage                                                  OK
+ addExitMessage/getVoluntaryExitMessage                                                     OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## FinalizedBlocks [Preset: mainnet]
```diff
+ Basic ops [Preset: mainnet]                                                                OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## Fork Choice + Finality  [Preset: mainnet]
```diff
+ fork_choice - testing finality #01                                                         OK
+ fork_choice - testing finality #02                                                         OK
+ fork_choice - testing no votes                                                             OK
+ fork_choice - testing with votes                                                           OK
```
OK: 4/4 Fail: 0/4 Skip: 0/4
## Fork id compatibility test
```diff
+ Digest check                                                                               OK
+ Fork check                                                                                 OK
+ Next fork epoch check                                                                      OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## Forked SSZ readers
```diff
+ load altair block                                                                          OK
+ load altair state                                                                          OK
+ load bellatrix block                                                                       OK
+ load bellatrix state                                                                       OK
+ load phase0 block                                                                          OK
+ load phase0 state                                                                          OK
+ should raise on unknown data                                                               OK
```
OK: 7/7 Fail: 0/7 Skip: 0/7
## Gossip fork transition
```diff
+ Gossip fork transition                                                                     OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## Gossip validation  [Preset: mainnet]
```diff
+ Empty committee when no committee for slot                                                 OK
+ validateAttestation                                                                        OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## Gossip validation - Extra
```diff
+ validateSyncCommitteeMessage                                                               OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## Honest validator
```diff
+ General pubsub topics                                                                      OK
+ Mainnet attestation topics                                                                 OK
+ isNearSyncCommitteePeriod                                                                  OK
+ is_aggregator                                                                              OK
```
OK: 4/4 Fail: 0/4 Skip: 0/4
## ImportKeystores requests [Preset: mainnet]
```diff
+ ImportKeystores/ListKeystores/DeleteKeystores [Preset: mainnet]                            OK
+ Invalid Authorization Header [Preset: mainnet]                                             OK
+ Invalid Authorization Token [Preset: mainnet]                                              OK
+ Missing Authorization header [Preset: mainnet]                                             OK
```
OK: 4/4 Fail: 0/4 Skip: 0/4
## ImportRemoteKeys/ListRemoteKeys/DeleteRemoteKeys [Preset: mainnet]
```diff
+ Importing list of remote keys [Preset: mainnet]                                            OK
+ Invalid Authorization Header [Preset: mainnet]                                             OK
+ Invalid Authorization Token [Preset: mainnet]                                              OK
+ Missing Authorization header [Preset: mainnet]                                             OK
```
OK: 4/4 Fail: 0/4 Skip: 0/4
## Interop
```diff
+ Interop genesis                                                                            OK
+ Interop signatures                                                                         OK
+ Mocked start private key                                                                   OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## KeyStorage testing suite
```diff
+ Pbkdf2 errors                                                                              OK
+ [PBKDF2] Keystore decryption                                                               OK
+ [PBKDF2] Keystore encryption                                                               OK
+ [PBKDF2] Network Keystore decryption                                                       OK
+ [PBKDF2] Network Keystore encryption                                                       OK
+ [SCRYPT] Keystore decryption                                                               OK
+ [SCRYPT] Keystore encryption                                                               OK
+ [SCRYPT] Network Keystore decryption                                                       OK
+ [SCRYPT] Network Keystore encryption                                                       OK
```
OK: 9/9 Fail: 0/9 Skip: 0/9
## Light client [Preset: mainnet]
```diff
+ Init from checkpoint                                                                       OK
+ Light client sync                                                                          OK
+ Pre-Altair                                                                                 OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## Light client processor [Preset: mainnet]
```diff
+ Duplicate bootstrap [Preset: mainnet]                                                      OK
+ Forced update [Preset: mainnet]                                                            OK
+ Invalid bootstrap [Preset: mainnet]                                                        OK
+ Missing bootstrap (optimistic update) [Preset: mainnet]                                    OK
+ Missing bootstrap (update) [Preset: mainnet]                                               OK
+ Standard sync [Preset: mainnet]                                                            OK
```
OK: 6/6 Fail: 0/6 Skip: 0/6
## ListKeys requests [Preset: mainnet]
```diff
+ Correct token provided [Preset: mainnet]                                                   OK
+ Invalid Authorization Header [Preset: mainnet]                                             OK
+ Invalid Authorization Token [Preset: mainnet]                                              OK
+ Missing Authorization header [Preset: mainnet]                                             OK
```
OK: 4/4 Fail: 0/4 Skip: 0/4
## ListRemoteKeys requests [Preset: mainnet]
```diff
+ Correct token provided [Preset: mainnet]                                                   OK
+ Invalid Authorization Header [Preset: mainnet]                                             OK
+ Invalid Authorization Token [Preset: mainnet]                                              OK
+ Missing Authorization header [Preset: mainnet]                                             OK
```
OK: 4/4 Fail: 0/4 Skip: 0/4
## Message signatures
```diff
+ Aggregate and proof signatures                                                             OK
+ Attestation signatures                                                                     OK
+ Deposit signatures                                                                         OK
+ Slot signatures                                                                            OK
+ Sync committee message signatures                                                          OK
+ Sync committee selection proof signatures                                                  OK
+ Sync committee signed contribution and proof signatures                                    OK
+ Voluntary exit signatures                                                                  OK
```
OK: 8/8 Fail: 0/8 Skip: 0/8
## Old database versions [Preset: mainnet]
```diff
+ pre-1.1.0                                                                                  OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## PeerPool testing suite
```diff
+ Access peers by key test                                                                   OK
+ Acquire from empty pool                                                                    OK
+ Acquire/Sorting and consistency test                                                       OK
+ Delete peer on release text                                                                OK
+ Iterators test                                                                             OK
+ Peer lifetime test                                                                         OK
+ Safe/Clear test                                                                            OK
+ Score check test                                                                           OK
+ Space tests                                                                                OK
+ addPeer() test                                                                             OK
+ addPeerNoWait() test                                                                       OK
+ deletePeer() test                                                                          OK
```
OK: 12/12 Fail: 0/12 Skip: 0/12
## Slashing Interchange tests  [Preset: mainnet]
```diff
+ Slashing test: duplicate_pubkey_not_slashable.json                                         OK
+ Slashing test: duplicate_pubkey_slashable_attestation.json                                 OK
+ Slashing test: duplicate_pubkey_slashable_block.json                                       OK
+ Slashing test: multiple_interchanges_multiple_validators_repeat_idem.json                  OK
+ Slashing test: multiple_interchanges_overlapping_validators_merge_stale.json               OK
+ Slashing test: multiple_interchanges_overlapping_validators_repeat_idem.json               OK
+ Slashing test: multiple_interchanges_single_validator_fail_iff_imported.json               OK
+ Slashing test: multiple_interchanges_single_validator_first_surrounds_second.json          OK
+ Slashing test: multiple_interchanges_single_validator_multiple_blocks_out_of_order.json    OK
+ Slashing test: multiple_interchanges_single_validator_second_surrounds_first.json          OK
+ Slashing test: multiple_interchanges_single_validator_single_att_out_of_order.json         OK
+ Slashing test: multiple_interchanges_single_validator_single_block_out_of_order.json       OK
+ Slashing test: multiple_interchanges_single_validator_single_message_gap.json              OK
+ Slashing test: multiple_validators_multiple_blocks_and_attestations.json                   OK
+ Slashing test: multiple_validators_same_slot_blocks.json                                   OK
+ Slashing test: single_validator_genesis_attestation.json                                   OK
+ Slashing test: single_validator_import_only.json                                           OK
+ Slashing test: single_validator_multiple_block_attempts.json                               OK
+ Slashing test: single_validator_multiple_blocks_and_attestations.json                      OK
+ Slashing test: single_validator_out_of_order_attestations.json                             OK
+ Slashing test: single_validator_out_of_order_blocks.json                                   OK
  Slashing test: single_validator_resign_attestation.json                                    Skip
+ Slashing test: single_validator_resign_block.json                                          OK
+ Slashing test: single_validator_single_attestation.json                                    OK
+ Slashing test: single_validator_single_block.json                                          OK
+ Slashing test: single_validator_single_block_and_attestation.json                          OK
+ Slashing test: single_validator_single_block_and_attestation_signing_root.json             OK
+ Slashing test: single_validator_slashable_attestations_double_vote.json                    OK
+ Slashing test: single_validator_slashable_attestations_surrounded_by_existing.json         OK
+ Slashing test: single_validator_slashable_attestations_surrounds_existing.json             OK
+ Slashing test: single_validator_slashable_blocks.json                                      OK
+ Slashing test: single_validator_slashable_blocks_no_root.json                              OK
+ Slashing test: single_validator_source_greater_than_target.json                            OK
+ Slashing test: single_validator_source_greater_than_target_sensible_iff_minified.json      OK
  Slashing test: single_validator_source_greater_than_target_surrounded.json                 Skip
  Slashing test: single_validator_source_greater_than_target_surrounding.json                Skip
+ Slashing test: single_validator_two_blocks_no_signing_root.json                            OK
+ Slashing test: wrong_genesis_validators_root.json                                          OK
```
OK: 35/38 Fail: 0/38 Skip: 3/38
## Slashing Protection DB [Preset: mainnet]
```diff
+ Attestation ordering #1698                                                                 OK
+ Don't prune the very last attestation(s) even by mistake                                   OK
+ Don't prune the very last block even by mistake                                            OK
+ Empty database [Preset: mainnet]                                                           OK
+ Pruning attestations works                                                                 OK
+ Pruning blocks works                                                                       OK
+ SP for block proposal - backtracking append                                                OK
+ SP for block proposal - linear append                                                      OK
+ SP for same epoch attestation target - linear append                                       OK
+ SP for surrounded attestations                                                             OK
+ SP for surrounding attestations                                                            OK
+ Test valid attestation #1699                                                               OK
```
OK: 12/12 Fail: 0/12 Skip: 0/12
## Spec datatypes
```diff
+ Graffiti bytes                                                                             OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## Spec helpers
```diff
+ build_proof - BeaconState                                                                  OK
+ get_branch_indices                                                                         OK
+ get_helper_indices                                                                         OK
+ get_path_indices                                                                           OK
+ integer_squareroot                                                                         OK
+ is_valid_merkle_branch                                                                     OK
+ verify_merkle_multiproof                                                                   OK
```
OK: 7/7 Fail: 0/7 Skip: 0/7
## Specific field types
```diff
+ root update                                                                                OK
+ roundtrip                                                                                  OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## Sync committee pool
```diff
+ Aggregating votes                                                                          OK
+ An empty pool is safe to prune                                                             OK
+ An empty pool is safe to prune 2                                                           OK
+ An empty pool is safe to use                                                               OK
```
OK: 4/4 Fail: 0/4 Skip: 0/4
## SyncManager test suite
```diff
+ Process all unviable blocks                                                                OK
+ [SyncQueue#Backward] Async unordered push test                                             OK
+ [SyncQueue#Backward] Async unordered push with rewind test                                 OK
+ [SyncQueue#Backward] Good response with missing values towards end                         OK
+ [SyncQueue#Backward] Handle out-of-band sync progress advancement                          OK
+ [SyncQueue#Backward] Pass through established limits test                                  OK
+ [SyncQueue#Backward] Smoke test                                                            OK
+ [SyncQueue#Backward] Start and finish slots equal                                          OK
+ [SyncQueue#Backward] Two full requests success/fail                                        OK
+ [SyncQueue#Backward] getRewindPoint() test                                                 OK
+ [SyncQueue#Forward] Async unordered push test                                              OK
+ [SyncQueue#Forward] Async unordered push with rewind test                                  OK
+ [SyncQueue#Forward] Good response with missing values towards end                          OK
+ [SyncQueue#Forward] Handle out-of-band sync progress advancement                           OK
+ [SyncQueue#Forward] Pass through established limits test                                   OK
+ [SyncQueue#Forward] Smoke test                                                             OK
+ [SyncQueue#Forward] Start and finish slots equal                                           OK
+ [SyncQueue#Forward] Two full requests success/fail                                         OK
+ [SyncQueue#Forward] getRewindPoint() test                                                  OK
+ [SyncQueue] checkResponse() test                                                           OK
+ [SyncQueue] contains() test                                                                OK
+ [SyncQueue] getLastNonEmptySlot() test                                                     OK
+ [SyncQueue] hasEndGap() test                                                               OK
```
OK: 23/23 Fail: 0/23 Skip: 0/23
## Zero signature sanity checks
```diff
+ SSZ serialization roundtrip of SignedBeaconBlockHeader                                     OK
+ Zero signatures cannot be loaded into a BLS signature object                               OK
+ default initialization of signatures                                                       OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## [Unit - Spec - Block processing] Deposits  [Preset: mainnet]
```diff
+ Deposit at MAX_EFFECTIVE_BALANCE balance (32 ETH)                                          OK
+ Deposit over MAX_EFFECTIVE_BALANCE balance (32 ETH)                                        OK
+ Deposit under MAX_EFFECTIVE_BALANCE balance (32 ETH)                                       OK
+ Invalid deposit at MAX_EFFECTIVE_BALANCE balance (32 ETH)                                  OK
+ Validator top-up                                                                           OK
```
OK: 5/5 Fail: 0/5 Skip: 0/5
## [Unit - Spec - Epoch processing] Justification and Finalization  [Preset: mainnet]
```diff
+  Rule I - 234 finalization with enough support                                             OK
+  Rule I - 234 finalization without support                                                 OK
+  Rule II - 23 finalization with enough support                                             OK
+  Rule II - 23 finalization without support                                                 OK
+  Rule III - 123 finalization with enough support                                           OK
+  Rule III - 123 finalization without support                                               OK
+  Rule IV - 12 finalization with enough support                                             OK
+  Rule IV - 12 finalization without support                                                 OK
```
OK: 8/8 Fail: 0/8 Skip: 0/8
## chain DAG finalization tests [Preset: mainnet]
```diff
+ init with gaps [Preset: mainnet]                                                           OK
+ orphaned epoch block [Preset: mainnet]                                                     OK
+ prune heads on finalization [Preset: mainnet]                                              OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## createValidatorFiles()
```diff
+ Add keystore files [LOCAL]                                                                 OK
+ Add keystore files [REMOTE]                                                                OK
+ Add keystore files twice [LOCAL]                                                           OK
+ Add keystore files twice [REMOTE]                                                          OK
+ `createValidatorFiles` with `keystoreDir` without permissions                              OK
+ `createValidatorFiles` with `secretsDir` without permissions                               OK
+ `createValidatorFiles` with `validatorsDir` without permissions                            OK
+ `createValidatorFiles` with already existing dirs and any error                            OK
```
OK: 8/8 Fail: 0/8 Skip: 0/8
## engine API authentication
```diff
+ HS256 JWS iat token signing                                                                OK
+ HS256 JWS signing                                                                          OK
+ getIatToken                                                                                OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## eth2.0-deposits-cli compatibility
```diff
+ restoring mnemonic with password                                                           OK
+ restoring mnemonic without password                                                        OK
```
OK: 2/2 Fail: 0/2 Skip: 0/2
## removeValidatorFiles()
```diff
+ Remove nonexistent validator                                                               OK
+ Remove validator files                                                                     OK
+ Remove validator files twice                                                               OK
```
OK: 3/3 Fail: 0/3 Skip: 0/3
## removeValidatorFiles() multiple keystore types
```diff
+ Remove [LOCAL] when [LOCAL] is missing                                                     OK
+ Remove [LOCAL] when [LOCAL] is present                                                     OK
+ Remove [LOCAL] when [REMOTE] is present                                                    OK
+ Remove [REMOTE] when [LOCAL] is present                                                    OK
+ Remove [REMOTE] when [REMOTE] is missing                                                   OK
+ Remove [REMOTE] when [REMOTE] is present                                                   OK
```
OK: 6/6 Fail: 0/6 Skip: 0/6
## saveKeystore()
```diff
+ Save [LOCAL] keystore after [LOCAL] keystore with different id                             OK
+ Save [LOCAL] keystore after [LOCAL] keystore with same id                                  OK
+ Save [LOCAL] keystore after [REMOTE] keystore with different id                            OK
+ Save [LOCAL] keystore after [REMOTE] keystore with same id                                 OK
+ Save [REMOTE] keystore after [LOCAL] keystore with different id                            OK
+ Save [REMOTE] keystore after [LOCAL] keystore with same id                                 OK
+ Save [REMOTE] keystore after [REMOTE] keystore with different id                           OK
+ Save [REMOTE] keystore after [REMOTE] keystore with same id                                OK
```
OK: 8/8 Fail: 0/8 Skip: 0/8
## state diff tests [Preset: mainnet]
```diff
+ random slot differences [Preset: mainnet]                                                  OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1
## subnet tracker
```diff
+ should register stability subnets on attester duties                                       OK
```
OK: 1/1 Fail: 0/1 Skip: 0/1

---TOTAL---
OK: 294/299 Fail: 0/299 Skip: 5/299
