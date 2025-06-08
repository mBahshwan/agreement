class BicycleModel {
  final String? name;

  BicycleModel({this.name});
  BicycleModel copyWith({String? name}) {
    return BicycleModel(
      name: name ?? this.name,
    );
  }

  factory BicycleModel.fromFirestore(Map<String, dynamic> data) {
    return BicycleModel(
      name: data['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
