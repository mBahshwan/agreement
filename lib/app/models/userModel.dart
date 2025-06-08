import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  int? phoneNumber;
  String? name;
  int? userId;
  int? visitingCount;
  List<Agreement>? agreements;
  String? duration;

  UserModel(
      {this.name,
      this.phoneNumber,
      this.userId,
      this.visitingCount,
      this.agreements,
      this.duration});
  UserModel copyWith({
    String? name,
    int? phoneNumber,
    int? userId,
    int? visitingCount,
    List<Agreement>? agreements,
    String? duration,
  }) {
    return UserModel(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        name: name ?? this.name,
        userId: userId ?? this.userId,
        visitingCount: visitingCount ?? this.visitingCount,
        agreements: agreements ?? this.agreements,
        duration: duration ?? this.duration);
  }

  // Factory method to create a UserModel from a Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> doc) {
    Map<String, dynamic> data = doc;
    return UserModel(
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'] ?? 0,
      agreements: (data['agreements'] as List<dynamic>?)
          ?.map((e) => Agreement.fromFirestore(e))
          .toList(),
      userId: data['userId'] ?? '',
      visitingCount: data['visitingCount'] ?? 0,
    );
  }

  // Method to convert UserModel to a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'visitingCount': agreements?.length ?? 1,
      'agreements': agreements?.map((agreement) => agreement.toMap()).toList(),
    };
  }
}

class Agreements {
  List<Agreement>? agreements;
  Agreements({this.agreements});
  Agreements copyWith({List<Agreement>? agreements}) {
    return Agreements(
      agreements: agreements ?? this.agreements,
    );
  }

  factory Agreements.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Agreements(
      agreements: (data['agreements'] as List<dynamic>?)
          ?.map((e) => Agreement.fromFirestore(e))
          .toList(),
    );
  }

  // Method to convert Agreements to a map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'agreements': agreements?.map((agreement) => agreement.toMap()).toList(),
    };
  }
}

class Agreement {
  String? bicycleName;
  String? description;
  List<String>? bicycleNames;
  List<String>? bicycleDesctiptions;
  int? duration;
  DateTime? timeStart;
  DateTime? timeEnd;
  int? userId;
  AgreementState? state;

  Agreement({
    this.bicycleName,
    this.description,
    this.bicycleNames,
    this.bicycleDesctiptions,
    this.timeStart,
    this.duration,
    this.timeEnd,
    this.userId,
    this.state = AgreementState.PENDING,
  });
  Agreement copyWith({
    String? bicycleName,
    String? description,
    List<String>? bicycleNames,
    List<String>? bicycleDesctiptions,
    DateTime? timeStart,
    DateTime? timeEnd,
    int? duration,
    int? userId,
    AgreementState? state,
  }) {
    return Agreement(
      bicycleName: bicycleName ?? this.bicycleName,
      description: description ?? this.description,
      bicycleDesctiptions: bicycleDesctiptions ?? this.bicycleDesctiptions,
      bicycleNames: bicycleNames ?? this.bicycleNames,
      timeStart: timeStart ?? this.timeStart,
      timeEnd: timeEnd ?? this.timeEnd,
      userId: userId ?? this.userId,
      duration: duration ?? this.duration,
      state: state ?? this.state,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bicycleNames': bicycleNames,
      'bicycleDescriptions': bicycleDesctiptions,
      'duration': duration,
      'userId': userId,
      'timeStart': timeStart != null ? Timestamp.fromDate(timeStart!) : null,
      'timeEnd': timeEnd != null ? Timestamp.fromDate(timeEnd!) : null,
      'state': state != null ? agreementStateValues.reverse[state] : null,
    };
  }

  factory Agreement.fromFirestore(Map<String, dynamic> doc) {
    Map<String, dynamic> data = doc;
    return Agreement(
      bicycleNames:
          (data['bicycleNames'] as List<dynamic>?)?.cast<String>() ?? [],
      bicycleDesctiptions:
          (data['bicycleDescriptions'] as List<dynamic>?)?.cast<String>() ?? [],
      duration: data['duration'] ?? 0,
      timeStart: (data['timeStart'] as Timestamp?)?.toDate(),
      timeEnd: (data['timeEnd'] as Timestamp?)?.toDate(),
      userId: data['userId'] ?? '',
      state: data['state'] != null
          ? agreementStateValues.map[data['state']]
          : AgreementState.PENDING,
    );
  }
}

// Enum moved to the top level
enum AgreementState { ACTIVE, EXPIRED, PENDING }

final agreementStateValues = EnumValues(
  {
    'ACTIVE': AgreementState.ACTIVE,
    'EXPIRED': AgreementState.EXPIRED,
    'PENDING': AgreementState.PENDING,
  },
);

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
