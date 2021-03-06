import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  String id;
  final String uid;
  final String email;
  final String displayName;
  final String phone;
  final String photoUrl;

  UserModel(this.id, this.uid, this.email, this.displayName, this.phone,
      this.photoUrl);

  @override
  List<Object> get props => [id, uid, email, displayName, phone, photoUrl];

  factory UserModel.fromJson(Map<dynamic, dynamic> json) {
    return UserModel(
        json['id'] as String,
        json['uid'] as String,
        json['email'] as String,
        json['displayName'] as String,
        json['phone'] as String,
        json['photoUrl'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['displayName'] = this.displayName;
    data['phone'] = this.phone;
    data['photoUrl'] = this.photoUrl;
    return data;
  }
}
