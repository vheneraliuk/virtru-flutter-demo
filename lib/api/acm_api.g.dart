// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acm_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoliciesSearchResponse _$PoliciesSearchResponseFromJson(
        Map<String, dynamic> json) =>
    PoliciesSearchResponse(
      totalRows: json['total_rows'] as int,
      bookmark: json['bookmark'] as int?,
      rows: (json['rows'] as List<dynamic>)
          .map((e) => PolicyResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PoliciesSearchResponseToJson(
        PoliciesSearchResponse instance) =>
    <String, dynamic>{
      'total_rows': instance.totalRows,
      'bookmark': instance.bookmark,
      'rows': instance.rows,
    };

PolicyResponse _$PolicyResponseFromJson(Map<String, dynamic> json) =>
    PolicyResponse(
      id: json['id'] as String,
      fields: Policy.fromJson(json['fields'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PolicyResponseToJson(PolicyResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fields': instance.fields,
    };

Policy _$PolicyFromJson(Map<String, dynamic> json) => Policy(
      json['id'] as String,
      DateTime.parse(json['dateSent'] as String),
      json['creator'] as String?,
      json['owner'] as String,
      json['from'] as String,
      json['name'] as String?,
      json['filename'] as String?,
      json['fileExtension'] as String?,
      json['subject'] as String?,
      json['attachmentCount'] as int,
      json['orgId'] as String,
      json['wasForwarded'] as bool,
      (json['to'] as List<dynamic>).map((e) => e as String).toList(),
      json['status'] as String,
      json['type'] as String,
      json['forwardCount'] as int,
      json['recipientCount'] as int,
      json['accessPercent'] as String,
      (json['is'] as List<dynamic>).map((e) => e as String).toList(),
      (json['was'] as List<dynamic>).map((e) => e as String).toList(),
      (json['has'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PolicyToJson(Policy instance) => <String, dynamic>{
      'id': instance.id,
      'dateSent': instance.dateSent.toIso8601String(),
      'creator': instance.creator,
      'owner': instance.owner,
      'from': instance.from,
      'name': instance.name,
      'filename': instance.filename,
      'fileExtension': instance.fileExtension,
      'subject': instance.subject,
      'attachmentCount': instance.attachmentCount,
      'orgId': instance.orgId,
      'wasForwarded': instance.wasForwarded,
      'to': instance.to,
      'status': instance.status,
      'type': instance.type,
      'forwardCount': instance.forwardCount,
      'recipientCount': instance.recipientCount,
      'accessPercent': instance.accessPercent,
      'is': instance.statuses,
      'was': instance.was,
      'has': instance.has,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AcmClient extends AcmClient {
  _AcmClient(
    this._dio,
    User user, {
    this.baseUrl,
  }) : super(user) {
    baseUrl ??= 'https://api.virtru.com/acm';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<PoliciesSearchResponse> _getPolicies(
    String query,
    int bookmark, {
    String sort = '["-dateSent.raw<string>"]',
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'q': query,
      r'bookmark': bookmark,
      r'sort': sort,
    };
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PoliciesSearchResponse>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/policies/search',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = PoliciesSearchResponse.fromJson(_result.data!);
    return value;
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
