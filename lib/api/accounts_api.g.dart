// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      userId: json['userId'] as String,
      platform: json['platform'] as String,
      activationMethod: json['activationMethod'] as String,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'platform': instance.platform,
      'activationMethod': instance.activationMethod,
    };

CodeRequest _$CodeRequestFromJson(Map<String, dynamic> json) => CodeRequest(
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$CodeRequestToJson(CodeRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };

SendCodeRequest _$SendCodeRequestFromJson(Map<String, dynamic> json) =>
    SendCodeRequest(
      userId: json['userId'] as String,
      code: json['code'] as String,
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$SendCodeRequestToJson(SendCodeRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'code': instance.code,
      'sessionId': instance.sessionId,
    };

SessionId _$SessionIdFromJson(Map<String, dynamic> json) => SessionId(
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$SessionIdToJson(SessionId instance) => <String, dynamic>{
      'sessionId': instance.sessionId,
    };

EmailLoginRequest _$EmailLoginRequestFromJson(Map<String, dynamic> json) =>
    EmailLoginRequest(
      emailAddress: json['emailAddress'] as String,
      stayLoggedIn: json['stayLoggedIn'] as bool,
    );

Map<String, dynamic> _$EmailLoginRequestToJson(EmailLoginRequest instance) =>
    <String, dynamic>{
      'emailAddress': instance.emailAddress,
      'stayLoggedIn': instance.stayLoggedIn,
    };

AppIdBundle _$AppIdBundleFromJson(Map<String, dynamic> json) => AppIdBundle(
      userId: json['userId'] as String,
      appId: json['appId'] as String,
      state: json['state'] as String,
      platform: json['platform'] as String,
    );

Map<String, dynamic> _$AppIdBundleToJson(AppIdBundle instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'appId': instance.appId,
      'state': instance.state,
      'platform': instance.platform,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AccountsClient implements AccountsClient {
  _AccountsClient(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://api.virtru.com/accounts';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AppIdBundle> register(RegisterRequest request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AppIdBundle>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/register',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = AppIdBundle.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SessionId> requestCode(CodeRequest request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Origin': 'https://sdk.virtru.com'};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<SessionId>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/code-login',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = SessionId.fromJson(_result.data!);
    return value;
  }

  @override
  Future<AppIdBundle> sendCode(SendCodeRequest request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'Origin': 'https://sdk.virtru.com'};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AppIdBundle>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/code-activation',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = AppIdBundle.fromJson(_result.data!);
    return value;
  }

  @override
  Future<void> emailLogin(EmailLoginRequest request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    await _dio.fetch<void>(_setStreamType<void>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/email-login',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        ))));
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
