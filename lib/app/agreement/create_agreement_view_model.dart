import 'package:agreement_app/app/home_page/home_page.dart';
import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/core/constant/firebase_client.dart';
import 'package:agreement_app/core/helpers.dart';
import 'package:flutter/material.dart';
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
      // 1. Fetch the current user data from Firestore
      // Fetch the current user data from Firestore using a proper fetch method
      final currentUserDataList = await FirebaseClient.getDocuments(
        'visitors',
      );

      if (currentUserDataList == null || currentUserDataList.isEmpty) {
        throw Exception('User not found');
      }

      // Assuming you want the first document from the list
      final currentUserData = currentUserDataList.first;

      // 2. Parse the existing user model
      final currentUser = UserModel.fromFirestore(currentUserData);

      // 3. Create an updated user with the new agreement appended
      final updatedUser = currentUser.copyWith(
        agreements: [
          ...(currentUser.agreements ?? []), // Keep existing agreements
          ...(newAgreement.agreements ?? []), // Add new agreement(s)
        ],
      );

      // 4. Update Firestore with the modified user data
      await FirebaseClient.setDocument(
        'visitors',
        updatedUser.toMap(),
        updatedUser.userId!,
      );

      // 5. Navigate after successful update
      Helpers.navigateToPushAndRemoveUntil(context, HomePage());
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.empty);
    }
  }
}
