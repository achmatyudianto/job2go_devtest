import 'dart:convert';
import 'package:http/http.dart' as http;

// New Class call API
class CallApi {
  final String _url = 'https://api.todoist.com/rest/v1/';

  setHeader() async {
    var header = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer {your_api_token}',
    };
    return header;
  }

  // POST method
  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: await setHeader(),
    );
  }

  // PUT method
  putData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.put(
      fullUrl,
      body: jsonEncode(data),
      headers: await setHeader(),
    );
  }

  // GET method
  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(
      fullUrl,
      headers: await setHeader(),
    );
  }
}
