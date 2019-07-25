import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dilidili/blocs/blocs.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import 'play.dart';
import '../../db/db_helper.dart';
import '../../constant.dart';
import '../../http.dart' as http;
import '../../utils/html_util.dart';
import '../../utils/string_util.dart';

class PlayBloc extends Bloc<PlayEvent, PlayState> {
  IjkMediaController mediaController;

  @override
  PlayState get initialState => InitialPlayState();

  @override
  Stream<PlayState> mapEventToState(
    PlayEvent event,
  ) async* {
    if (event is LoadEvent) {
      yield* _loadUrl(event);
    }
  }

  Stream<PlayState> _loadUrl(LoadEvent event) async* {
    mediaController = event.mediaController;
    String url = event.cartoon.url.replaceAll("[", "/");
    if (!url.contains(ConstantValue.URL)) {
      url = "${ConstantValue.URL}$url";
    }
    String _html = await http.htmlGetPlay(url);
    try {
      String _playUrl = await HtmlUtils.parsePlay(_html);
      if (getVideoUrl(_playUrl).length > 0) {
        String _url = getVideoUrl(_playUrl)[0]
            .replaceAll("http://player.jfrft.net/index.php?url=", "");
        yield LoadedPlayerState(_url, title: event.cartoon.name);
      } else {
        yield LoadedWebviewState(_playUrl, title: event.cartoon.name);
      }
      DbHelper().insertCartoon(event.cartoon, () {});
    } catch (e) {
      yield LoadedFailedState();
    }
  }

  @override
  void dispose() {
    if (mediaController != null && mediaController.isPlaying) {
      mediaController.stop();
      mediaController.dispose();
    }
    DbHelper().close();
    super.dispose();
  }
}
