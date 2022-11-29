import 'dart:async';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/style_sizes.dart';

class Messaging {
  Messaging._();
  static Messaging _instance = Messaging._();
  static Messaging get instance => _instance;
  String? _token;

  final _streamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void close() {
    _streamController.close();
  }

  Future<void> init() async {

  }

  Future<void> messageListener() async {

  }
  Future? requestPermission() {
    return null;
  }

  Future<String> getToken([bool force = false]) async {
    if (force || _token == null) {
      await requestPermission();

    }
    return _token!;
  }
}