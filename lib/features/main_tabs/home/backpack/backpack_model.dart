class BackpackBag {
  final String id;
  final String name;

  BackpackBag({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  factory BackpackBag.fromJson(String id, Map<String, dynamic> json) {
    return BackpackBag(
      id: id,
      name: json['name'] ?? '',
    );
  }

  BackpackBag copyWith({
    String? id,
    String? name,
  }) {
    return BackpackBag(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
