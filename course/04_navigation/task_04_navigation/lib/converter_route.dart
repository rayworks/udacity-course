// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:task_04_navigation/unit.dart';

/// Converter screen where users can input amounts to convert.
///
/// Currently, it just displays a list of mock units.
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatelessWidget {
  /// Units for this [Category].
  List<Unit> units;
  Color bkgColor;
  String name;

  /// This [ConverterRoute] requires the color and units to not be null.

  ConverterRoute(String name, List<Unit> units, Color color) {
    // @required this.units, @required this.bkgColor
    assert(units != null);
    this.units = units;
    this.bkgColor = color;
    this.name = name;
  }

  @override
  Widget build(BuildContext context) {
    // Here is just a placeholder for a list of mock units
    final unitWidgets = units.map((Unit unit) {
      return Container(
        color: bkgColor,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.0,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: bkgColor,
      ),
      body: ListView(
        children: unitWidgets,
      ),
    );
  }
}
