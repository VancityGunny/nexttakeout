/*
 Copyright 2018 Square Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:square_in_app_payments/models.dart';
import 'package:http/http.dart' as http;

// Replace this with the server host you create, if you have your own server running
// e.g. https://server-host.com
String chargeServerHost = "https://connect.squareupsandbox.com/v2";
String chargeUrl = "$chargeServerHost/payments";
    String squareAuth =
        'Bearer EAAAEKVcn4lLCbRc8HxfR7T2usPGUNaxIpoI2M72FpQEIXc3hfBZFVSgCGngsKOz'; // + base64Encode(utf8.encode('$yelpApiKey'));

class ChargeException implements Exception {
  String errorMessage;
  ChargeException(this.errorMessage);
}

Future<void> chargeCard(CardDetails result, String orderId) async {
  var body = jsonEncode({"source_id": result.nonce,
   "amount_money": {
      "amount": 100,
      "currency": "CAD"},
      "idempotency_key": orderId,
    "accept_partial_authorization": false,
    "autocomplete": true,
    "location_id": "4D2FG72SP1QHV"
  });
  http.Response response;
  try {
    response = await http.post(chargeUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      'authorization': squareAuth
    });
  } on SocketException catch (ex) {
    throw ChargeException(ex.message);
  }

  var responseBody = json.decode(response.body);
  if (response.statusCode == 200) {
    return;
  } else {
    throw ChargeException(responseBody["errorMessage"]);
  }
}

Future<void> chargeCardAfterBuyerVerification(
    BuyerVerificationDetails result) async {
  var body = jsonEncode({"nonce": result.nonce, "token": result.token});
  http.Response response;
  try {
    response = await http.post(chargeUrl, body: body, headers: {
      "Accept": "application/json",
      "content-type": "application/json"
    });
  } on SocketException catch (ex) {
    throw ChargeException(ex.message);
  }

  var responseBody = json.decode(response.body);
  if (response.statusCode == 200) {
    return;
  } else {
    throw ChargeException(responseBody["errorMessage"]);
  }
}