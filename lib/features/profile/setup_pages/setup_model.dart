class SetupData {
  final DateTime? birthDate;
  final String? gender;
  final String? height;
  final String? weight;

  const SetupData({
    this.birthDate,
    this.gender,
    this.height,
    this.weight,
  });

  SetupData copyWith({
    DateTime? birthDate,
    String? gender,
    String? height,
    String? weight,
  }) {
    return SetupData(
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }
}
