import 'package:cached_network_image/cached_network_image.dart';
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
import '../models/petsDataModel.dart';

class ServiceCardWidget extends StatelessWidget {
  const ServiceCardWidget({required this.user, Key? key}) : super(key: key);
  final PetsDataModel user;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<FavouriteProvider>(context);
    final favsProvider = Provider.of<FavsProvider>(context);
    final productsData = Provider.of<PetsProvider>(context, listen: false);
    // final userAttributes  = Provider.of<AppUserModel>(context);

    final prodAttr = productsData.findById(user.petId!);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ServiceDetailsScreen.routeName,
            arguments: prodAttr.petId);
      },
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 4, horizontal: Utilities.padding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1 ,
                child: (user.imageUrl == null || user.imageUrl!.isEmpty)
                    ? Image.asset(CustomImages.icon, fit: BoxFit.fill)
                    : CachedNetworkImage(
                        imageUrl: user.imageUrl!, fit: BoxFit.fill),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      favsProvider.addAndRemoveFromFav(
                          user.petId!,
                          prodAttr.petName!,
                          prodAttr.imageUrl!);
                    },
                    icon: Icon(
                      favsProvider.getFavsItems.containsKey(user.petId)
                          ? Icons.favorite
                          : MyAppIcons.wishlist,
                      color: favsProvider.getFavsItems.containsKey(user.petId)
                          ? Colors.red
                          : ColorsConsts.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      cartProvider.addProductToCart(
                          user.petId!,
                          prodAttr.petName!,
                          prodAttr.imageUrl!);
                    },
                    icon: cartProvider.getCartItems.containsKey(user.petId)
                        ? Icon(MyAppIcons.favouriteOutlined)
                        : Icon(MyAppIcons.favourite),
                  ),
                ],
              ),
             
              // Badge(
              //   alignment: Alignment.center,
              //   toAnimate: true,
              //   shape: BadgeShape.square,
              //   badgeColor: Colors.pink,
              //   borderRadius: const BorderRadius.only(
              //     bottomRight: Radius.circular(8),
              //   ),
              //   badgeContent: const Text(
              //     'New',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(Utilities.padding / 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.white,
                        Colors.white.withOpacity(0.9)
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        user.petName!,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
