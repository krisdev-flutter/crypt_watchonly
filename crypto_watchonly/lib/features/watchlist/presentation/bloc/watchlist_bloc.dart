import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/watchlist_local_data_source.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();
  @override
  List<Object?> get props => [];
}

class WatchlistStarted extends WatchlistEvent {
  const WatchlistStarted();
}

class WatchlistToggled extends WatchlistEvent {
  const WatchlistToggled(this.coinId);
  final String coinId;
  @override
  List<Object?> get props => [coinId];
}

class WatchlistState extends Equatable {
  const WatchlistState({this.ids = const {}, this.loading = true});
  final Set<String> ids;
  final bool loading;
  bool contains(String id) => ids.contains(id);
  @override
  List<Object?> get props => [ids, loading];
}

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc(this._dataSource) : super(const WatchlistState()) {
    on<WatchlistStarted>(_load);
    on<WatchlistToggled>(_toggle);
  }
  final WatchlistLocalDataSource _dataSource;

  Future<void> _load(
      WatchlistStarted event, Emitter<WatchlistState> emit) async {
    final ids = await _dataSource.getIds();
    emit(WatchlistState(ids: ids, loading: false));
  }

  Future<void> _toggle(
      WatchlistToggled event, Emitter<WatchlistState> emit) async {
    await _dataSource.toggle(event.coinId);
    emit(WatchlistState(ids: await _dataSource.getIds(), loading: false));
  }
}
