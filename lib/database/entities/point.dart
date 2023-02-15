class Point{
  final int id;
  final double value;
  final DateTime creationTime;
  final int attributeId;
  final int teamId;
  final int userId;

  Point(this.id, this.value, this.creationTime, this.attributeId, this.teamId, this.userId);

  Map<String, dynamic> toMap(){
    return {
      'value': value,
      'creationTime': creationTime,
      'pointId': attributeId,
      'teamId': teamId,
      'userId': userId
    };
  }
}