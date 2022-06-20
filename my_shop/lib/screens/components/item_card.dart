import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../models/product.dart';

class ItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback press;

  const ItemCard({
    Key? key,
    required this.product,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(kDefaultPaddin),
              decoration: BoxDecoration(
                color: product.color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Hero(tag: "${product.id}", child: Image.asset(product.image)),
            ),
          ),
          Text(
            product.title,
            style: TextStyle(
              color: kTextLightColor,
            ),
          ),
          Text(
            '\$ ${NumberFormat.decimalPattern().format(product.price)}',
            style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor),
          ),
        ],
      ),
    );
  }
}
