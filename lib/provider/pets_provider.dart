import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog_share/consts/collections.dart';
import 'package:dog_share/models/petsDataModel.dart';
import 'package:flutter/cupertino.dart';

class PetsProvider with ChangeNotifier {
  List<PetsDataModel> _allPets = [];
  List<PetsDataModel> get allPets {
    return [..._allPets];
  }

  Future<void> fetchProducts() async {
    print('Fetch method is called');
    //TODO: change it to pet data ref
    await petsDataRef.get().then((QuerySnapshot petsSnapshot) {
      print('Pets snapshot is called');
      print(petsSnapshot.docs);
      _allPets = [];
      _allPets = petsSnapshot.docs
          .map((doc) => PetsDataModel.fromDocument(doc))
          .toList();
      print(_allPets);
    });
  }

  List<PetsDataModel> get popularProducts {
    return _allPets.toList();
  }

  PetsDataModel findById(String productId) {
    return _allPets.firstWhere((element) => element.petId == productId);
  }

  List<PetsDataModel> findByCategory(String categoryName) {
    List<PetsDataModel> _categoryList = _allPets
        .where((element) =>
            element.petName!.toLowerCase().contains(categoryName.toLowerCase()))
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
            element.petName!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }
}
