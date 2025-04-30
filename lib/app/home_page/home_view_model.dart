import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/core/constant/firebase_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  AsyncValue<Agreements> build() {
    // Initialize any state or perform setup here
    return const AsyncLoading();
  }

  Future<void> getAgreements() async {
    try {
      final data = await FirebaseClient.getDocuments('visitors');
      final visitors = data.map((e) => UserModel.fromFirestore(e)).toList();
      final List<Agreement> agreements = [];
      for (var visitor in visitors) {
        if (visitor.agreements != null) {
          agreements.addAll(visitor.agreements!);
        }
      }
      state = AsyncData(state.value?.copyWith(agreements: agreements) ??
          Agreements(agreements: agreements));
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.empty);
    }
  }
}
