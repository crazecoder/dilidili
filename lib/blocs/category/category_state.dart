import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:dilidili/bean/bean.dart';

@immutable
abstract class CategoryState extends Equatable {
  CategoryState([List props = const []]) : super(props);
}

class InitialCategoryState extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categorys;
  final Map map;
  CategoryLoaded({this.categorys,this.map}) : super([categorys,map]);
}

@immutable
abstract class CategoryDetailState extends Equatable {
  CategoryDetailState([List props = const []]) : super(props);
}
class InitialCategoryDetailState extends CategoryDetailState {
}
class CategoryDetailLoadingState extends CategoryDetailState {
}

class CategoryDetailLoaded extends CategoryDetailState {
  final List<Cartoon> cartoons;
  CategoryDetailLoaded({this.cartoons}) : super([cartoons]);
}

class CategoryDetailEmpty extends CategoryDetailState {
}

