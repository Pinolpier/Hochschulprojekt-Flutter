import 'package:flutter/material.dart';

/// @author Christian Henrich
///
/// some constants for consistent decoration style and design in the screens

final textStyleConstant = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final labelStyleConstant = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final boxStyleConstant = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

/// constant value for the extended radius on the map_screen
final radius_buffer = 1;
