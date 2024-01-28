import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';
import 'package:dart_frog/dart_frog.dart';

import '../models/http_exeption.dart';
import './product.dart';
import 'database.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {

    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    if (id == "") {
      return Product(
          id: "",
          title: "",
          description: "",
          price: 0,
          imageUrl: "",
          isFavorite: false);
    } else {
      return _items.firstWhere((prod) => prod.id == id);
    }
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    var extractedData;
    Database.makeConnection().then((_) async {
      var connection = Database.connection;
      var result = await connection!.execute("SELECT * FROM Products");
      print("success");
      for (final row in result.rows) {
        print(row.colByName("Title"));//to verify that the data is fetched

      }
      extractedData=result.rows;
    });
    final url = Uri.https(
        'donation-project-d7244-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.Client().get(url);
       extractedData = jsonDecode(response.body) ?? {};
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    Database.makeConnection().then((_) async {
      var connection = Database.connection;
      await connection!.execute(
        "INSERT INTO Products (Title, Price, Description, ImageURL) VALUES"
        " ('${product.title}' , '${product.price}' , '${product.description}', '${product.imageUrl}')",
      );
      print("done");
    });
    final url = Uri.https(
        "donation-project-d7244-default-rtdb.firebaseio.com", '/products.json');
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      print("sucess");
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: jsonDecode(response.body)['name'],
          isFavorite: false);
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print("failed");
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    Database.connection!.execute(
      "UPDATE Products SET Title = '${newProduct.title}', Price = '${newProduct.price}', Description = '${newProduct.description}', ImageURL = '${newProduct.imageUrl}' WHERE ProductID = '$id'",
    );
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
          "donation-project-d7244-default-rtdb.firebaseio.com",
          '/products/$id.json');
      await http.patch(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    Database.makeConnection().then((_) async {
      var connection = Database.connection;
      await connection!.execute(
        "DELETE FROM Products WHERE ProductID = '$id'",
      );
      print("done");
    });
    final url = Uri.https('donation-project-d7244-default-rtdb.firebaseio.com',
        '/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
