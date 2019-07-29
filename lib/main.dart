import 'dart:convert';

import 'package:dilidili/bean/bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'application.dart';
import 'ui/home.dart';
import 'package:fluro/fluro.dart';
import 'ui/detail_home.dart';
import 'ui/play_home.dart';
import 'blocs/blocs.dart' as blocs;

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
    print(stacktrace);
  }
}

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
        Cartoon cartoon = new Cartoon.fromJson(map);
        return BlocProvider<blocs.PlayBloc>(
          builder: (_) => blocs.PlayBloc(),
          child: PlayHome(
            cartoon: cartoon,
          ),
        );
      },
    ),
  );
  router.define(
    "/detail/:url/:name/:picture",
    handler: new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return BlocProvider<blocs.DetailBloc>(
          builder: (_) => blocs.DetailBloc(),
          child: DetailHome(
            url: params["url"][0],
            name: params["name"][0],
            picture: params["picture"][0],
          ),
        );
      },
    ),
  );
  Application.router = router;

  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final GlobalKey<ScaffoldState> _key = GlobalKey();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final RouterBloc routerBloc = RouterBloc();
    return MaterialApp(
      onGenerateRoute: Application.router.generator,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<blocs.TabBloc>(
            builder: (_) => blocs.TabBloc(),
          ),
          BlocProvider<blocs.HistoryBloc>(
            builder: (_) => blocs.HistoryBloc(),
          ),
          BlocProvider<blocs.CategoryBloc>(
            builder: (_) => blocs.CategoryBloc()..dispatch(blocs.CategoryLoadEvent()),
          ),
          // BlocProvider<blocs.CategoryDetailBloc>(
          //   builder: (_) => blocs.CategoryDetailBloc(),
          // ),
          BlocProvider<blocs.NewestBloc>(
            builder: (_) => blocs.NewestBloc()..dispatch(blocs.NewestLoadEvent()),
          ),
          BlocProvider<blocs.SearchBloc>(
            builder: (_) => blocs.SearchBloc(),
          ),
        ],
        child: HomePage(),
      ),
    );
  }
}
