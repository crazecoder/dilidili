import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dilidili/play_home.dart';
import 'package:stack_trace/stack_trace.dart';
import 'home.dart';
import 'package:fluro/fluro.dart';
import 'lib/library.dart';
import 'ui/detail_home.dart';
import 'constant.dart';
import 'utils/my_print.dart';
import 'package:flutter/foundation.dart';

void main() {
  // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  final Router router = new Router();
  // Define our splash page.
  router.define(
    "/play/:json",
    handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        String json = params["json"][0];
        json = json.replaceAll("]", "/");
        Map map = jsonDecode(json);
        log(json);
        Cartoon cartoon = new Cartoon.fromJson(map);
        return new PlayHome(
          cartoon: cartoon,
        );
      },
    ),
  );
  router.define(
    "/detail/:url/:name/:picture",
    handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new DetailHome(
          url: params["url"][0],
          name: params["name"][0],
          picture: params["picture"][0],
        );
      },
    ),
  );
  Application.router = router;

  Chain.capture(() {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: ConstantValue.IS_DEBUG,
      onGenerateRoute: Application.router.generator,
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new Home(),
    );
  }
}
