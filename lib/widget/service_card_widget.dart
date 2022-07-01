import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog_share/consts/collections.dart';
import 'package:dog_share/models/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dog_share/consts/colors.dart';
import 'package:dog_share/consts/my_icons.dart';
import 'package:dog_share/inner_screens/service_details.dart';
import 'package:dog_share/provider/cart_provider.dart';
import 'package:dog_share/provider/favs_provider.dart';
import 'package:dog_share/provider/products.dart';
import '../../../../utilities/custom_images.dart';
import '../../../../utilities/utilities.dart';

class ServiceCardWidget extends StatelessWidget {
  const ServiceCardWidget({required this.user, Key? key}) : super(key: key);
  final AppUserModel user;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<FavouriteProvider>(context);

    final favsProvider = Provider.of<FavsProvider>(context);
    final productsData = Provider.of<AllUsers>(context, listen: false);
    // final userAttributes  = Provider.of<AppUserModel>(context);

    final prodAttr = productsData.findById(user.id!);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ServiceDetailsScreen.routeName,
            arguments: currentUser!.id);
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 4, horizontal: Utilities.padding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 2 / 1,
                child: (user.imageUrl == null || user.imageUrl!.isEmpty)
                    ? Image.asset(CustomImages.icon, fit: BoxFit.contain)
                    : CachedNetworkImage(
                        imageUrl: user.imageUrl!, fit: BoxFit.contain),
              ),
              Badge(
                alignment: Alignment.center,
                toAnimate: true,
                shape: BadgeShape.square,
                badgeColor: Colors.pink,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
                badgeContent: const Text(
                  'New',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(Utilities.padding / 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.9)
                      ],
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              user.name!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${user.joinedAt}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          favsProvider.addAndRemoveFromFav(
                              user.id!,
                              double.parse(prodAttr.phoneNo!),
                              prodAttr.name!,
                              prodAttr.imageUrl!);
                        },
                        icon: Icon(
                          favsProvider.getFavsItems
                                  .containsKey(user.id)
                              ? Icons.favorite
                              : MyAppIcons.wishlist,
                          color: favsProvider.getFavsItems
                                  .containsKey(user.id)
                              ? Colors.red
                              : ColorsConsts.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cartProvider.addProductToCart(
                              user.id!,
                              double.parse(prodAttr.phoneNo!),
                              prodAttr.name!,
                              prodAttr.imageUrl!);
                        },
                        icon: cartProvider.getCartItems
                                .containsKey(user.id)
                            ?  Icon(MyAppIcons.favouriteOutlined)
                            :  Icon(MyAppIcons.favourite),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
