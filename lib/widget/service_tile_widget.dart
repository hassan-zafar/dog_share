import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog_share/consts/my_icons.dart';
import 'package:dog_share/models/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dog_share/inner_screens/service_details.dart';
import 'package:dog_share/provider/cart_provider.dart';
import 'package:dog_share/provider/favs_provider.dart';
import 'package:dog_share/provider/products.dart';
import '../../../../utilities/custom_images.dart';
import '../../../../utilities/utilities.dart';
import '../models/petsDataModel.dart';

class ServicesTileWidget extends StatelessWidget {
  const ServicesTileWidget({required PetsDataModel user, Key? key})
      : _user = user,
        super(key: key);

  final PetsDataModel _user;

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<AllUsers>(context, listen: false);

    final cartProvider = Provider.of<FavouriteProvider>(context);

    final favsProvider = Provider.of<FavsProvider>(context);
    final prodAttr = productsData.findById(_user.id!);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Utilities.padding,
        vertical: Utilities.padding / 3,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Utilities.padding),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<ServiceDetailsScreen>(
              builder: (BuildContext context) => ServiceDetailsScreen(),
            ),
          );
        },
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(Utilities.padding),
          ),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Utilities.padding),
                  bottomLeft: Radius.circular(Utilities.padding),
                ),
                child: SizedBox(
                  width: 80,
                  height: double.infinity,
                  child:  CachedNetworkImage(
                 imageUrl: 
                    _user.imageUrl!,
                    fit: BoxFit.cover,
                    errorWidget:(context, url, error) =>  
                        Image.asset(CustomImages.icon, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _user.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      _user.phoneNo!,
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
                splashRadius: 20,
                onPressed: () {
                  favsProvider.addAndRemoveFromFav(
                      _user.id!,
                      prodAttr.name!,
                      prodAttr.imageUrl!);
                },
                icon: Icon(
                  favsProvider.getFavsItems.containsKey(_user.id)
                      ? Icons.favorite_border
                      : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              IconButton(
                splashRadius: 20,
                onPressed: () {
                  cartProvider.addProductToCart(
                      _user.id!,
                      prodAttr.name!,
                      prodAttr.imageUrl!);
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                icon: cartProvider.getCartItems.containsKey(_user.id)
                    ?  Icon(MyAppIcons.favouriteOutlined)
                    : Icon(MyAppIcons.favouriteOutlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
