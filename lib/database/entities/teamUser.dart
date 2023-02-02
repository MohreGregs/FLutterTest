class TeamUser{
  final int id;
  final int userId;
  final int teamId;

  TeamUser(this.id, this.userId, this.teamId);

  Map<String, dynamic> toMap(){
    return {
      'userId': userId,
      'teamId': teamId,
    };
  }
}