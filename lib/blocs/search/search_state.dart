import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../bean/bean.dart';

@immutable
abstract class SearchState extends Equatable {
  SearchState([List props = const []]) : super(props);
}

class InitialSearchState extends SearchState {}

class SearchingState extends SearchState {}

class SearchEmptyState extends SearchState {}

class SearchFailedState extends SearchState {}

class SearchSuccessState extends SearchState {
    final List<Cartoon> cartoons;
    SearchSuccessState(this.cartoons):super([cartoons]);
}
