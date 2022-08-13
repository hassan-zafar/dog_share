import 'package:dog_share/models/users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dog_share/provider/products.dart';
import 'package:dog_share/utilities/utilities.dart';
import 'package:dog_share/widget/service_tile_widget.dart';
import 'package:dog_share/widget/tools/empty_iconic_widget.dart';

import '../models/petsDataModel.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController? _searchTextController;
  final FocusNode _node = FocusNode();
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    _searchTextController!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _node.dispose();
    _searchTextController!.dispose();
  }

  List<PetsDataModel> _searchList = [];
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<PetsProvider>(context);
    final productsList = productsData.allPets;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Utilities.padding),
            child: TextField(
              controller: _searchTextController,
              minLines: 1,
              focusNode: _node,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                ),
                hintText: 'Search',
                filled: true,
                fillColor: Theme.of(context).cardColor,
                suffixIcon: IconButton(
                  onPressed: _searchTextController!.text.isEmpty
                      ? null
                      : () {
                          _searchTextController!.clear();
                          _node.unfocus();
                        },
                  icon: Icon(Icons.remove_from_queue,
                      color: _searchTextController!.text.isNotEmpty
                          ? Colors.red
                          : Colors.grey),
                ),
              ),
              onChanged: (value) {
                _searchTextController!.text.toLowerCase();
                setState(() {
                  _searchList = productsData.searchQuery(value);
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _searchTextController!.text.isNotEmpty && _searchList.isEmpty
              ? const EmptyIconicWidget(
                  icon: Icons.error_outline,
                  title: 'No Match found!!!',
                  subtitle: 'You can checkout all service',
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _searchTextController!.text.isEmpty
                        ? productsList.length
                        : _searchList.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider<PetsProvider>.value(
                        value: productsData,
                        // _searchTextController!.text.isEmpty
                        //     ? productsList[index]
                        //     : _searchList[index],
                        child: _searchTextController!.text.isEmpty
                            ? ServicesTileWidget(
                                user: productsList[index],
                              )
                            : ServicesTileWidget(user: _searchList[index]),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
