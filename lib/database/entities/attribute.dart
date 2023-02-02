class Attribute{
  final int id;
  final String name;
  final int threshold;
  final int rangeStart;
  final int rangeEnd;

  Attribute(this.id, this.name, this.threshold, this.rangeStart, this.rangeEnd);

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'threshold': threshold,
      'rangeStart': rangeStart,
      'rangeEnd': rangeEnd,
    };
  }
}