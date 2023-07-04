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
}
