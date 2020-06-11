import 'package:http/http.dart';
import 'dart:convert';

class YelpWebService {
  Future<Map<String, dynamic>> getBusienssInfo(String businessId) async {
    var url = 'https://api.yelp.com/v3/businesses/' + businessId;
    String yelpApiKey =
        '_81ED9-QOIr4jj3LemdrBXHM2GWb6yI-DhU4VBaITp5GMZ_8c5qx2XxQJM84mSbGYhbHdQNhtfzfSw--i2-ED4j39Xk6oOfTc5I87uNjG4HaipV0ZQZL7VM6Kq_aXnYx';
    String yelpAuth =
        'Bearer ' + yelpApiKey; // + base64Encode(utf8.encode('$yelpApiKey'));

    Response r =
        await get(url, headers: <String, String>{'authorization': yelpAuth});
    return jsonDecode(r.body);
  }
}
