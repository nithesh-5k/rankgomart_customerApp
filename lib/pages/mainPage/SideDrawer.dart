import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mart/const.dart';
import 'package:mart/pages/groceries/AllCategories.dart';
import 'package:mart/pages/groceries/OfferZone.dart';
import 'package:mart/pages/mainPage/OrderHistory.dart';
import 'package:mart/pages/mainPage/WishListPage.dart';
import 'package:mart/pages/mainPage/cartPage.dart';
import 'package:mart/pages/mainPage/userProfile.dart';
import 'package:mart/provider/user.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Center(child: Image.asset('assets/logo.png')),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      DrawerOption(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        icon: Icons.home_rounded,
                        text: "Home",
                      ),
                      DrawerOption(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => AllCategories(),
                              ));
                        },
                        icon: Icons.apps,
                        text: "All Categories",
                      ),
                      DrawerOption(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => OfferZone(),
                              ));
                        },
                        icon: Icons.bolt,
                        text: "Offer Zone",
                      ),
                      // DrawerOption(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   icon: Icons.menu_book,
                      //   text: "Products",
                      // ),
                      DrawerOption(
                        onTap: () {
                          Navigator.pop(context);
                          if (Provider.of<User>(context, listen: false)
                                  .userId ==
                              null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Please login to check order history"),
                            ));
                          } else {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => OrderHistory()));
                          }
                        },
                        icon: Icons.business_center,
                        text: "My Orders",
                      ),
                      DrawerOption(
                        onTap: () {
                          Navigator.pop(context);
                          if (Provider.of<User>(context, listen: false)
                                  .userId ==
                              null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Please login to check wish list"),
                            ));
                          } else {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => WishListPage()));
                          }
                        },
                        icon: Icons.favorite_outlined,
                        text: "My Wishlist",
                      ),
                      DrawerOption(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => CartPage()));
                        },
                        icon: Icons.shopping_cart,
                        text: "My Cart",
                      ),
                      DrawerOption(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => UserProfile()));
                        },
                        icon: Icons.person,
                        text: "My Account",
                      ),
                      // DrawerOption(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   icon: Icons.notifications,
                      //   text: "Notifications",
                      // ),
                      // Padding(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 4, vertical: 15),
                      //   child: Divider(
                      //     thickness: 2,
                      //     height: 0,
                      //   ),
                      // ),
                      // DrawerOption(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   text: "Notification Preference",
                      // ),
                      // DrawerOption(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   text: "Help Center",
                      // ),
                      // DrawerOption(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   text: "Privacy Policy",
                      // ),
                      // DrawerOption(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   text: "Legal",
                      // ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerOption extends StatelessWidget {
  Function onTap;
  IconData icon;
  String text;

  DrawerOption({this.onTap, this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.0),
        width: double.infinity,
        child: Row(
          children: [
            Icon(
              icon,
              color: kDarkGrey,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
