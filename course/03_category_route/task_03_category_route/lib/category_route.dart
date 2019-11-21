// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'category.dart';

// TODO: Check if we need to import anything

// TODO: Define any constants

/// Category Route (screen).
///
/// This is the 'home' screen of the Unit Converter. It shows a header and
/// a list of [Categories].
///
/// While it is named CategoryRoute, a more apt name would be CategoryScreen,
/// because it is responsible for the UI at the route's destination.
class CategoryRoute extends StatelessWidget {
  CategoryRoute();

  static const _categoryNames = <String>[
    'Length',
    'Area',
    'Volume',
    'Mass',
    'Time',
    'Digital Storage',
    'Energy',
    'Currency',
  ];

  static const _baseColors = <Color>[
    Colors.teal,
    Colors.orange,
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.yellow,
    Colors.greenAccent,
    Colors.purpleAccent,
    Colors.red,
  ];

  Color _bkgColor = Colors.green[100];

  @override
  Widget build(BuildContext context) {
    // Create a list of the eight Categories, using the names and colors
    // from above. Use a placeholder icon, such as `Icons.cake` for each
    // Category. We'll add custom icons later.
    
    // Create a list view of the Categories
    final listView = ListView.builder(
      itemCount: _categoryNames.length,
      itemBuilder: (ctx, i) => Category(
        name: _categoryNames[i],
        color: _baseColors[i],
        iconLocation: Icons.cake,
      ),
    ).build(context);

    // Create an App Bar
    final appBar = AppBar(
      backgroundColor: _bkgColor,
      elevation: 0.0,
      title: Center(
      child: Text(
        'Unit Converter',
        style: TextStyle(fontSize: 30.0, color: Colors.black),
      ),
    ));

    return Scaffold(
      backgroundColor: _bkgColor,
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
        child: listView,
      ),
    );
  }
}
