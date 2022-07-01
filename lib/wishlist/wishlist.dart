import 'package:dog_share/consts/my_icons.dart';
import 'package:dog_share/provider/favs_provider.dart';
import 'package:dog_share/services/global_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'wishlist_empty.dart';
import 'wishlist_full.dart';

class LikedScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final favsProvider = Provider.of<FavsProvider>(context);
    return favsProvider.getFavsItems.isEmpty
        ? Scaffold(
            appBar: AppBar(
              title: Text('Liked'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: WishlistEmpty(),)
        : Scaffold(
            appBar: AppBar(
              title: Text('Wishlist (${favsProvider.getFavsItems.length})'),
              actions: [
                TextButton(
                  onPressed: () {
                    globalMethods.showDialogg(
                        'Clear wishlist!',
                        'Your wishlist will be cleared!',
                        () => favsProvider.clearFavs(),
                        context,);
                    // cartProvider.clearCart();
                  },
                  child: Text('Clear List'),
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: ListView.builder(
              itemCount: favsProvider.getFavsItems.length,
              itemBuilder: (BuildContext ctx, int index) {
                return ChangeNotifierProvider.value(
                    value: favsProvider.getFavsItems.values.toList()[index],
                    child: WishlistFull(
                      productId: favsProvider.getFavsItems.keys.toList()[index],
                    ));
              },
            ),
          );
  }
}
