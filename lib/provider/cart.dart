import 'package:flutter/material.dart';
import 'package:mart/model/Item/FoodItem.dart';
import 'package:mart/model/Item/GroceryItem.dart';
import 'package:mart/model/Item/IItem.dart';
import 'package:mart/model/Item/PastryItem.dart';
import 'package:mart/pages/mainPage/MainPage.dart';
import 'package:mart/provider/gps.dart';
import 'package:provider/provider.dart';

class Cart extends ChangeNotifier {
  int productCount = 0;
  List<IItem> cartProducts;
  List<int> quantity = [];
  Type type;
  String id = "null";

  Cart() {
    cartProducts = new List<GroceryItem>();
    type = Type.grocery;
  }

  void addGrocery(GroceryItem p, BuildContext context,
      GlobalKey<ScaffoldState> key, LatLng coordinates) {
    if (quantity.length == 0) {
      fixGPS(context, coordinates);
      cartProducts = new List<GroceryItem>();
      quantity.clear();
      type = Type.grocery;
      id = "null";
      addProduct(p);
      showSnackBar(p, context, key);
    } else {
      if (type != Type.grocery) {
        showAlertDialog(context, () {
          fixGPS(context, coordinates);
          cartProducts = new List<GroceryItem>();
          quantity.clear();
          type = Type.grocery;
          id = "null";
          addProduct(p);
          showSnackBar(p, context, key);
        });
      } else {
        addProduct(p);
        showSnackBar(p, context, key);
      }
    }
  }

  void showSnackBar(
      GroceryItem p, BuildContext context, GlobalKey<ScaffoldState> key) {
    if (key == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("${p.name} added to the cart"),
      ));
    } else {
      key.currentState.showSnackBar(SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text("${p.name} added to the cart"),
      ));
    }
  }

  void addFood(
      FoodItem p, String hotelId, BuildContext context, LatLng coordinates) {
    if (quantity.length == 0) {
      fixGPS(context, coordinates);
      cartProducts = new List<FoodItem>();
      quantity.clear();
      type = Type.food;
      id = hotelId;
      addProduct(p);
    } else {
      if (type != Type.food || id != hotelId) {
        showAlertDialog(context, () {
          fixGPS(context, coordinates);
          cartProducts = new List<FoodItem>();
          quantity.clear();
          type = Type.food;
          id = hotelId;
          addProduct(p);
        });
      } else {
        addProduct(p);
      }
    }
  }

  void addPastry(
      PastryItem p, String bakeryId, BuildContext context, LatLng coordinates) {
    if (quantity.length == 0) {
      fixGPS(context, coordinates);
      cartProducts = new List<PastryItem>();
      quantity.clear();
      type = Type.cake;
      id = bakeryId;
      addProduct(p);
    } else {
      if (type != Type.cake || id != bakeryId) {
        showAlertDialog(context, () {
          fixGPS(context, coordinates);
          cartProducts = new List<PastryItem>();
          quantity.clear();
          type = Type.cake;
          id = bakeryId;
          addProduct(p);
        });
      } else {
        addProduct(p);
      }
    }
  }

  void fixGPS(BuildContext context, LatLng coordinates) {
    Provider.of<GPS>(context, listen: false).setFixed(
        latitude: coordinates.latitude, longitude: coordinates.longitude);
  }

  void addProduct(IItem p) {
    for (int i = 0; i < cartProducts.length; i++) {
      if (cartProducts[i].id == p.id) {
        quantity[i]++;
        return;
      }
    }
    cartProducts.add(p);
    quantity.add(1);
    checkCount();
  }

  void deleteProduct(int index) {
    cartProducts.removeAt(index);
    quantity.removeAt(index);
    checkCount();
  }

  void checkCount() {
    productCount = cartProducts.length;
    notifyListeners();
  }

  void incrementQuantity(int index) {
    quantity[index]++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (quantity[index] != 1) {
      quantity[index]--;
    }
    notifyListeners();
  }

  double totalPrice() {
    double total = 0;
    for (int i = 0; i < productCount; i++) {
      total += (double.parse(cartProducts[i].salePrice)) * quantity[i];
    }
    total = (total * 100).roundToDouble() / 100;
    return total;
  }

  int getQuantity(String itemId, Type check, String placeId) {
    if (check == type && placeId == id) {
      for (int i = 0; i < quantity.length; i++) {
        if (cartProducts[i].id == itemId) {
          return i;
        }
      }
    }
    return -1;
  }

  showAlertDialog(BuildContext context, Function proceed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert!"),
          content: Text(
              "It is recommended to clear the cart to add this product. Would you like us to proceed with clearing the cart and add the product?"),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Proceed"),
              onPressed: () {
                proceed();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void clearCart() {
    cartProducts = new List<GroceryItem>();
    quantity.clear();
    type = Type.grocery;
    id = "null";
    productCount = 0;
    notifyListeners();
  }
}
