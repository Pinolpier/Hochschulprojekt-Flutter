import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

/// @author Christian Henrich
///
/// some constants for consistent decoration style and design in the screens

///Border radius for boxes and text fields
const double borderRadiusStyle = 6.0;

final textStyleConstant = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final labelStyleConstant = TextStyle(
  color: univentsWhiteText,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final boxStyleConstant = BoxDecoration(
  color: univentsLightBlue,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: borderRadiusStyle,
      offset: Offset(0, 2),
    ),
  ],
);

final boxErrorStyleConstant = boxStyleConstant.copyWith(
    border: Border.all(color: univentsError, width: 3));

/// constant value for the extended radius on the map_screen
final radius_buffer = 1;

final dateTimeShortDateFormat = DateFormat('hh:mm dd.MM.yy');
final dateTimeLongDateFormat = DateFormat('hh:mm dd.MM.yyyy');
