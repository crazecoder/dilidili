import 'dart:async';
import 'package:bloc/bloc.dart';
import 'category.dart';
import '../../bean/bean.dart';
import '../../http.dart' as http;
import '../../utils/html_util.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  int _position = 0;
  @override
  CategoryState get initialState => InitialCategoryState();

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    if (event is CategoryLoadEvent) {
      yield* _loadCategory();
    } else if (event is CategoryChangeEvent) {
      _position = event.position;
    }
  }

  get prePosition => _position;
  Stream<CategoryState> _loadCategory() async* {
    String _html = await http.htmlGetCategory();
    List<Category> _categories = await HtmlUtils.parseCategory(_html);
    var detailBlocs = {};
    for (Category _category in _categories) {
      detailBlocs.putIfAbsent(
          _category.categoryUrl, () => CategoryDetailBloc());
    }
    yield CategoryLoaded(categorys: _categories, map: detailBlocs);
  }
}

class CategoryDetailBloc
    extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  static Map<String, bool> _map = Map<String, bool>();
  @override
  CategoryDetailState get initialState => InitialCategoryDetailState();

  @override
  Stream<CategoryDetailState> mapEventToState(
    CategoryDetailEvent event,
  ) async* {
    if (event is CategoryDetailLoadEvent) {
      yield* _loadCategoryDetail(event);
    }
  }

  Stream<CategoryDetailState> _loadCategoryDetail(
      CategoryDetailLoadEvent event) async* {
    // yield InitialCategoryDetailState();
    List<Cartoon> _cartoons = await http.htmlGetCategoryDetail(
      event.category,
    );
    if (_cartoons.isEmpty) {
      yield CategoryDetailEmpty();
    } else {
      yield CategoryDetailLoaded(cartoons: _cartoons);
      _map.putIfAbsent(event.category, () => true);
    }
  }

  get cacheMap => _map;
}
