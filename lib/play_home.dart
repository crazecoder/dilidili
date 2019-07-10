import 'package:flutter/material.dart';
import 'http.dart' as http;
import 'utils/html_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'db/db_helper.dart';
import 'lib/library.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class PlayHome extends StatefulWidget {
  final Cartoon cartoon;

  PlayHome({this.cartoon});

  @override
  State<StatefulWidget> createState() => new PlayHomeState();
}

class PlayHomeState extends State<PlayHome> {
  String _playUrl = "";
  bool _isHttpComplete = false;
  // final FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  IjkMediaController controller = IjkMediaController();

  @override
  Widget build(BuildContext context) {
    print(_playUrl);
    if (_isHttpComplete) {
      if (getVideoUrl(_playUrl).length > 0) {
        String url = getVideoUrl(_playUrl)[0].replaceAll("http://player.jfrft.net/index.php?url=", "");
        print(url);
        controller.setNetworkDataSource(url, autoPlay: true);
        return Scaffold(appBar: AppBar(title: Text(widget.cartoon.name),),body: buildIjkPlayer(),);
      } else {
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
      }
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
    // flutterWebviewPlugin?.close();
    controller.pause();
    controller.dispose();
    super.dispose();
  }

  void _showSnackBar(String msg) {
    Application.key.currentState
        .showSnackBar(new SnackBar(content: new Text(msg)));
  }

  Widget buildIjkPlayer() {
    return Container(
      // height: 400, // 这里随意
      child: IjkPlayer(
        mediaController: controller,
      ),
    );
  }

  List<String> getVideoUrl(str) {
    var urls = <String>[];
    String mode =
        "https?:\\/\\/[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]*.(swf|wma|avi|flv|mpg|rm|mov|wav|mp4|asf|3gp|mkv|rmvb|m3u8)";
    RegExp reg = new RegExp(mode);
    Iterable<Match> matches = reg.allMatches(str);
    for (Match m in matches) {
      urls.add(m.group(0));
    }
    return urls;
  }
}
