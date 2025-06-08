import 'package:agreement_app/app/home_page/home_page.dart';
import 'package:agreement_app/app/models/bicycle_model.dart';
import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/core/constant/firebase_client.dart';
import 'package:agreement_app/core/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_agreement_view_model.g.dart';

@riverpod
class CreateAgreementViewModel extends _$CreateAgreementViewModel {
  @override
  AsyncValue<UserModel> build() {
    // Initialize any state or perform setup here
    return const AsyncLoading();
  }

  Future<void> createAgreement(
      UserModel newAgreement, BuildContext context) async {
    try {
      // 1. Get all documents to find if our specific user exists
      final allDocuments = await FirebaseClient.getDocuments('visitors');

      // 2. Find the document with matching userId
      Map<String, dynamic>? existingUserDoc;
      for (var doc in allDocuments) {
        if (doc['userId'] == newAgreement.userId) {
          existingUserDoc = doc;
          break;
        }
      }

      UserModel updatedUser;

      if (existingUserDoc != null) {
        // 3. Document exists - update existing agreements
        final currentUser = UserModel.fromFirestore(existingUserDoc);
        updatedUser = currentUser.copyWith(
          agreements: [
            ...(currentUser.agreements ?? []),
            ...(newAgreement.agreements ?? []),
          ],
        );
      } else {
        // 4. Document doesn't exist - use the new agreement as is
        updatedUser = newAgreement;
      }

      // 5. Update or create the document
      await FirebaseClient.setDocument(
        'visitors',
        updatedUser.toMap(),
        updatedUser.userId!,
      );

      // 6. Navigate after successful update
      Helpers.navigateToPushAndRemoveUntil(context, HomePage());
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.empty);
    }
  }

  void setDuration(String newDuration) {
    // Ensure we have valid data
    state = AsyncData(UserModel(duration: newDuration));
  }
}

final bicycleFieldsProvider =
    StateNotifierProvider<BicycleFieldsNotifier, List<BicycleField>>((ref) {
  return BicycleFieldsNotifier();
});

class BicycleField {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  String? selectedBicycle; // Add this line to track dropdown selection

  BicycleField()
      : nameController = TextEditingController(),
        descriptionController = TextEditingController();

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
  }
}

class BicycleFieldsNotifier extends StateNotifier<List<BicycleField>> {
  BicycleFieldsNotifier() : super([BicycleField()]);

  void addField() {
    state = [...state, BicycleField()];
  }

  void removeField(int index) {
    if (state.length > 1) {
      state[index].dispose();
      state = [...state]..removeAt(index);
    }
  }

  @override
  void dispose() {
    for (var field in state) {
      field.dispose();
    }
    super.dispose();
  }
}

final bicyclesProvider = FutureProvider<List<BicycleModel>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('bikes').get();
  return snapshot.docs
      .map((doc) => BicycleModel.fromFirestore(doc.data()))
      .toList();
});
