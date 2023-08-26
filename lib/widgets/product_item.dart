import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatefulWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

var visible = false;

class _ProductItemState extends State<ProductItem> {
  AnimationController? _controller;
  void _getController(AnimationController aController) {
    _controller = aController;
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Card(
      elevation: 1,
      child: Stack(alignment: Alignment.center, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (ctx, product, _) => IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: Theme.of(context).secondaryHeaderColor,
                  onPressed: () {
                    product.toggleFavoriteStatus();
                  },
                ),
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("that was added successfully!"),
                  ));
                },
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            child: GestureDetector(
              onDoubleTap: (() {
                if (!product.isFavorite) {
                  product.toggleFavoriteStatus();
                }
                setState(() {
                  visible = true;
                  _controller!.forward();
                });

                Future.delayed(const Duration(milliseconds: 600)).then((_) {
                  setState(() {
                    visible = false;

                    _controller!.reverse();
                  });
                });
              }),
              onTap: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Hero(tag: product.id,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        // ignore: prefer_const_constructors
        HeartIcon(
          key: ValueKey(product.id),
          changeController: _getController,
        )
      ]),
    );
  }
}

class HeartIcon extends StatefulWidget {
  const HeartIcon({
    super.key,
    required this.changeController,
  });
  final Function changeController;

  @override
  State<HeartIcon> createState() => _HeartIconState();
}

class _HeartIconState extends State<HeartIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Size>? iconSize;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    widget.changeController(_controller);

    iconSize = Tween<Size>(begin: const Size(30, 30), end: const Size(55, 55))
        .animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));
    iconSize!.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: visible,
        child: Icon(
          Icons.favorite,
          color: Theme.of(context).primaryColorLight,
          size: iconSize!.value.height,
        ));
  }
}
