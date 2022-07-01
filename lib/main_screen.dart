import 'package:flutter/material.dart';
import 'package:dog_share/screens/adminScreens/upload_product_form.dart';
import 'bottom_bar.dart';

class MainScreens extends StatelessWidget {
  static const routeName = '/MainScreen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        children: [
          BottomBarScreen(),
        ],
      ),
    );
  }
}
