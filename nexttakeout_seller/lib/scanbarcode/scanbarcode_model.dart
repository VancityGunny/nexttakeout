import 'package:equatable/equatable.dart';

/// generate by https://javiercbk.github.io/json_to_dart/
class AutogeneratedScanbarcode {
  final List<ScanbarcodeModel> results;

  AutogeneratedScanbarcode({this.results});

  factory AutogeneratedScanbarcode.fromJson(Map<String, dynamic> json) {
    List<ScanbarcodeModel> temp;
    if (json['results'] != null) {
      temp = <ScanbarcodeModel>[];
      json['results'].forEach((v) {
        temp.add(ScanbarcodeModel.fromJson(v as Map<String, dynamic>));
      });
    }
    return AutogeneratedScanbarcode(results: temp);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (results != null) {
      data['results'] = results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScanbarcodeModel extends Equatable {
  final int id;
  final String name;

  ScanbarcodeModel(this.id, this.name);

  @override
  List<Object> get props => [id, name];

  factory ScanbarcodeModel.fromJson(Map<String, dynamic> json) {
    return ScanbarcodeModel(json['id'] as int, json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
  
}