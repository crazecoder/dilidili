import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NewestEvent extends Equatable {
  NewestEvent([List props = const []]) : super(props);
}

class NewestLoadEvent extends NewestEvent {}
