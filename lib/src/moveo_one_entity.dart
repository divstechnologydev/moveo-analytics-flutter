class MoveoOneEntity {
  final String c; // Context
  final String type;
  final String userId;
  final int t; // Timestamp
  final Map<String, String> prop;
  final Map<String, String> meta;
  final Map<String, String> additionalMeta;
  final String sId;

  MoveoOneEntity({
    required this.c,
    required this.type,
    required this.userId,
    required this.t,
    required this.prop,
    required this.meta,
    this.additionalMeta = const {},
    required this.sId,
  });

  // Factory constructor to create an instance from a JSON map
  factory MoveoOneEntity.fromJson(Map<String, dynamic> json) {
    return MoveoOneEntity(
      c: json['c'] as String,
      type: json['type'] as String,
      userId: json['userId'] as String,
      t: json['t'] as int,
      prop: Map<String, String>.from(json['prop'] ?? {}),
      meta: Map<String, String>.from(json['meta'] ?? {}),
      additionalMeta: Map<String, String>.from(json['additionalMeta'] ?? {}),
      sId: json['sId'] as String,
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'c': c,
      'type': type,
      'userId': userId,
      't': t,
      'prop': prop,
      'meta': meta,
      'additionalMeta': additionalMeta,
      'sId': sId,
    };
  }
}