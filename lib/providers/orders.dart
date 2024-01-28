import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/providers/database.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
 final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total, int? orderID) {
    Database.makeConnection().then((_) async {
      var connection = Database.connection;
      var date= (DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString());
      var result = await connection!.execute(
          "INSERT INTO Purshases (OrderID,TotalAmount, PurshaseDate) VALUES ($orderID, $total, $date )");
      print("success");
      for (final row in result.rows) {
        print(row.colByName("productID"));//to verify that the data is fetched
      }
    });
    
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
