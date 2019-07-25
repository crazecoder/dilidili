import 'package:dilidili/bean/video.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';


@immutable
abstract class PlayEvent extends Equatable {
  PlayEvent([List props = const []]) : super(props);
}

class LoadEvent extends PlayEvent {
  final Cartoon cartoon;
  final IjkMediaController mediaController;
  LoadEvent(this.cartoon,{this.mediaController}):super([cartoon,mediaController]);
}
