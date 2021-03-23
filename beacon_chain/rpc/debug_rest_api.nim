import
  std/sequtils,
  presto,
  chronicles,
  ../version, ../beacon_node_common,
  ../spec/[datatypes, digest, presets],
  ./eth2_json_rest_serialization, ./rest_utils

logScope: topics = "rest_debug"

proc installDebugApiHandlers*(router: var RestRouter, node: BeaconNode) =
  router.api(MethodGet,
             "/api/eth/v1/debug/beacon/states/{state_id}") do (
    state_id: StateIdent) -> RestApiResponse:
    let bslot =
      block:
        if state_id.isErr():
          return RestApiResponse.jsonError(Http400, "Invalid state_id",
                                           $state_id.error())
        let bres = node.getBlockSlot(state_id.get())
        if bres.isErr():
          return RestApiResponse.jsonError(Http404, "State not found",
                                           $bres.error())
        bres.get()
    node.withStateForBlockSlot(bslot):
      return RestApiResponse.jsonResponse(state())
    return RestApiResponse.jsonError(Http500, "Internal server error")

  router.api(MethodGet,
             "/api/eth/v1/debug/beacon/heads") do () -> RestApiResponse:
    return RestApiResponse.jsonResponse(
      node.chainDag.heads.mapIt((root: it.root, slot: it.slot))
    )
