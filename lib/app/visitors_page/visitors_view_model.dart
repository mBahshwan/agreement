import 'package:agreement_app/app/models/userModel.dart';
import 'package:agreement_app/core/constant/firebase_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visitors_view_model.g.dart';

@riverpod
class VisitorsViewModel extends _$VisitorsViewModel {
  @override
  List<UserModel> build() {
    // Return an initial empty list or fetch initial data
    return [];
  }

  Future<void> getVisitors() async {
    try {
      final visitors = await FirebaseClient.getDocuments('visitors');
      final userModelList =
          visitors.map((element) => UserModel.fromFirestore(element)).toList();
      state = userModelList;
    } catch (e) {
      print('error $e');
    }
  }

  Future<UserModel?> fetchVisitorById(String id) async {
    try {
      final doc = await FirebaseClient.getDocumentById('visitors', id);
      if (doc != null) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('error $e');
      return null;
    }
  }

  Future<void> getVisitorById() async {
    try {
      final visitors = await FirebaseClient.getDocuments('visitors');
      final userModelList =
          visitors.map((element) => UserModel.fromFirestore(element)).toList();
      state = userModelList;
    } catch (e) {
      print('error $e');
    }
  }
}
