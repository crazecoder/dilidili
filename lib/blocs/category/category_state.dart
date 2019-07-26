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
  final String url;
  CategoryDetailState(this.url,[List props = const []]) : super(props);
}
class InitialCategoryDetailState extends CategoryDetailState {
  final String url;
  InitialCategoryDetailState({this.url}):super(url);
}
class CategoryDetailLoadingState extends CategoryDetailState {
  final String url;
  CategoryDetailLoadingState({this.url}):super(url);
}

class CategoryDetailLoaded extends CategoryDetailState {
  final String url;
  final List<Cartoon> cartoons;
  CategoryDetailLoaded({this.url,this.cartoons}) : super(url,[cartoons]);
}

class CategoryDetailEmpty extends CategoryDetailState {
   final String url;
  CategoryDetailEmpty({this.url}):super(url);
}

