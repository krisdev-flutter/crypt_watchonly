import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/coin_detail.dart';
import '../../domain/entities/price_point.dart';
import '../../domain/repositories/coin_repository.dart';

abstract class CoinDetailEvent extends Equatable {
  const CoinDetailEvent();
  @override
  List<Object?> get props => [];
}

class CoinDetailRequested extends CoinDetailEvent {
  const CoinDetailRequested(this.coinId);
  final String coinId;
  @override
  List<Object?> get props => [coinId];
}

class CoinChartPeriodChanged extends CoinDetailEvent {
  const CoinChartPeriodChanged(this.days);
  final int days;
  @override
  List<Object?> get props => [days];
}

enum CoinDetailStatus { initial, loading, success, failure }

class CoinDetailState extends Equatable {
  const CoinDetailState({
    this.status = CoinDetailStatus.initial,
    this.detail,
    this.points = const [],
    this.days = 7,
    this.errorMessage,
    this.chartLoading = false,
  });
  final CoinDetailStatus status;
  final CoinDetail? detail;
  final List<PricePoint> points;
  final int days;
  final String? errorMessage;
  final bool chartLoading;

  CoinDetailState copyWith({
    CoinDetailStatus? status,
    CoinDetail? detail,
    List<PricePoint>? points,
    int? days,
    String? errorMessage,
    bool? chartLoading,
  }) =>
      CoinDetailState(
        status: status ?? this.status,
        detail: detail ?? this.detail,
        points: points ?? this.points,
        days: days ?? this.days,
        errorMessage: errorMessage,
        chartLoading: chartLoading ?? this.chartLoading,
      );

  @override
  List<Object?> get props =>
      [status, detail, points, days, errorMessage, chartLoading];
}

class CoinDetailBloc extends Bloc<CoinDetailEvent, CoinDetailState> {
  CoinDetailBloc(this._repository) : super(const CoinDetailState()) {
    on<CoinDetailRequested>(_load);
    on<CoinChartPeriodChanged>(_changePeriod);
  }
  final CoinRepository _repository;

  Future<void> _load(
      CoinDetailRequested event, Emitter<CoinDetailState> emit) async {
    // Load the coin information separately from the chart. If chart data fails,
    // users can still view price and market statistics.
    emit(CoinDetailState(
      status: CoinDetailStatus.loading,
      days: state.days,
      chartLoading: true,
    ));

    late final CoinDetail detail;
    try {
      detail = await _repository.getCoinDetails(event.coinId);
    } catch (error) {
      emit(CoinDetailState(
        status: CoinDetailStatus.failure,
        days: state.days,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      ));
      return;
    }

    emit(CoinDetailState(
      status: CoinDetailStatus.success,
      detail: detail,
      days: state.days,
      chartLoading: true,
    ));

    try {
      final points =
          await _repository.getCoinChart(detail.id, days: state.days);
      emit(state.copyWith(points: points, chartLoading: false));
    } catch (error) {
      emit(state.copyWith(
        chartLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _changePeriod(
      CoinChartPeriodChanged event, Emitter<CoinDetailState> emit) async {
    final detail = state.detail;
    if (detail == null) return;
    emit(state.copyWith(
        days: event.days, chartLoading: true, errorMessage: null));
    try {
      final points =
          await _repository.getCoinChart(detail.id, days: event.days);
      emit(state.copyWith(points: points, chartLoading: false));
    } catch (error) {
      emit(state.copyWith(chartLoading: false, errorMessage: error.toString()));
    }
  }
}
