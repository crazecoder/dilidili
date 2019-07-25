import 'package:dilidili/bean/bean.dart';
import 'package:dilidili/blocs/blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:flutter_gsyplayer/flutter_gsyplayer.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class PlayHome extends StatelessWidget {
  final Cartoon cartoon;

  PlayHome({this.cartoon});
  IjkMediaController controller = IjkMediaController();

  @override
  Widget build(BuildContext context) {
    final PlayBloc _bloc = BlocProvider.of<PlayBloc>(context);
    return BlocBuilder<PlayEvent, PlayState>(
      bloc: _bloc..dispatch(LoadEvent(cartoon, mediaController: controller)),
      builder: (_, _state) {
        if (_state is LoadedFailedState) {
          // _showSnackBar("播放界面解析失败");
          Navigator.pop(context);
          return null;
        } else if (_state is LoadedPlayerState) {
          controller.setNetworkDataSource(_state.playUrl, autoPlay: true);
          return Scaffold(
            appBar: AppBar(
              title: Text(_state.title),
            ),
            body: buildIjkPlayer(),
          );
          // play(url: _state.playUrl, title: _state.title);
          // Navigator.pop(context);
          // return null;
        } else if (_state is LoadedWebviewState) {
          return WebviewScaffold(
            url: _state.url,
            withJavascript: true,
            clearCache: true,
            withLocalStorage: true,
            withZoom: false,
            appBar: AppBar(
              title: new Text(_state.title),
              centerTitle: true,
            ),
          );
        } else {
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildIjkPlayer() {
    return Container(
      // height: 400, // 这里随意
      child: IjkPlayer(
        mediaController: controller,
      ),
    );
  }
}
