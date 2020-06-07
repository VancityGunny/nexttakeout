import 'package:equatable/equatable.dart';

class BusinessModel extends Equatable {
  String id;
  String businessName;
  String yelpId;
  String phone;
  String photoUrl;

  BusinessModel(
      [this.id, this.businessName, this.yelpId, this.phone, this.photoUrl]);

  @override
  List<Object> get props => [id, businessName, yelpId, phone, photoUrl];

  factory BusinessModel.fromJson(Map<dynamic, dynamic> json) {
    return BusinessModel(
        json['id'] as String,
        json['businessName'] as String,
        json['yelpId'] as String,
        json['phone'] as String,
        json['photoUrl'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['businessName'] = this.businessName;
    data['yelpId'] = this.yelpId;
    data['phone'] = this.phone;
    data['photoUrl'] = this.photoUrl;
    return data;
  }
}
