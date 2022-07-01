import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_share/models/users.dart';
import 'package:flutter/cupertino.dart';

class AllUsers with ChangeNotifier {
  List<AppUserModel> _allUsers = [];
  List<AppUserModel> get allUsers {
    return [..._allUsers];
  }

  Future<void> fetchProducts() async {
    print('Fetch method is called');
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot userSnapshot) {
      _allUsers = [];
      userSnapshot.docs.forEach((element) {
        // print('element.get(productBrand), ${element.get('productBrand')}');
        _allUsers.insert(0, AppUserModel.fromDocument(element));
        AppUserModel(
          id: element.get("id"),
          password: element.get("password"),
          name: element.get("name"),
          createdAt: element.get("createdAt"),
          email: element.get("email"),
          imageUrl: element.get("imageUrl"),
          isAdmin: element.get("isAdmin"),
          isGuest: element.get("isGuest"),
          phoneNo: element.get("phoneNo"),
          joinedAt: element.get("joinedAt"),
          androidNotificationToken: element.get("androidNotificationToken"),
        );
      });
    });
  }

  List<AppUserModel> get popularProducts {
    return _allUsers.where((element) => element.isAdmin!).toList();
  }

  AppUserModel findById(String productId) {
    return _allUsers.firstWhere((element) => element.id == productId);
  }

  List<AppUserModel> findByCategory(String categoryName) {
    List<AppUserModel> _categoryList = _allUsers
        .where((element) =>
            element.name!.toLowerCase().contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  // List<Product> findByBrand(String brandName) {
  //   List<Product> _categoryList = _products
  //       .where((element) =>
  //           element.brand!.toLowerCase().contains(brandName.toLowerCase()))
  //       .toList();
  //   return _categoryList;
  // }

  List<AppUserModel> searchQuery(String searchText) {
    List<AppUserModel> _searchList = _allUsers
        .where((element) =>
            element.name!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }
}
