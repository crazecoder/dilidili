import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  CategoryEvent([List props = const []]) : super(props);
}

class CategoryLoadEvent extends CategoryEvent{}
class CategoryChangeEvent extends CategoryEvent{
  final int position;
  CategoryChangeEvent({this.position});
}



@immutable
abstract class CategoryDetailEvent extends Equatable {
  CategoryDetailEvent([List props = const []]) : super(props);
}
class CategoryDetailLoadEvent extends CategoryDetailEvent{
  final String category;
  CategoryDetailLoadEvent(this.category):super([category]);
}