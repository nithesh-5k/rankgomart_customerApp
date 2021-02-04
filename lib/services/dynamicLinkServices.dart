import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:mart/model/Item/GroceryItem.dart';
import 'package:mart/pages/groceries/productPage.dart';
import 'package:share/share.dart';

class DynamicLinkService {
  static Future<void> shareProduct(GroceryItem product) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://rankgomart.page.link',
      link: Uri.parse('https://www.rankgomart.com/post?id=${product.id}'),
      androidParameters: AndroidParameters(
        packageName: 'com.zeronecorps.rankgomart.customerapp',
      ),
    );

    final Uri dynamicUrl = await parameters.buildUrl();

    print(dynamicUrl.toString());
    Share.share(
        "Get ${product.name} from Rankgomart!!!\n\n" + dynamicUrl.toString());
  }

  static Future handleDynamicLinks() async {
    // 1. Get the initial dynamic link if the app is opened with a dynamic link
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    // 2. handle link that has been retrieved
    _handleDeepLink(data);

    // 3. Register a link callback to fire if the app is opened up from the background
    // using a dynamic link.
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      // 3a. handle link that has been retrieved
      _handleDeepLink(dynamicLink);
    }, onError: (OnLinkErrorException e) async {
      print('Link Failed: ${e.message}');
    });
  }

  static void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print('_handleDeepLink | deeplink: $deepLink');

      // Check if we want to make a post
      var isPost = deepLink.pathSegments.contains('post');

      if (isPost) {
        // get the title of the post
        var id = deepLink.queryParameters['id'];

        if (id != null) {
          // ignore: unrelated_type_equality_checks
          if (id != "-1") {
            NavigationService.navigateTo(ProductPage.routeName, arguments: id);
          }
        }
      }
    }
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  static Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }
}
