import 'constants.dart';

class MoveoOneData {
  final String semanticGroup;
  final String id;
  final MoveoOneType type;
  final MoveoOneAction action;
  final dynamic value;
  final Map<String, String> metadata;

  MoveoOneData({
    required this.semanticGroup,
    required this.id,
    required this.type,
    required this.action,
    required this.value,
    required this.metadata,
  });

  // Factory constructor to create an instance from a JSON map
  factory MoveoOneData.fromJson(Map<String, dynamic> json) {
    return MoveoOneData(
      semanticGroup: json['semanticGroup'] as String,
      id: json['id'] as String,
      type: MoveoOneType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => MoveoOneType.custom, // Default to custom if not found
      ),
      action: MoveoOneAction.values.firstWhere(
        (e) => e.value == json['action'],
        orElse: () => MoveoOneAction.custom, // Default to custom if not found
      ),
      value: json['value'],
      metadata: Map<String, String>.from(json['metadata'] ?? {}),
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'semanticGroup': semanticGroup,
      'id': id,
      'type': type.value,
      'action': action.value,
      'value': value,
      'metadata': metadata,
    };
  }
}