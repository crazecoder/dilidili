import 'package:dilidili/bean/bean.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NewestState extends Equatable {
  NewestState([List props = const []]) : super(props);
}

class InitialNewestState extends NewestState {}

class NewestLoadedState extends NewestState {
  final List<Cartoon> cartoons;
  NewestLoadedState(this.cartoons):super([cartoons]);
}

class NewestLoadFailedState extends NewestState {}
