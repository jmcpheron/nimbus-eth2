# https://notes.ethereum.org/@9AeMAlpyQYaAAyuj47BzRw/rkwW3ceVY
# Monitor traffic: socat -v TCP-LISTEN:9550,fork TCP-CONNECT:127.0.0.1:8550

import
  unittest2,
  chronos, web3/[engine_api_types, ethtypes, engine_api, builder_api],
  ../beacon_chain/eth1/eth1_monitor,
  ../beacon_chain/spec/[digest, presets],
  ../tests/testutil

suite "Merge test vectors":
  setup:
    let web3ProviderEE = (waitFor Web3DataProvider.new(
      default(Eth1Address), "ws://127.0.0.1:8546", none(seq[byte]))).get
    let web3Provider = (waitFor Web3DataProvider.new(
      #default(Eth1Address), "http://127.0.0.1:19550", none(seq[byte]))).get
      default(Eth1Address), "http://127.0.0.1:28545", none(seq[byte]))).get
    let web3Provider2 = (waitFor Web3DataProvider.new(
      #default(Eth1Address), "http://127.0.0.1:19550", none(seq[byte]))).get
      default(Eth1Address), "http://127.0.0.1:28546", none(seq[byte]))).get

  test "getPayload, newPayload, and forkchoiceUpdated":
    const feeRecipient =
      Eth1Address.fromHex("0xa94f5374fce5edbc8e2a8697c15331677e6ebf0b")
    let
      existingBlock = waitFor web3ProviderEE.getBlockByNumber(0)
      payloadId = waitFor web3Provider2.forkchoiceUpdated(
        existingBlock.hash.asEth2Digest,
        existingBlock.hash.asEth2Digest,
        existingBlock.timestamp.uint64 + 12,
        default(Eth2Digest).data,  # Random
        feeRecipient)
      payloadHeader = waitFor web3Provider.web3.provider.builder_getPayloadHeaderV1(FixedBytes[8](array[8, byte] (payloadId.payloadId.get)))
      #payload =         waitFor web3Provider.web3.provider.engine_getPayloadV1(FixedBytes[8](array[8, byte] (payloadId.payloadId.get)))
      #payloadStatus =   waitFor web3Provider.engine_newPayload(payload)
