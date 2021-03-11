import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/model/Item/SearchItem.dart';
import 'package:mart/pages/groceries/productPage.dart';
import 'package:mart/services/request.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<SearchItem> searchItems = [];
  var responseBody;

  Future<void> searchProducts(String serachText) async {
    Map<String, String> body = {
      "custom_data": "searchdata",
      "searchkey": serachText
    };
    responseBody = await postRequestForList("API/homepage_api.php", body);
    if (responseBody['success'] == null ? false : responseBody['success']) {
      setState(() {
        searchItems = searchFromJson(responseBody['items']["message"]);
      });
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        searchProducts(serachText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context, title: "Search"),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  if (value.length > 2) {
                    searchProducts(value);
                  } else {
                    responseBody = null;
                  }
                });
              },
              cursorColor: Colors.grey,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3),
                ),
                hintText: 'Search',
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: responseBody == null
                  ? Center(
                      child: Text("Enter atleast 3 chararcter"),
                    )
                  : searchItems.length == 0
                      ? Center(
                          child: Text("No items available"),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ProductPage.routeName,
                                    arguments: searchItems[index].id);
                              },
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Image.network(
                                            searchItems[index].imageUrl,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              return preLoaderImage(
                                                  child: child,
                                                  loadingProgress:
                                                      loadingProgress);
                                            },
                                            height: 60,
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child:
                                                  Text(searchItems[index].name),
                                            )),
                                      ],
                                    ),
                                    Divider()
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: searchItems.length,
                        ),
            ),
          )
        ],
      ),
    );
  }
}
