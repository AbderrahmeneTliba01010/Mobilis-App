import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilis/screens/prospecting/bloc/prospecting_cubit.dart';
import 'app.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ProspectingCubit(),
      child: const MyApp(),
    ),
  );
}