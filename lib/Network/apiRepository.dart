import 'package:uggiso/Model/otpModel.dart';
import 'package:uggiso/Network/apiProvider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  /*Future<OtpModel> fetchCovidList() {
    return _provider.fetchCovidList();
  }*/
}

class NetworkError extends Error {}