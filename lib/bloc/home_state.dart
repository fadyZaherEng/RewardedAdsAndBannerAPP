part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeGetRewarded extends HomeState {}

final class HomeGetBanner extends HomeState {}
