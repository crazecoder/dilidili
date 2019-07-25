import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HistoryEvent extends Equatable {
  HistoryEvent([List props = const []]) : super(props);
}

class HistoryLoadEvent extends HistoryEvent{}

class HistoryClearEvent extends HistoryEvent{}

