class SpecialtyModel {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  SpecialtyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory SpecialtyModel.fromJson(Map<String, dynamic> json) {
    return SpecialtyModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'SpecialtyModel(id: $id, name: $name)';
  }
}
