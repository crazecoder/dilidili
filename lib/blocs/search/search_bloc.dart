import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dilidili/bean/bean.dart';
import '../../utils/html_util.dart';
import './search.dart';
import '../../http.dart' as http;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  @override
  SearchState get initialState => InitialSearchState();

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchClickEvent) {
      yield* search(event.searchText);
    }
  }

  Stream<SearchState> search(String _text) async* {
    if(_text.isEmpty) {
      yield InitialSearchState();
      return;
    }
    yield SearchingState();
    String _html = await http.htmlGetSearch(_text);
    List<Cartoon> _cartoons = await HtmlUtils.parseSearch(_html);
    if (_cartoons != null && _cartoons.isNotEmpty) {
      yield SearchSuccessState(_cartoons);
    }else{
      yield SearchEmptyState();
    }
  }
}
