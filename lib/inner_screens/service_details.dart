import 'package:badges/badges.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:dog_share/cart/cart.dart';
import 'package:dog_share/consts/collections.dart';
import 'package:dog_share/consts/colors.dart';
import 'package:dog_share/consts/my_icons.dart';
import 'package:dog_share/consts/universal_variables.dart';
import 'package:dog_share/inner_screens/productComments.dart';
import 'package:dog_share/models/users.dart';
import 'package:dog_share/provider/cart_provider.dart';
import 'package:dog_share/provider/favs_provider.dart';
import 'package:dog_share/provider/products.dart';
import 'package:dog_share/widget/serviceCardWidget.dart';
import 'package:dog_share/wishlist/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceDetailsScreen extends StatefulWidget {
  static const routeName = '/ServiceDetailsScreen';

  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  GlobalKey previewContainer =  GlobalKey();
  final TextEditingController _reviewController = TextEditingController();
  bool isUploading = false;
  List allReviews = [];

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<AllUsers>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final cartProvider = Provider.of<FavouriteProvider>(context);

    final favsProvider = Provider.of<FavsProvider>(context);
    print('productId $productId');
    final prodAttr = productsData.findById(productId);
    final productsList = productsData.allUsers;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: const BoxDecoration(color: Colors.black12),
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
            child: CachedNetworkImage(
              fit: BoxFit.contain,
              imageUrl: prodAttr.imageUrl!,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.55),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: <Widget>[
                //       Material(
                //         color: Colors.transparent,
                //         child: InkWell(
                //           splashColor: Colors.purple.shade200,
                //           onTap: () {},
                //           borderRadius: BorderRadius.circular(30),
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Icon(
                //               Icons.save,
                //               size: 23,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //       Material(
                //         color: Colors.transparent,
                //         child: InkWell(
                //           splashColor: Colors.purple.shade200,
                //           onTap: () {},
                //           borderRadius: BorderRadius.circular(30),
                //           child: Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: Icon(
                //               Icons.share,
                //               size: 23,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                Container(
                  //padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                prodAttr.name!,
                                maxLines: 2,
                                style: const TextStyle(
                                  // color: Theme.of(context).textSelectionColor,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              prodAttr.phoneNo!,
                              style: TextStyle(
                                color: ColorsConsts.subTitle,
                                fontWeight: FontWeight.bold,
                                // fontSize: 21.0
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          prodAttr.phoneNo!,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                        height: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Text(
                    'Potential Matches:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  height: 120,
                  child: ListView.builder(
                    itemCount:
                        productsList.length < 7 ? productsList.length : 7,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                          value: productsData.allUsers[index],
                          //  productsList[index],
                          child: ServiceCardWidget());
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "DETAIL",
                style: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.normal),
              ),
              actions: <Widget>[
                Consumer<FavsProvider>(
                  builder: (_, favs, ch) => Badge(
                    badgeColor: ColorsConsts.cartBadgeColor,
                    animationType: BadgeAnimationType.slide,
                    toAnimate: true,
                    position: BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                      favs.getFavsItems.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      icon: Icon(
                        MyAppIcons.wishlist,
                        color: ColorsConsts.favColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(LikedScreen.routeName);
                      },
                    ),
                  ),
                ),
                Consumer<FavouriteProvider>(
                  builder: (_, cart, ch) => Badge(
                    badgeColor: ColorsConsts.cartBadgeColor,
                    animationType: BadgeAnimationType.slide,
                    toAnimate: true,
                    position: BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                      cart.getCartItems.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      icon: Icon(
                        MyAppIcons.favourite,
                        color: ColorsConsts.cartColor,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(MyBookingsScreen.routeName);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50,
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape:
                          const RoundedRectangleBorder(side: BorderSide.none),
                      color: Theme.of(context).primaryColor,
                      onPressed:
                          cartProvider.getCartItems.containsKey(productId)
                              ? () {}
                              : () {
                                  cartProvider.addProductToCart(
                                      productId,
                                      prodAttr.name!,
                                      prodAttr.imageUrl!);
                                },
                      child: Text(
                        cartProvider.getCartItems.containsKey(productId)
                            ? 'Liked'
                            : 'Like them'.toUpperCase(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: ColorsConsts.subTitle,
                    height: 50,
                    child: InkWell(
                      splashColor: ColorsConsts.favColor,
                      onTap: () {
                        favsProvider.addAndRemoveFromFav(
                            productId,
                            // double.parse(prodAttr.phoneNo!),
                            prodAttr.name!,
                            prodAttr.imageUrl!);
                      },
                      child: Center(
                        child: Icon(
                          favsProvider.getFavsItems.containsKey(productId)
                              ? Icons.favorite
                              : MyAppIcons.wishlist,
                          color:
                              favsProvider.getFavsItems.containsKey(productId)
                                  ? Colors.red
                                  : ColorsConsts.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget reviews({String? productId, AppUserModel? productItems}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Reviews",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        writeReviews(productItems!),
        Column(
          children: <Widget>[
            GestureDetector(
              child: buildReviews(
                  productId: productId!, productItems: productItems),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductComments(
                        isProductComment: true,
                        isPostComment: false,
                        // postMediaUrl: productItems.imageUrl,
                        postId: productItems.id,
                      ))),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  writeReviews(AppUserModel productItems) {
    return Column(
      children: [
        // Row(
        //   children: [
        //     SmoothStarRating(
        //       color: Colors.amberAccent,
        //       allowHalfRating: false,
        //       size: 20.0,
        //       isReadOnly: false,
        //       borderColor: Colors.white70,
        //       onRated: (rate) {
        //         int totalRatingNumbers = 0;
        //
        //         ratingsMap == null
        //             ? totalRatingNumbers = 0
        //             : totalRatingNumbers = ratingsMap.length;
        //         setState(() {
        //           avgRating =
        //               ((double.parse(rating.toString()) * totalRatingNumbers) +
        //                       rate) /
        //                   (totalRatingNumbers + 1);
        //           ratings = rate;
        //         });
        //       },
        //       defaultIconData: Icons.star_border,
        //       filledIconData: Icons.star,
        //       halfFilledIconData: Icons.star_half,
        //     ),
        //     SizedBox(
        //       width: 8.0,
        //     ),
        //   ],
        // ),
        ListTile(
          title: TextFormField(
            controller: _reviewController,
            decoration: InputDecoration(
                hintText: "Review",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          trailing: IconButton(
            onPressed: () => addReview(productItems: productItems),
            icon: isUploading
                ? const Text('')
                : const Icon(
                    Icons.send,
                    size: 40.0,
                    // color: Colors.black,
                  ),
          ),
        ),
      ],
    );
  }

  buildReviews({String? productId, AppUserModel? productItems}) {
    return StreamBuilder<QuerySnapshot>(
      stream: commentsRef
          .doc(productId)
          .collection("comments")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (!snapshot.hasData) {
          return LoadingIndicator();
        } else {
          snapshot.data!.docs.forEach((doc) {
            allReviews.add(ProductCommentMessages.fromDocument(doc));
          });
          return allReviews.isEmpty
              ? const Center(child: const Text("Currently No Review"))
              : Center(
                  child: Column(
                    children: [
                      Container(
                        child: allReviews.last,
                      ),
                      GestureDetector(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductComments(
                                        postId: productId,
                                        // postMediaUrl: productItems!.imageUrl,
                                        isAdmin: currentUser!.isAdmin,
                                        isPostComment: false,
                                        isProductComment: true,
                                      ))),
                          child: const Text(
                            'View All Reviews',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                );
        }
      },
    );
  }

  addReview({AppUserModel? productItems}) async {
    List allAdmins = [];
    QuerySnapshot snapshots =
        await userRef.where('isAdmin', isEqualTo: true).get();
    snapshots.docs.forEach((e) {
      allAdmins.add(AppUserModel.fromDocument(e));
    });

    String commentId = const Uuid().v4();
    setState(() {
      isUploading = true;
    });
    if (_reviewController.text.trim().length > 0) {
      await commentsRef.doc(productItems!.id).collection("comments").add({
        "userName": currentUser!.name,
        "userId": currentUser!.id,
        "androidNotificationToken": currentUser!.androidNotificationToken,
        "comment": _reviewController.text,
        "timestamp": DateTime.now(),
        "isComment": false,
        "isProductComment": true,
        "postId": productItems.id,
        "commentId": commentId,
        "likesMap": {},
        "likes": 0,
      });
      bool isNotProductOwner = currentUser!.isAdmin!;
      if (isNotProductOwner) {
        // allAdmins.forEach((element) {
        //   activityFeedRef.doc(element.id).collection('feedItems').add({
        //     "type": "comment",
        //     "commentData": _reviewController.text,
        //     "userName": currentUser.userName,
        //     "userId": currentUser.id,
        //     "userProfileImg": currentUser.photoUrl,
        //     "postId": widget.productItems.productId,
        //     "mediaUrl": widget.productItems.mediaUrl[0],
        //     "timestamp": timestamp,
        //   });
        //   sendAndRetrieveMessage(
        //       token: element.androidNotificationToken,
        //       message: _reviewController.text,
        //       title: "Product Comment");
        // });
      }
      BotToast.showText(text: 'Comment added');

      _reviewController.clear();
      setState(() {
        isUploading = false;
      });
    } else {
      // BotToast.showText(text: "Field shouldn't be left empty");
    }
    setState(() {
      isUploading = false;
    });
  }

  Widget _details(String title, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 16, right: 16),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            info,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
