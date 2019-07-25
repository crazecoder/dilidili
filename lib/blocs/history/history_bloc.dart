import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dilidili/bean/video.dart';
import '../../db/db_helper.dart';
import './history.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  @override
  HistoryState get initialState => InitialHistoryState();

  @override
  Stream<HistoryState> mapEventToState(
    HistoryEvent event,
  ) async* {
    if (event is HistoryLoadEvent) {
      yield* _load();
    } else if (event is HistoryClearEvent) {
      yield* _clear();
    }
  }

  Stream<HistoryState> _load() async* {
    List<Cartoon> _cartoons = await DbHelper().getCartoon();
    if (_cartoons != null && _cartoons.isNotEmpty) {
      yield HistoryLoadedState(_cartoons);
    }else{
       yield HistoryEmptyState();
    }
  }

  Stream<HistoryState> _clear() async* {
    yield InitialHistoryState();
    await DbHelper().clear();
    yield HistoryEmptyState();
  }
  @override
  void dispose() {
    DbHelper().close();
    super.dispose();
  }
}
