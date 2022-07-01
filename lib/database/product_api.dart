import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_share/models/users.dart';

class ProductAPI {
  static const String _collection = 'users';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  Future<void> addProduct(AppUserModel product) async {
    await _instance
        .collection(_collection)
        .doc(product.id)
        .set(product.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllUsers() async {
    return await _instance.collection(_collection).get();
  }

  Future<List<AppUserModel>> searchUsers(String name) async {
    QuerySnapshot<Map<String, dynamic>> _doc = await FirebaseFirestore.instance
        .collection(_collection)
        .where('name', isGreaterThanOrEqualTo: name.toUpperCase())
        .get();
    List<AppUserModel> _products = <AppUserModel>[];
    for (DocumentSnapshot<Map<String, dynamic>> docss in _doc.docs) {
      _products.add(AppUserModel.fromDocument(docss));
    }
    return _products;
  }
}
