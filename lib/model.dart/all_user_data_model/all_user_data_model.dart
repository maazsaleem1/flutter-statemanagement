import 'package:collection/collection.dart';

import 'datum.dart';

class AllUserDataModel {
  String? message;
  List<Datum>? data;
  bool? status;

  AllUserDataModel({this.message, this.data, this.status});

  factory AllUserDataModel.fromJson(Map<String, dynamic> json) {
    return AllUserDataModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
        'status': status,
      };

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! AllUserDataModel) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => message.hashCode ^ data.hashCode ^ status.hashCode;
}
