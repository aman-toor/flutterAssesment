import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/global.dart';

class ApiService {
  static String Token = '';
  static Future<Map<String, dynamic>> fetchTermsAndConditions() async {
    final response = await http.get(Uri.parse('${baseURL}terms-conditions'),
      headers: headers, );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load terms and conditions');
    }
  }

  static Future<Map<String, dynamic>> fetchCountryList() async {
    final response = await http.get(Uri.parse('${baseURL}countries'),
      headers: headers, );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load select country list');
    }
  }

  static Future<Map<String, dynamic>> studentLogin(String code, String phoneNumber) async {
    var request = http.Request('POST', Uri.parse('${baseURL}student/login'));
    request.body = json.encode({
      "tel_code": code,
      "phone": phoneNumber
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      final decodedResponse = json.decode(jsonResponse);
      final message = decodedResponse['message'];
      return {'success': true, 'message': message};
    } else {
      return {'success': false, 'message': 'Failed to login'};
    }
  }

  static Future<Map<String, dynamic>> counsellorLogin(String code, String phoneNumber) async {
    var request = http.Request('POST', Uri.parse('${baseURL}counsellor/login'));
    request.body = json.encode({
      "tel_code": code,
      "phone": phoneNumber
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      final decodedResponse = json.decode(jsonResponse);
      final message = decodedResponse['message'];
      return {'success': true, 'message': message};

    }
    else {
      print(response.reasonPhrase);
      return {'success': false, 'message': 'Failed to login'};
    }

  }


  static Future<Map<String, dynamic>> verifyOtp(String code, String phoneNumber) async {
    var request = http.MultipartRequest('POST', Uri.parse('${baseURL}verify-otp'));
    request.fields.addAll({
      'code': code,
      'phone': phoneNumber
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      final decodedResponse = json.decode(jsonResponse);

      final message = decodedResponse['message'];
      final token=decodedResponse['data'];
      final accesstoken=token['access_token'];
      print(accesstoken);
      Token=accesstoken;
      return {'success': true, 'message': message};
    }
    else {
      return {'success': false, 'message': 'Failed to verify'};
    }

  }

   static Future<Map<String, dynamic>> selectCountryForStudy(String id)async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $Token'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseURL}select/country'));
    request.fields.addAll({
      'country_id':id
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)
    {
      final jsonResponse = await response.stream.bytesToString();
      final decodedResponse = json.decode(jsonResponse);

      final message = decodedResponse['message'];
      return {'success': true, 'message': message};
    }
    else
    {
      return {'success': false, 'message': 'Failed to select country'};
    }

  }

  static Future<Map<String, dynamic>> showCountries() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $Token'
    };
    var request = http.Request('GET', Uri.parse('${baseURL}select/country'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      final decodedResponse = json.decode(jsonResponse);
      final countries = decodedResponse['data']['countries'];
      return {'success': true, 'countries': countries};
    } else {
      print(response.reasonPhrase);
      return {'success': false, 'error': response.reasonPhrase};
    }
  }
  static Future<Map<String, dynamic>> logOut() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $Token'
    };
    var request = http.Request('POST', Uri.parse('${baseURL}logout'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      final decodedResponse = json.decode(jsonResponse);

      final message = decodedResponse['message'];
      return {'success': true, 'message': message};
    }
    else {
      return {'success': true, 'message': 'failed to logout'};
    }

  }

  static Future<Map<String, dynamic>> deleteAccount()async{
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $Token'
    };
    var request = http.Request('POST', Uri.parse('${baseURL}delete'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      final decodedResponse = json.decode(jsonResponse);

      final message = decodedResponse['message'];
      return {'success': true, 'message': message};
    }
    else {
      return {'success': true, 'message': 'failed to delete'};
    }

  }


  static Future<Map<String, dynamic>> resendOtp(String phone)async {
    var headers = {
      'Accept': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseURL}resend-otp'));
    request.fields.addAll({
      'phone': phone
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString();
      final decodedResponse = json.decode(jsonResponse);
      final message = decodedResponse['message'];
      return {'success': true, 'message': message};
    }
    else {
      return {'success': false, 'message': 'Failed to resend OTP'};
    }

  }
}
