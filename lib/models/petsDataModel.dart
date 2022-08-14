import 'dart:convert';

import 'package:flutter/cupertino.dart';

class PetsDataModel with ChangeNotifier {
  final String? petId;
  final String? petName;
  final String? petImage;
  final String? age;
  final String? petGender;
  final String? joinedAt;
  final bool? isMale;
  final String? petBreed;
  final String? userId;
  final String? petDescription;

  // final Map? sectionsAppointed;
  PetsDataModel(
      {this.petId,
      this.petName,
      this.petGender,
      this.age,
      this.isMale,
      this.petBreed,
      this.joinedAt,
      this.petImage,this.userId,
      this.petDescription});

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'userId': userId,
      'petName': petName,
      'petGender': petGender,
      'isMale': isMale,
      'petBreed': petBreed,
      'joinedAt': joinedAt,
      'petImage': petImage,
      'petDescription': petDescription,
    };
  }

  factory PetsDataModel.fromMap(Map<String, dynamic> map) {
    return PetsDataModel(
        petId: map['petId'],
        petName: map['petName'],
        petGender: map['petGender'],
        petImage: map['petImage'],
        isMale: map['isMale'],
        petBreed: map['petBreed'],
        petDescription: map ['petDescription'],
        userId: map ['userId']);
  }

  factory PetsDataModel.fromDocument(doc) {
    return PetsDataModel(
      petId: doc.data()["petId"],
      petGender: doc.data()["petGender"],
      petName: doc.data()["petName"],
      petBreed: doc.data()["petBreed"],
      petImage: doc.data()["petImage"],
      isMale: doc.data()["isMale"],
      userId: doc.data()["userId"],
      petDescription: doc.data()["petDescription"],
    );
  }

  //String toJson() => json.encode(toMap());

  factory PetsDataModel.fromJson(String source) =>
      PetsDataModel.fromMap(json.decode(source));
}
