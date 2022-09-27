import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'home_layout.dart';
import 'shared/bloc_observed.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        //backgroundColor: Color(0xff82A3A1),
        //iconTheme: Theme.of(context).iconTheme.apply(),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.teal, //<-- SEE HERE
              displayColor: Color(0xffF2ECD2), //<-- SEE HERE
            ),
      ),

      debugShowCheckedModeBanner: false,

      initialRoute: '/',
      // home: Screen0(),
      routes: {
        "/": (context) => HomeLayout(),
      },
    );
  }
}
