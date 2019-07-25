import 'package:dilidili/bean/video.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DetailState  extends Equatable {
    DetailState([List props = const []]) : super(props);
}
  
class InitialDetailState extends DetailState {}

class DetailLoadFailedState extends DetailState {}

class DetailLoadEmptyState extends DetailState {}

class DetailLoadedState extends DetailState {
  final String url;
  final String picture;
  final List<Cartoon> cartoons;
  DetailLoadedState({this.url,this.picture,this.cartoons});
}
