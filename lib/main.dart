import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/analytics_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // await Firebase.initializeApp(
 //   options: DefaultFirebaseOptions.currentPlatform,
  //);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primaryColor: Colors.purple,
            iconButtonTheme: IconButtonThemeData(
                style: ButtonStyle(iconSize: MaterialStateProperty.all(30))),
            useMaterial3: true,
            primarySwatch: Colors.purple,
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
          home: const AuthScreen(),
          routes: {
            './': (ctx) => const AuthScreen(),
            ProductsOverviewScreen.routeName: (ctx) =>
                const ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            Dashboard.routeName: (ctx) => const Dashboard(),

          }),
    );
  }
}
