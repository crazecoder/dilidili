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
  CategoryLoaded({this.categorys}) : super([categorys]);
}

@immutable
abstract class CategoryDetailState extends Equatable {
  CategoryDetailState([List props = const []]) : super(props);
}
class InitialCategoryDetailState extends CategoryDetailState {}

class CategoryDetailLoaded extends CategoryDetailState {
  final List<Cartoon> cartoons;
  CategoryDetailLoaded({this.cartoons}) : super([cartoons]);
}

class CategoryDetailEmpty extends CategoryDetailState {}

// class CategoryLoadFailed extends CategoryDetailState {}
