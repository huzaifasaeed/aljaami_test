import 'package:aljaami_test/services/api_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';

import '../../model/countries.dart';

part 'country_list_event.dart';
part 'country_list_state.dart';

class CountryListBloc extends Bloc<CountryListEvent, CountryListState> {
  CountryListBloc() : super(CountryListInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    Future<void> _getCountries(Emitter<CountryListState> emit) async {
      try {
        emit(CountryListLoading());
        final mList = await _apiRepository.getCountries();

        emit(CountryListLoaded(mList));
        if (mList!.status != true) {
          emit(CountryListError(mList.message));
        }
      } on NetworkError {
        emit(CountryListError("Failed to fetch data. is your device online?"));
      }
    }

    on<GetCountriesList>((event, emit) async {
      await _getCountries(emit);
    });
  }
}
