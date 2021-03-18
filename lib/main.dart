import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:engage/app/engageApp.dart';
import 'package:engage/bloc/simpleBlocObserver.dart';
import 'package:engage/bloc/bloc.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  return runApp(EngageApp());
}
