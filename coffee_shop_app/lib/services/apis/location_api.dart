import 'package:http/http.dart' as http;

class LocationApi {
  static String apiKey = "AIzaSyBosQ4pNoDkbozACtL1XEkyyvkdbwJRqUw";
  static Future<http.Response> getLocationData(String text) async {
    http.Response response;

    response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/place/textsearch/json?query=$text&inputtype=textquery&key=$apiKey"));

    return response;
  }
}
