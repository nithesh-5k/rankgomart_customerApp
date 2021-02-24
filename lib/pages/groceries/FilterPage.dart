import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mart/const.dart';
import 'package:mart/customWidgets/CustomAppBar.dart';
import 'package:mart/model/Filter.dart';

class FilterPage extends StatefulWidget {
  Filter filter;
  Function function;

  FilterPage(this.filter, this.function);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Filter _filter;
  double min, max;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filter = widget.filter;
    min = _filter.changedMin;
    max = _filter.changedMax;
  }

  @override
  Widget build(BuildContext context) {
    print("$min $max");
    return Scaffold(
      appBar: CustomAppBar(title: "Filter", context: context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RangeSlider(
            activeColor: kBlue,
            inactiveColor: kBlue,
            min: _filter.min,
            max: _filter.max,
            values: RangeValues(min, max),
            onChanged: (value) {
              setState(() {
                min = value.start.toPrecision(2);
                max = value.end.toPrecision(2);
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("Min value: Rs.$min"), Text("Max value: Rs.$max")],
          ),
          Visibility(
            visible: _filter.brand.length != 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              height: (MediaQuery.of(context).size.height - 192) / 2,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Brands",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(3),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                if (_filter.brandCheck.contains(
                                    int.parse(_filter.brand[index].id))) {
                                  _filter.brandCheck.remove(
                                      int.parse(_filter.brand[index].id));
                                } else {
                                  _filter.brandCheck
                                      .add(int.parse(_filter.brand[index].id));
                                }
                              });
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    height: 15,
                                    width: 15,
                                    color: _filter.brandCheck.contains(
                                            int.parse(_filter.brand[index].id))
                                        ? kBlue
                                        : Colors.grey,
                                  ),
                                  Text(_filter.brand[index].name)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _filter.brand.length,
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: _filter.subCategory.length != 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              height: (MediaQuery.of(context).size.height - 192) / 2,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Sub-Category",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(3),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                if (_filter.subCategoryCheck.contains(
                                    int.parse(_filter.subCategory[index].id))) {
                                  _filter.subCategoryCheck.remove(
                                      int.parse(_filter.subCategory[index].id));
                                } else {
                                  _filter.subCategoryCheck.add(
                                      int.parse(_filter.subCategory[index].id));
                                }
                              });
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    height: 15,
                                    width: 15,
                                    color: _filter.subCategoryCheck.contains(
                                            int.parse(
                                                _filter.subCategory[index].id))
                                        ? kBlue
                                        : Colors.grey,
                                  ),
                                  Text(_filter.subCategory[index].name)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _filter.subCategory.length,
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                color: kBlue,
                child: Text(
                  "Filter",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _filter.lastId = "0";
                  _filter.changedMin = min;
                  _filter.changedMax = max;
                  _filter.brandId = "";
                  bool flag = true;
                  _filter.brandCheck.forEach((element) {
                    if (flag) {
                      _filter.brandId = element.toString();
                      flag = false;
                    } else {
                      _filter.brandId =
                          _filter.brandId + "," + element.toString();
                    }
                  });
                  _filter.subCategoryId = "";
                  flag = true;
                  _filter.subCategoryCheck.forEach((element) {
                    if (flag) {
                      _filter.subCategoryId = element.toString();
                      flag = false;
                    } else {
                      _filter.subCategoryId =
                          _filter.subCategoryId + "," + element.toString();
                    }
                  });
                  Navigator.pop(context);
                  widget.function();
                },
              ),
              FlatButton(
                color: Colors.orangeAccent,
                child: Text(
                  "Reset",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    _filter.lastId = "0";
                    _filter.changedMin = _filter.min;
                    _filter.changedMax = _filter.max;
                    _filter.brandId = "";
                    _filter.subCategoryId = "";
                  });
                  Navigator.pop(context);
                  widget.function();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

extension NumberRounding on num {
  num toPrecision(int precision) {
    return num.parse((this).toStringAsFixed(precision));
  }
}
