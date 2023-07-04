// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'virtru_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VirtruErrorResponse _$VirtruErrorResponseFromJson(Map<String, dynamic> json) =>
    VirtruErrorResponse(
      error: VirtruError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VirtruErrorResponseToJson(
        VirtruErrorResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
    };

VirtruError _$VirtruErrorFromJson(Map<String, dynamic> json) => VirtruError(
      name: json['name'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$VirtruErrorToJson(VirtruError instance) =>
    <String, dynamic>{
      'name': instance.name,
      'message': instance.message,
    };
