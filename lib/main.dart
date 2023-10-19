import 'package:contact_list/bloc/home_page_bloc/home_page_bloc.dart';
import 'package:contact_list/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // init the hive

  /// open a box
  // sqfliteFfiInit();

  // databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(),
      home: BlocProvider(
        create: (context) => HomePageBloc(),
        child: HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
