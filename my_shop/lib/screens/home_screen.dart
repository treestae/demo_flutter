import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_shop/constants.dart';
import 'package:my_shop/screens/ScreenLimit.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenLimit(
      child: Scaffold(
        appBar: buildAppBar(),
        body: Body(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back.svg'),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset('assets/icons/search.svg', color: kTextColor),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset('assets/icons/cart.svg', color: kTextColor),
          onPressed: () {},
        ),
        const SizedBox(width: kDefaultPaddin),
      ],
    );
  }
}
