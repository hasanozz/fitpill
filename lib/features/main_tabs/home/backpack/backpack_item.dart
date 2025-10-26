class BackpackItem {
  final String name;
  final bool isSelected;
  final int index;
  final String? iconKey;

  BackpackItem({
    required this.name,
    this.isSelected = false,
    this.index = 0,
    this.iconKey,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'isSelected': isSelected,
        'index': index,
        if (iconKey != null) 'iconKey': iconKey,
      };

  factory BackpackItem.fromJson(Map<String, dynamic> json) {
    return BackpackItem(
      name: json['name'] ?? '',
      isSelected: json['isSelected'] ?? false,
      index: json['index'] ?? 0,
      iconKey: json['iconKey'] as String?,
    );
  }

  BackpackItem copyWith({
    String? name,
    bool? isSelected,
    int? index,
    String? iconKey,
  }) {
    return BackpackItem(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      index: index ?? this.index,
      iconKey: iconKey ?? this.iconKey,
    );
  }
}
