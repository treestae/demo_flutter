import 'package:flutter/material.dart';
import 'package:my_shop/constants.dart';
import 'package:my_shop/screens/details/details_screen.dart';

import '../../models/product.dart';
import '../categories.dart';
import 'item_card.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Text('Women', style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold)),
        ),
        Categories(),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(kDefaultPaddin),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: kDefaultPaddin,
              crossAxisSpacing: kDefaultPaddin,
              childAspectRatio: 3 / 4,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) => ItemCard(
              product: products[index],
              press: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => DetailsScreen(product: products[index])),
                ),
              ),
            ),
          ),
        )),
      ],
    );
  }
}
