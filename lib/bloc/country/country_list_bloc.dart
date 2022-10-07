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

    Countries? mList;
    Future<void> _getCountries(Emitter<CountryListState> emit) async {
      try {
        emit(CountryListLoading());
        mList = await _apiRepository.getCountries();

        emit(CountryListLoaded(mList));
        if (mList!.status != true) {
          emit(CountryListError(mList!.message));
        }
      } on NetworkError {
        emit(CountryListError("Failed to fetch data. is your device online?"));
      }
    }

    on<GetCountriesList>((event, emit) async {
      await _getCountries(emit);
    });

    Future<void> _removeCountry(Emitter<CountryListState> emit) async {
      emit(CountryListLoading());
      mList!.data!.countries!.remove(mList!.data!.countries!.first);
      emit(CountryListLoaded(mList));
    }

    on<RemoveCountriesList>((event, emit) async {
      await _removeCountry(emit);
    });
  }
}
