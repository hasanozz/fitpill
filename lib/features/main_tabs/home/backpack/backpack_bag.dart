class BackpackBag {
  final String id;
  final String name;
  final bool isDefault;

  BackpackBag({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'isDefault': isDefault,
      };

  factory BackpackBag.fromJson(String id, Map<String, dynamic> json) {
    return BackpackBag(
      id: id,
      name: json['name'] ?? '',
      isDefault: (json['isDefault'] as bool?) ?? false,
    );
  }

  BackpackBag copyWith({
    String? id,
    String? name,
    bool? isDefault,
  }) {
    return BackpackBag(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
