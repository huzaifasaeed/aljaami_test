part of 'country_list_bloc.dart';

abstract class CountryListState extends Equatable {
  const CountryListState();

  @override
  List<Object?> get props => [];
}

class CountryListInitial extends CountryListState {}

class CountryListLoading extends CountryListState {}

class CountryListLoaded extends CountryListState {
  final Countries? countries;
  const CountryListLoaded(this.countries);
}

class CountryListError extends CountryListState {
  final String? message;
  const CountryListError(this.message);
}
