import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

const TextStyle pageHeading = TextStyle(fontSize: 30, color: Colors.black);
const TextStyle buttonHeading = TextStyle(fontSize: 15, color: Colors.white);

const Color kLightBlack = Colors.black87;
const Color kDarkGrey = Colors.black54;
const Color kGreen = Color(0xff80B82D);
const Color kBlue = Color(0xff298BFC);

String BASE_URL;

const TextStyle kHeading = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
const TextStyle kSideHeading =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

Widget preLoaderImage({Widget child, ImageChunkEvent loadingProgress}) {
  if (loadingProgress == null) return child;
  return Shimmer.fromColors(
    baseColor: Colors.grey[350],
    highlightColor: Colors.grey[500],
    child: Container(
      color: Colors.grey,
    ),
  );
  ;
}
