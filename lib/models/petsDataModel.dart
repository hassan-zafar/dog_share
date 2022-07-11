import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PetsDataModel with ChangeNotifier{
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? phoneNo;
  final String? password;
  final Timestamp? createdAt;
  final String? joinedAt;
  final bool? isAdmin;
  final String? email;
  final String? androidNotificationToken;
  final bool? isGuest;

  // final Map? sectionsAppointed;
  PetsDataModel(
      {this.id,
      this.name,
      this.phoneNo,
      this.password,
      this.createdAt,
      this.isAdmin,
      this.email,
      this.joinedAt,
      this.isGuest,
      this.imageUrl,
      this.androidNotificationToken});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNo': phoneNo,
      'password': password,
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
        id: map['id'],
        name: map['userName'],
        phoneNo: map['phoneNo'],
        password: map['password'],
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
      id: doc.data()["id"],
      password: doc.data()["password"],
      name: doc.data()["name"],
      createdAt: doc.data()["createdAt"],
      email: doc.data()["email"],
      imageUrl: doc.data()["imageUrl"],
      isAdmin: doc.data()["isAdmin"],
      isGuest: doc.data()["isGuest"],
      phoneNo: doc.data()["phoneNo"],
      joinedAt: doc.data()["joinedAt"],
      androidNotificationToken: doc.data()["androidNotificationToken"],
    );
  }

  //String toJson() => json.encode(toMap());

  factory PetsDataModel.fromJson(String source) =>
      PetsDataModel.fromMap(json.decode(source));
}