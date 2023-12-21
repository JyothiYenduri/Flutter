import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

void main() {
  querySelector('#getWord').onClick.listen(makeRequest);
  getData();
}

void makeRequest(Event e){
  querySelector('#welcome').text = 'Welcome Page';
}

String url = 'http://192.168.200.32/SCPMobileAPI/api/Categories/GetwelcomeInfo?builderId=7981&communityId=8594';
String token = 'bearer FRY-023jCBQMQXwhIH6kPqFX24zKxvdVogxIxHsZ4b_7JlKq_CcuDAB4VO2RPMp-UBzGTziPmCQgxat1EWR1pdmtt1jaERXkF1lH7edy2_zawJyUo-CLqznHziGrt-geF8pMC4YJVCIGad1TmEDLnzPtc7dC-5jSdViOPa_LwNDDklMj9dlQTplBjDp6mGJAryQwcJQ39jMHsnUAGE3fc05Yh1TQXn1XuMYC0lL4b_8';
Map<String, String> headers = {"Authorization":"$token","Content-Type":"application/json"};

Future<dynamic> getData() async{
  List data;
  return http.get(url, headers: headers).then((http.Response response){
    data = JSON.decode(response.body);
  });
}
