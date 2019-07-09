import 'package:flutter/material.dart';
import 'http.dart' as http;
import 'utils/html_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'db/db_helper.dart';
import 'lib/library.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class PlayHome extends StatefulWidget {
  final Cartoon cartoon;

  PlayHome({this.cartoon});

  @override
  State<StatefulWidget> createState() => new PlayHomeState();
}

class PlayHomeState extends State<PlayHome> {
  String _playUrl = "";
  bool _isHttpComplete = false;
  FlutterWebviewPlugin plugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    print(_playUrl);
    if (_isHttpComplete) {
      return new WebviewScaffold(
         url: _playUrl,
         withJavascript: true,
         clearCache: true,
         withLocalStorage: true,
         withZoom: false,
         appBar: AppBar(
           title: new Text(widget.cartoon.name),
           centerTitle: true,
         ),
       );
    } else {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    String url = widget.cartoon.url.replaceAll("[", "/");
    http.htmlGetPlay((html) {
      HtmlUtils.parsePlay(html, (_url) {
        print("----------$_url");
        DbHelper().insertCartoon(widget.cartoon, () {
          setState(() {
            _playUrl = _url;
            _isHttpComplete = true;
          });
//          _launchURL(_url, () {
//          Navigator.pop(context);
//          });
        });
      }, () {
        _showSnackBar("播放界面解析失败");
        Navigator.pop(context);
      });
    }, url);
  }

  _launchURL(String url, Function fn) async {
    if (await canLaunch(url)) {
      await launch(url);
      fn();
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    DbHelper().close();
    plugin.close();
    super.dispose();
  }

  void _showSnackBar(String msg) {
    Application.key.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }
}
