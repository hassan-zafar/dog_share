import 'package:flutter/material.dart';
import 'package:dog_share/utilities/custom_images.dart';
import 'package:dog_share/widget/tools/empty_image_widget.dart';

class WishlistEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyImageWidget(
      assetImage: CustomImages.emptyWishlist,
      title: 'No Favorit found',
      subtitle: '''Looks like you don't\nadd anything in your wishlist yet''',
    );
  }
}
