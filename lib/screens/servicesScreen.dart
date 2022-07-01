import 'package:badges/badges.dart';
import 'package:dog_share/models/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dog_share/cart/cart.dart';
import 'package:dog_share/provider/cart_provider.dart';
import 'package:dog_share/provider/favs_provider.dart';
import 'package:dog_share/provider/products.dart';
import 'package:dog_share/widget/service_card_widget.dart';
import 'package:dog_share/widget/tools/custom_drawer.dart';
import 'package:dog_share/wishlist/wishlist.dart';
import '../consts/colors.dart';
import '../consts/my_icons.dart';

class ServicesScreen extends StatefulWidget {
  static const routeName = '/Feeds';

  const ServicesScreen({Key? key}) : super(key: key);
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  Future<void> _getProductsOnRefresh() async {
    await Provider.of<AllUsers>(context, listen: false).fetchProducts();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getProductsOnRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments;
    final allUsersProvider = Provider.of<AllUsers>(
      context,
    );


    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Home'),
          centerTitle: true,
          // leading: IconButton(
          //   icon: Icon(Icons.dehaze_outlined),
          //   onPressed: () => Scaffold.of(context).openDrawer(),
          // ),
          actions: [
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
                    Navigator.of(context).pushNamed(MyBookingsScreen.routeName);
                  },
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _getProductsOnRefresh,
          child: allUsersProvider.allUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.room_service_outlined,
                        size: 60,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Match Available',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Look like no Match\nis available yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: allUsersProvider.allUsers.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider<AllUsers>.value(
                      value: allUsersProvider,
                      child: ServiceCardWidget(user: allUsersProvider.allUsers[index]),
                    );
                  }),
        ),

        //         StaggeredGridView.countBuilder(
        //           padding: ,
        //   crossAxisCount: 6,
        //   itemCount: 8,
        //   itemBuilder: (BuildContext context, int index) =>FeedProducts(),
        //   staggeredTileBuilder: (int index) =>
        //       new StaggeredTile.count(3, index.isEven ? 4 : 5),
        //   mainAxisSpacing: 8.0,
        //   crossAxisSpacing: 6.0,
        // ),
      ),
    );
  }
}
