import 'package:dilidili/bean/bean.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HistoryState extends Equatable {
  HistoryState([List props = const []]) : super(props);
}

class InitialHistoryState extends HistoryState {}

class HistoryEmptyState extends HistoryState {}

class HistoryLoadedState extends HistoryState {
  final List<Cartoon> cartoons;
  HistoryLoadedState(this.cartoons):super([cartoons]);
}
