// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterRoute] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
class ConverterRoute extends StatefulWidget {
  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterRoute] requires the color and units to not be null.
  const ConverterRoute({
    @required this.color,
    @required this.units,
  })  : assert(color != null),
        assert(units != null);

  @override
  _ConverterRouteState createState() => _ConverterRouteState();
}

class _ConverterRouteState extends State<ConverterRoute> {
  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  Unit _unitInValue;
  Unit _unitOutValue;

  bool _showError = false;
  double _inputValue;
  String _convertedValue = '';

  @override
  void initState() {
    _unitInValue = widget.units[0];
    _unitOutValue = widget.units[1];

    super.initState();
  }

  void _updateConversion() {
    setState(() {
      _convertedValue = _format(
          _inputValue * (_unitOutValue.conversion / _unitInValue.conversion));
    });
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          final inputDouble = double.parse(input);
          _showError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          _showError = true;
        }
      }
    });
  }

  Unit _getUnit(String unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null,
    );
  }

  void _updateFromConversion(dynamic unit) {
    setState(() {
      _unitInValue = _getUnit(unit);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unit) {
    setState(() {
      _unitOutValue = _getUnit(unit);
    });
    if (_inputValue != null) {
      _updateConversion();
    }
  }

  @override
  Widget build(BuildContext context) {
    var inputGroup = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Input',
            errorText: _showError ? 'Invalid number entered' : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
          onChanged: _updateInputValue,
        ),
        SizedBox(
          height: 8,
        ),
        _buildDropdownList(context, _unitInValue, _updateFromConversion),
      ],
    );

    var outputGroup = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InputDecorator(
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.display1,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.display1,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          _buildDropdownList(context, _unitOutValue, _updateToConversion),
        ]);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          inputGroup,

          // Create a compare arrows icon.
          Transform.rotate(
            angle: 90 * pi / 180,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Icon(
                Icons.compare_arrows,
                size: 40,
              ),
            ),
          ),

          // Create the 'output' group of widgets. This is a Column that
          // includes the output value, and 'to' unit [Dropdown].
          outputGroup,
        ],
      ),
    );
  }

  List<DropdownMenuItem<Unit>> _buildItemList(BuildContext context) {
    return widget.units.map<DropdownMenuItem<Unit>>((Unit value) {
      return DropdownMenuItem<Unit>(
        value: value,
        child: Text(
          value.name,
          style: Theme.of(context).textTheme.body1,
        ),
      );
    }).toList();
  }

  Widget _buildDropdownList(
      BuildContext context, Unit value, Function saveCallback) {

    return Container(
      margin: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: Colors.grey[400],
            width: 1.0,
          )),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.grey[50],
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                value: value,
                items: _buildItemList(context),
                onChanged: (Unit unit) {
                  saveCallback(unit.name);
                },
                style: Theme.of(context).textTheme.title,
              ),
            ),
          )),
    );

    return DropdownButtonFormField(
      isDense: true,
      // height issue
      decoration: const InputDecoration(
        border: OutlineInputBorder(gapPadding: 0),
      ),
      value: value,
      onChanged: (Unit unit) {
        saveCallback(unit.name);
      },
      items: _buildItemList(context),
    );
  }
}
