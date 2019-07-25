import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DetailEvent extends Equatable {
  DetailEvent([List props = const []]) : super(props);
}

class DetailLoadEvent extends DetailEvent {
  final String url;
  final String picture;
  DetailLoadEvent({this.url, this.picture}):super([url,picture]);
}
