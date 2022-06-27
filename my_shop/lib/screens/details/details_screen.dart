import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_shop/screens/screen_limit.dart';
import 'package:my_shop/screens/details/components/details_body.dart';

import '../../constants.dart';
import '../../models/product.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;

  const DetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenLimit(
      child: Scaffold(
        backgroundColor: product.color,
        appBar: buildAppBar(context),
        body: DetailsBody(product: product),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: product.color,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset("assets/icons/cart.svg"),
          onPressed: () {},
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }
}
