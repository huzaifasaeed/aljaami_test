import 'package:aljaami_test/model/countries.dart';
import 'package:aljaami_test/services/api_provider.dart';

class ApiRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<Countries?> getCountries() => _apiProvider.getCountries();
}

class NetworkError extends Error {}
