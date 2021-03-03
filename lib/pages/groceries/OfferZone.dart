import 'package:flutter/material.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';

class OfferZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context: context, title: "Offer Zone"),
      body: Center(
        child: Text("Currently, no offers available"),
      ),
    );
  }
}
