import 'package:http/http.dart' as http;

class LocationApi {
  static String apiKey =
      "pk.eyJ1IjoiemVyb3JlaSIsImEiOiJjbGlidXpyYTQwOXNmM2Zxb3BpdWQwaDFqIn0.xrYRn0Fyr85ddyR5DoHXEw";
  static Future<http.Response> getLocationData(String text) async {
    http.Response response;

    response = await http.get(Uri.parse(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$text.json?autocomplete=true&country=VN&language=vi&access_token=$apiKey"));

    return response;
  }
}
