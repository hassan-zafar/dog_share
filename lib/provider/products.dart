import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_share/consts/collections.dart';
import 'package:dog_share/models/petsDataModel.dart';
import 'package:flutter/cupertino.dart';

class AllUsers with ChangeNotifier {
  List<PetsDataModel> _allPets = [];
  List<PetsDataModel> get allUsers {
    return [..._allPets];
  }

  Future<void> fetchProducts() async {
    print('Fetch method is called');
    await petsDataRef
        .get()
        .then((QuerySnapshot userSnapshot) {
      _allPets = [];
      userSnapshot.docs.forEach((element) {
        // print('element.get(productBrand), ${element.get('productBrand')}');
        _allPets.insert(0, PetsDataModel.fromDocument(element));
        PetsDataModel(
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

  List<PetsDataModel> get popularProducts {
    return _allPets.where((element) => element.isAdmin!).toList();
  }

  PetsDataModel findById(String productId) {
    return _allPets.firstWhere((element) => element.id == productId);
  }

  List<PetsDataModel> findByCategory(String categoryName) {
    List<PetsDataModel> _categoryList = _allPets
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

  List<PetsDataModel> searchQuery(String searchText) {
    List<PetsDataModel> _searchList = _allPets
        .where((element) =>
            element.name!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }
}
