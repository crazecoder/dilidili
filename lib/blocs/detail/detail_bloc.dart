import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../bean/bean.dart';
import '../../http.dart' as http;
import 'detail.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  @override
  DetailState get initialState => InitialDetailState();

  @override
  Stream<DetailState> mapEventToState(
    DetailEvent event,
  ) async* {
    if (event is DetailLoadEvent) {
      yield* _loadUrl(event);
    }
  }

  Stream<DetailState> _loadUrl(DetailLoadEvent event) async* {
    String url = event.url.replaceAll("[", "/");
    List<Cartoon> _cs = await http.htmlGetCategoryDetailHome(url);
    if (_cs != null && _cs.isNotEmpty) {
      String picture = event.picture?.replaceAll("[", "/");
      if (picture == null || picture.isEmpty || picture == 'null') {
        picture = _cs[0].picture;
      }
      yield DetailLoadedState(url: url, picture: picture, cartoons: _cs);
    } else {
      yield DetailLoadFailedState();
    }
  }
}
