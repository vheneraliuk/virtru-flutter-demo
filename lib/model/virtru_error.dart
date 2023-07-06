import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'virtru_error.g.dart';

@JsonSerializable()
class VirtruErrorResponse {
  final VirtruError error;

  VirtruErrorResponse({
    required this.error,
  });

  factory VirtruErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$VirtruErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VirtruErrorResponseToJson(this);
}

@JsonSerializable()
class VirtruError {
  final String name;
  final String message;

  VirtruError({
    required this.name,
    required this.message,
  });

  factory VirtruError.fromJson(Map<String, dynamic> json) =>
      _$VirtruErrorFromJson(json);

  Map<String, dynamic> toJson() => _$VirtruErrorToJson(this);

  factory VirtruError.fromError(Object error) {
    if (error is DioException) {
      var data = error.response?.data;
      if (data != null) {
        var virtruError = VirtruErrorResponse.fromJson(data);
        return virtruError.error;
      }
      return VirtruError(
        name: error.type.name,
        message: error.response?.statusMessage ?? 'Unknown error',
      );
    }
    return VirtruError(name: "Unknown", message: 'Unknown error');
  }
}
