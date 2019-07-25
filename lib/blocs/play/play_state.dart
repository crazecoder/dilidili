import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class PlayState extends Equatable {
  PlayState([List props = const []]) : super(props);
}

class InitialPlayState extends PlayState {}

class LoadedPlayerState extends PlayState {
  final String playUrl;
  final String title;
  LoadedPlayerState(this.playUrl,{this.title}):super([playUrl,title]);
}

class LoadedWebviewState extends PlayState {
  final String url;
  final String title;
  LoadedWebviewState(this.url,{this.title}):super([url,title]);
}

class LoadedFailedState extends PlayState {}