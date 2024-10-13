import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/favourite_attraction_model.dart';

class FavouriteProvider extends ChangeNotifier {
  List<String> _favouriteList = [];
  List<String> get favourites => _favouriteList;

  void toggleFavourite(String place_id) {
    if (_favouriteList.contains(place_id)) {
      _favouriteList.remove(place_id);
    } else {
      _favouriteList.add(place_id);
    }
    print("count favourite : ${_favouriteList.length}");
    notifyListeners();
  }

  bool isExist(String place_id) {
    final isExist = _favouriteList.contains(place_id);
    return isExist;
  }

  static FavouriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavouriteProvider>(context, listen: listen);
  }
}
