import 'package:dog_share/screens/adminScreens/upload_product_form.dart';
import 'package:provider/provider.dart';
import 'package:dog_share/consts/my_icons.dart';
import 'package:dog_share/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:dog_share/widget/tools/custom_drawer.dart';
import 'provider/bottom_navigation_bar_provider.dart';
import 'screens/servicesScreen.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';

  BottomBarScreen({Key? key}) : super(key: key);
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final List<Widget> pages = <Widget>[
    const ServicesScreen(),
    Search(),
    // MyBookingsScreen(),
    // CalenderScreen(),
    // UserNSearch(),
    // ChatLists(),
    UploadProductForm()
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarProvider _page =
        Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      body: pages[_page.selectedPage],
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          onTap: (int updatedPage) => _page.updateSelectedPage(updatedPage),
          backgroundColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey.shade700,
          selectedItemColor: Colors.black,
          currentIndex: _page.selectedPage,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.room_service),
              label: 'Potential Matches',
            ),
            BottomNavigationBarItem(
              icon: Icon(MyAppIcons.search),
              label: 'Search',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.upload),
              label: 'Upload',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.calendar_today),
            //   label: 'All Bookings',
            // ),
            // // BottomNavigationBarItem(icon: Icon(MyAppIcons.user), label: 'User'),

            // // admin screen
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.people),
            //   label: 'All Users',
            // ),

            // // admin screen
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.chat_bubble),
            //   label: 'Admin Chats',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.upload),
            //   label: 'Upload Product',
            // ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }

  final List<IconData> _userTileIcons = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      leading: Icon(_userTileIcons[index]),
    );
  }

  Widget userTitle({required String title, Color color: Colors.yellow}) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
      ),
    );
  }
}
