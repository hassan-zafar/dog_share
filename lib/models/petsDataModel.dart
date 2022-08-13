import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PetsDataModel with ChangeNotifier {
  final String? petId;
  final String? petName;
  final String? imageUrl;
  final String? age;
  final String? petGender;
  final Timestamp? createdAt;
  final String? joinedAt;
  final bool? isAdmin;
  final String? email;
  final String? androidNotificationToken;
  final bool? isGuest;

  // final Map? sectionsAppointed;
  PetsDataModel(
      {this.petId,
      this.petName,
      this.petGender,
      this.age,
      this.createdAt,
      this.isAdmin,
      this.email,
      this.joinedAt,
      this.isGuest,
      this.imageUrl,
      this.androidNotificationToken});

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'petName': petName,
      'petGender': petGender,
      'createdAt': createdAt,
      'isAdmin': isAdmin,
      'email': email,
      'joinedAt': joinedAt,
      'imageUrl': imageUrl,
      'isGuest': isGuest,
      'androidNotificationToken': androidNotificationToken,
    };
  }

  factory PetsDataModel.fromMap(Map<String, dynamic> map) {
    return PetsDataModel(
        petId: map['petId'],
        petName: map['petName'],
        petGender: map['petGender'],
        createdAt: map['createdAt'],
        imageUrl: map['imageUrl'],
        isAdmin: map['isAdmin'],
        email: map['email'],
        isGuest: map['isGuest'],
        joinedAt: map['joinedAt'],
        androidNotificationToken: map['androidNotificationToken']);
  }

  factory PetsDataModel.fromDocument(doc) {
    return PetsDataModel(
      petId: doc.data()["petId"],
      petGender: doc.data()["petGender"],
      petName: doc.data()["petName"],
      createdAt: doc.data()["createdAt"],
      email: doc.data()["email"],
      imageUrl: doc.data()["imageUrl"],
      isAdmin: doc.data()["isAdmin"],
      isGuest: doc.data()["isGuest"],
      joinedAt: doc.data()["joinedAt"],
      androidNotificationToken: doc.data()["androidNotificationToken"],
    );
  }

  //String toJson() => json.encode(toMap());

  factory PetsDataModel.fromJson(String source) =>
      PetsDataModel.fromMap(json.decode(source));
}
