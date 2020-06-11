import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nexttakeout_seller/yelp/yelp_web_service.dart';
void main() {
  test('Yelp should return a busienss', () async {
    YelpWebService yelpService = new YelpWebService();
    var result = await yelpService.getBusienssInfo('02cGvRTfVXeHWYkoiyj6wA');
    expect(result['name'], 'Kita No Donburi');
  });
}
