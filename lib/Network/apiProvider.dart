import 'package:dio/dio.dart';
import 'package:uggiso/Model/otpModel.dart';
import 'package:uggiso/Network/constants.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _url = Constants.baseUrl;

  /*Future<OtpModel> getOtp() async {
    try {
      Response response = await _dio.get(_url);
      // return OtpModel.fromJson(response.data);
      return [];
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      // return OtpModel.withError("Data not found / Connection issue");
      return '';
    }
  }*/
}