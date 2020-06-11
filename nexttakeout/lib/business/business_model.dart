import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:nexttakeout/business/index.dart';

class BusinessModel extends Equatable {
  String id;
  String businessName;
  String yelpId;
  String phone;
  String photoUrl;
  List<String> address;
  GeoFirePoint coordinates;
  String ownerUserId;

  BusinessModel(
      [this.id,
      this.businessName,
      this.yelpId,
      this.phone,
      this.photoUrl,
      this.address,
      this.coordinates,
      this.ownerUserId]);

  @override
  List<Object> get props => [
        id,
        businessName,
        yelpId,
        phone,
        photoUrl,
        this.address,
        this.coordinates,
        this.ownerUserId
      ];

  factory BusinessModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return BusinessModel(
        doc.documentID,
        doc.data['name'] as String,
        null, //yelpId
        doc.data['phone'] as String,
        doc.data['imageurl'] as String,
        (doc.data['address'] as List<dynamic>).map((dynamic e) => e as String).toList() as List<String>,
        null, //geopoint
        doc.data['owner_user_id'] as String);
  }
  factory BusinessModel.fromYelpJson(Map<dynamic, dynamic> json) {
    return BusinessModel(
      json['id'] as String,
      json['name'] as String,
      json['yelpId'] as String,
      json['phone'] as String,
      json['image_url'] as String,
      List<String>.from(json['location']['display_address']),
      new GeoFirePoint(json['coordinates']['latitude'] as double,
          json['coordinates']['longitude'] as double),
      json['owner_user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.businessName;
    data['yelpId'] = this.yelpId;
    data['phone'] = this.phone;
    data['image_url'] = this.photoUrl;
    data['display_address'] = this.address;
    data['coordinates'] = this.coordinates;
    data['owner_user_id'] = this.ownerUserId;
    return data;
  }
}
