import 'dart:convert';
import 'package:http/http.dart';
import 'package:uggiso/Model/otpModel.dart';
import 'package:uggiso/Network/apiProvider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  String userUrl = 'https://reqres.in/api/users?page=2';

/*  Future<List<OtpModel>> getOtp() async {
    Response response = await get(Uri.parse(userUrl));

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data'];
      return result.map((e) => OtpModel.fromJson(e)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }*/

  Future<OtpModel> getOtp(String number) {
    return _provider.getOtp(number);
  }
}