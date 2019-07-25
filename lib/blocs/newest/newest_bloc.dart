import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../bean/bean.dart';
import '../../utils/html_util.dart';
import '../../http.dart' as http;
import 'newest.dart';

class NewestBloc extends Bloc<NewestEvent, NewestState> {
  @override
  NewestState get initialState => InitialNewestState();

  @override
  Stream<NewestState> mapEventToState(
    NewestEvent event,
  ) async* {
    if (event is NewestLoadEvent) yield* _load();
  }

  Stream<NewestState> _load() async* {
    String _htmlStr = await http.htmlGetHome();
    List<Cartoon> _cartoons = await HtmlUtils.parseHome(_htmlStr);
    if (_cartoons != null && _cartoons.isNotEmpty) {
      yield NewestLoadedState(_cartoons);
    }else{
      yield NewestLoadFailedState();
    }
  }
}
