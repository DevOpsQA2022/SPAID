import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/constants.dart';

bool isMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < Constants.responseIsMobile;

bool isTab(BuildContext context) =>
    MediaQuery.of(context).size.width < Constants.responseIsDesktop &&
    MediaQuery.of(context).size.width >= Constants.responseIsMobile;

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= Constants.responseIsDesktop;




