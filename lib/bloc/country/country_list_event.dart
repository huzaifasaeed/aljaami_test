part of 'country_list_bloc.dart';

abstract class CountryListEvent extends Equatable {
  const CountryListEvent();

  @override
  List<Object> get props => [];
}

class GetCountriesList extends CountryListEvent {}

class RemoveCountriesList extends CountryListEvent {}
