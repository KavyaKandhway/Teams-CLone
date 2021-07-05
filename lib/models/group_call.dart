class GroupCall {
  String roomId;

  GroupCall({
    this.roomId,
  });

  Map<String, dynamic> toMap(GroupCall call) {
    Map<String, dynamic> callMap = Map();

    callMap["room_id"] = call.roomId;

    return callMap;
  }

  GroupCall.fromMap(Map callMap) {
    this.roomId = callMap["room_id"];
  }
}
