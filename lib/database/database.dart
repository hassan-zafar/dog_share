import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dog_share/consts/collections.dart';
import 'package:dog_share/models/users.dart';
import 'package:dog_share/widget/custom_toast.dart';

import 'local_database.dart';

class DatabaseMethods {
  // Future<Stream<QuerySnapshot>> getproductData() async {
  //   return FirebaseFirestore.instance.collection(productCollection).snapshots();
  // }

  Future fetchCalenderDataFromFirebase(String userId, bool isMySession) async {
    final QuerySnapshot calenderMeetings = isMySession
        ? await calenderRef.where('id', isEqualTo: userId).get()
        : await calenderRef.get();
    return calenderMeetings;
  }

  Future fetchUserInfoFromFirebase({
    required String uid,
  }) async {
    final DocumentSnapshot _user = await userRef.doc(uid).get();
    currentUser = AppUserModel.fromDocument(_user);
    createToken(uid);
    LocalDB().setIsAdmin(currentUser!.isAdmin);
    // Map userData = json.decode(currentUser!.toJson());
    // UserLocalData().setUserModel(json.encode(userData));
    var user = LocalDB().getUserData();
    print(user);
    isAdmin = currentUser!.isAdmin;
    print(currentUser!.email);
  }

  createToken(String uid) {
    FirebaseMessaging.instance.getToken().then((token) {
      userRef.doc(uid).update({"androidNotificationToken": token});
      
      // UserLocalData().setToken(token!);
    });
  }

  addUserInfoToFirebase({
    required final String password,
    required final String? userName,
    required final String? joinedAt,
    required final int? phoneNo,
    required final String? imageUrl,
    required final Timestamp? createdAt,
    required final String email,
    required final String userId,
    final bool? isAdmin,
  }) {
    print("addUserInfoToFirebase");
    return userRef.doc(userId).set({
      'id': userId,
      'name': userName,
      'phoneNo': phoneNo,
      'password': password,
      'createdAt': createdAt,
      'isAdmin': isAdmin,
      'email': email,
      'joinedAt': joinedAt,
      'imageUrl': imageUrl,
      'androidNotificationToken': "",
    }).then((value) {
      // currentUser = userModel;
    }).catchError(
      (Object obj) {
        errorToast(message: obj.toString());
      },
    );
  }
}
