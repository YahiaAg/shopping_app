import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../screens/cart_screen.dart';
import '../screens/edit_product_screen.dart';
import '../screens/user_products_screen.dart';
  

// ignore: must_be_immutable
class MyGnavBar extends StatelessWidget {
  MyGnavBar({super.key, this.myIndex = 0});
  int myIndex;
  @override
  Widget build(BuildContext context) {
    return GNav(
      activeColor: Theme.of(context).primaryColor,
      selectedIndex: myIndex,
      onTabChange: (index) {
        myIndex = index;
        if (index == 0) {
          Navigator.of(context).pushNamed('./', arguments: index);
        } else if (index == 1) {
          Navigator.of(context)
              .pushNamed(EditProductScreen.routeName, arguments: index);
        } else if (index == 2) {
          Navigator.of(context)
              .pushNamed(UserProductsScreen.routeName, arguments: index);
        } else if (index == 3) {
          Navigator.of(context)
              .pushNamed(CartScreen.routeName, arguments: index);
        }
      },
      tabs: const [
        GButton(
          icon: Icons.home,
          text: "Home",
        ),
        GButton(
          icon: Icons.add,
          text: "Add item",
        ),
        GButton(
          icon: Icons.search,
          text: "Search",
        ),
        GButton(
          icon: Icons.shopping_bag,
          text: "Order",
        )
      ],
    );
  }
}
