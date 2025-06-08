import 'package:agreement_app/app/home_page/home_page.dart';
import 'package:agreement_app/app/models/bicycle_model.dart';
import 'package:agreement_app/core/constant/firebase_client.dart';
import 'package:agreement_app/core/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_bicycle_view_model.g.dart';

@riverpod
class AddBicycleViewModel extends _$AddBicycleViewModel {
  @override
  BicycleModel build() {
    // Initialize any state or perform setup here
    return BicycleModel();
  }

  void setName(String newName) {
    state = state.copyWith(name: newName);
  }

  Future<void> addBicycle(BuildContext context) async {
    try {
      if (state.name?.isNotEmpty ?? false) {
        await FirebaseClient.addDocument("bikes", state.toJson());
        Helpers.navigateToPush(context, HomePage());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
