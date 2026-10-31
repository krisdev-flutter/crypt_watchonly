import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../coin/domain/entities/coin.dart';
import '../../../coin/domain/repositories/coin_repository.dart';

enum MarketSort { marketCap, price, change }

enum MarketFilter { all, gainers, losers }

abstract class MarketEvent extends Equatable {
  const MarketEvent();
  @override
  List<Object?> get props => [];
}

class MarketStarted extends MarketEvent {
  const MarketStarted();
}

class MarketRefreshed extends MarketEvent {
  const MarketRefreshed();
}

class MarketQueryChanged extends MarketEvent {
  const MarketQueryChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}

class MarketSortChanged extends MarketEvent {
  const MarketSortChanged(this.sort);
  final MarketSort sort;
  @override
  List<Object?> get props => [sort];
}

class MarketFilterChanged extends MarketEvent {
  const MarketFilterChanged(this.filter);
  final MarketFilter filter;
  @override
  List<Object?> get props => [filter];
}

enum MarketStatus { initial, loading, success, failure }

class MarketState extends Equatable {
  const MarketState({
    this.status = MarketStatus.initial,
    this.coins = const [],
    this.query = '',
    this.sort = MarketSort.marketCap,
    this.filter = MarketFilter.all,
    this.errorMessage,
  });
  final MarketStatus status;
  final List<Coin> coins;
  final String query;
  final MarketSort sort;
  final MarketFilter filter;
  final String? errorMessage;

  List<Coin> get visibleCoins {
    final normalizedQuery = query.trim().toLowerCase();
    final filtered = coins.where((coin) {
      final matchesQuery = normalizedQuery.isEmpty ||
          coin.name.toLowerCase().contains(normalizedQuery) ||
          coin.symbol.toLowerCase().contains(normalizedQuery);
      final matchesFilter = switch (filter) {
        MarketFilter.all => true,
        MarketFilter.gainers => coin.priceChangePercentage24h > 0,
        MarketFilter.losers => coin.priceChangePercentage24h < 0,
      };
      return matchesQuery && matchesFilter;
    });

    final result = filtered.toList();
    switch (sort) {
      case MarketSort.marketCap:
        // Assets without a rank should remain at the bottom of the list.
        result.sort((a, b) {
          if (a.marketCapRank == 0 && b.marketCapRank == 0) return 0;
          if (a.marketCapRank == 0) return 1;
          if (b.marketCapRank == 0) return -1;
          return a.marketCapRank.compareTo(b.marketCapRank);
        });
        break;
      case MarketSort.price:
        result.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case MarketSort.change:
        result.sort((a, b) =>
            b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h));
        break;
    }
    return result;
  }

  MarketState copyWith({
    MarketStatus? status,
    List<Coin>? coins,
    String? query,
    MarketSort? sort,
    MarketFilter? filter,
    String? errorMessage,
    bool clearError = false,
  }) =>
      MarketState(
        status: status ?? this.status,
        coins: coins ?? this.coins,
        query: query ?? this.query,
        sort: sort ?? this.sort,
        filter: filter ?? this.filter,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, coins, query, sort, filter, errorMessage];
}

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  MarketBloc(this._repository) : super(const MarketState()) {
    on<MarketStarted>((event, emit) => _load(emit));
    on<MarketRefreshed>((event, emit) => _load(emit, keepData: true));
    on<MarketQueryChanged>(
        (event, emit) => emit(state.copyWith(query: event.query)));
    on<MarketSortChanged>(
        (event, emit) => emit(state.copyWith(sort: event.sort)));
    on<MarketFilterChanged>(
        (event, emit) => emit(state.copyWith(filter: event.filter)));
  }

  final CoinRepository _repository;

  Future<void> _load(Emitter<MarketState> emit, {bool keepData = false}) async {
    emit(state.copyWith(
      status: keepData && state.coins.isNotEmpty
          ? MarketStatus.success
          : MarketStatus.loading,
      clearError: true,
    ));
    try {
      final coins = await _repository.getMarkets();
      emit(state.copyWith(
          status: MarketStatus.success, coins: coins, clearError: true));
    } catch (error) {
      emit(state.copyWith(
        status: MarketStatus.failure,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
