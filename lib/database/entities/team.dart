class Team{
  final int id;
  final String name;

  Team(this.id, this.name);

  Map<String, dynamic> toMap(){
    return {
      'name': name,
    };
  }

  @override
  String toString() {
    return name;
  }
}