import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isFavorite,
  });

  void toggleFavoriteStatus() async {
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.https('donation-project-d7244-default-rtdb.firebaseio.com',
        '/products/$id.json');
    http.Client().patch(url, body: jsonEncode({'isFavorite': isFavorite}));
  }
}
