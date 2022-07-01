import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog_share/inner_screens/service_details.dart';
import 'package:dog_share/models/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dog_share/utilities/custom_images.dart';
import 'package:dog_share/utilities/utilities.dart';

class ServiceCardWidget extends StatefulWidget {
  const ServiceCardWidget({Key? key}) : super(key: key);

  @override
  _ServiceCardWidgetState createState() => _ServiceCardWidgetState();
}

class _ServiceCardWidgetState extends State<ServiceCardWidget> {
  @override
  Widget build(BuildContext context) {
    final productsAttributes = Provider.of<AppUserModel>(context);
    print(productsAttributes);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ServiceDetailsScreen.routeName,
            arguments: productsAttributes.id);
      },
      child: Container(
        height: 120,
        width: 150,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: (productsAttributes.imageUrl == null ||
                        productsAttributes.imageUrl!.isEmpty)
                    ? Image.asset(CustomImages.icon, fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: productsAttributes.imageUrl!,
                        fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(Utilities.padding / 2),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.9)
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        productsAttributes.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        productsAttributes.joinedAt!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
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
