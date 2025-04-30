import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Retrieve documents from a collection
  static Future<List<Map<String, dynamic>>> getDocuments(
      String collectionPath) async {
    try {
      final querySnapshot = await _firestore.collection(collectionPath).get();
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Error retrieving documents: $e');
    }
  }

  // Add a document to a collection
  static Future<void> addDocument(
      String collectionPath, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).add(data);
    } catch (e) {
      throw Exception('Error adding document: $e');
    }
  }

  static Future<void> setDocument(
      String collectionPath, Map<String, dynamic> data, int userId) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(userId.toString())
          .set(data);
    } catch (e) {
      throw Exception('Error adding document: $e');
    }
  }

  // Edit a document in a collection
  Future<void> editDocument(String collectionPath, String documentId,
      Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).update(data);
    } catch (e) {
      throw Exception('Error editing document: $e');
    }
  }

  // Delete a document from a collection
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
    } catch (e) {
      throw Exception('Error deleting document: $e');
    }
  }
}
