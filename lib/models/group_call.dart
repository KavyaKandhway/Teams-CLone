class GroupCall {
  String callerId;
  String roomId;
  bool hasDialed;

  GroupCall({
    this.callerId,
    this.roomId,
    this.hasDialed,
  });

  Map<String, dynamic> toMap(GroupCall call) {
    Map<String, dynamic> callMap = Map();
    callMap["caller_id"] = call.callerId;
    callMap["room_id"] = call.roomId;
    callMap["has_dialed"] = call.hasDialed;
    return callMap;
  }

  GroupCall.fromMap(Map callMap) {
    this.callerId = callMap["caller_id"];
    this.roomId = callMap["room_id"];
    this.hasDialed = callMap["has_dialed"];
  }
}
