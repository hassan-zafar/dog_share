import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog_share/consts/colors.dart';
import 'package:dog_share/consts/my_icons.dart';
import 'package:dog_share/inner_screens/service_details.dart';
import 'package:dog_share/provider/cart_provider.dart';
import 'package:dog_share/provider/favs_provider.dart';
import 'package:dog_share/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FeedDialog extends StatelessWidget {
  final String productId;
   const FeedDialog({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<AllUsers>(context, listen: false);

    final cartProvider = Provider.of<FavouriteProvider>(context);

    final favsProvider = Provider.of<FavsProvider>(context);

    final prodAttr = productsData.findById(productId);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child:  CachedNetworkImage(
                 imageUrl: 
              prodAttr.imageUrl!,
            ),
          ),
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: dialogContent(
                        context,
                        0,
                        () => {
                              favsProvider.addAndRemoveFromFav(
                                  productId,
                                  prodAttr.name!,
                                  prodAttr.imageUrl!),
                              Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : null
                            }),
                  ),
                  Flexible(
                    child: dialogContent(
                        context,
                        1,
                        () => {
                              Navigator.pushNamed(
                                      context, ServiceDetailsScreen.routeName,
                                      arguments: prodAttr.id)
                                  .then((value) => Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null),
                            }),
                  ),
                  Flexible(
                    child: dialogContent(
                      context,
                      2,
                      cartProvider.getCartItems.containsKey(productId)
                          ? () {}
                          : () {
                              cartProvider.addProductToCart(
                                  productId,
                                  prodAttr.name!,
                                  prodAttr.imageUrl!);
                              Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : null;
                            },
                    ),
                  ),
                ]),
          ),

          /************close****************/
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.3),
                shape: BoxShape.circle),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.grey,
                onTap: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close, size: 28, color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget dialogContent(BuildContext context, int index, VoidCallback fct) {
    final cart = Provider.of<FavouriteProvider>(context);
    final favs = Provider.of<FavsProvider>(context);
    List<IconData> _dialogIcons = [
      favs.getFavsItems.containsKey(productId)
          ? Icons.favorite
          : Icons.favorite_border,
      FontAwesomeIcons.eye,
      MyAppIcons.favourite,
    ];

    List<String> _texts = [
      favs.getFavsItems.containsKey(productId)
          ? 'In wishlist'
          : 'Add to wishlist',
      'View product',
      cart.getCartItems.containsKey(productId) ? 'In Cart ' : 'Add to cart',
    ];
    List<Color> _colors = [
      favs.getFavsItems.containsKey(productId)
          ? Colors.red
          : Theme.of(context).textSelectionColor,
      Theme.of(context).textSelectionColor,
      Theme.of(context).textSelectionColor,
    ];
    return FittedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: fct,
          splashColor: Colors.grey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    // inkwell color
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          _dialogIcons[index],
                          color: _colors[index],
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      _texts[index],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        //  fontSize: 15,
                        color: ColorsConsts.subTitle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
