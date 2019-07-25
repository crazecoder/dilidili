import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SearchEvent extends Equatable {
  SearchEvent([List props = const []]) : super(props);
}

class SearchClickEvent extends SearchEvent{
  final String searchText;
  SearchClickEvent(this.searchText):super([searchText]);
}