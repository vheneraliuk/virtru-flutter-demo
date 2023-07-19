import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';

class SecureReaderLink extends Equatable {
  final String version;
  final String metadataUrl;
  final String metadataKey;
  final String? sender;
  final String? policyUuid;
  final String? campaignId;
  final String? templateId;
  final String? metadataIv;
  final String? attachmentTdoId;

  static SecureReaderLink? fromUri(Uri uri) {
    Uri newUri = _replaceFragmentByQueryParams(uri);
    var params = newUri.queryParameters;
    var version = params['v'];
    if (version == null) return null;
    var metadataUrl = params['d'];
    if (metadataUrl == null) return null;
    var metaDataKey = params['dk'];
    if (metaDataKey == null) return null;
    var metaDataIv = params['di'];
    var sender = params['s'];
    var policyUuid = params['p'];
    var campaignId = params['c'];
    var templateId = params['t'];
    var attachmentTdoId = params['a'];
    return SecureReaderLink._(
      version: version,
      metadataUrl: metadataUrl,
      sender: sender,
      policyUuid: policyUuid,
      campaignId: campaignId,
      templateId: templateId,
      metadataKey: metaDataKey,
      metadataIv: metaDataIv,
      attachmentTdoId: attachmentTdoId,
    );
  }

  SecureReaderLink._({
    required this.version,
    required this.metadataUrl,
    required this.sender,
    required this.policyUuid,
    required this.campaignId,
    required this.templateId,
    required this.metadataKey,
    required this.metadataIv,
    required this.attachmentTdoId,
  });

  String getPolicyId() {
    if (policyUuid != null) return policyUuid!;
    return policyIdRegExp.stringMatch(metadataUrl) ?? "";
  }

  static Uri _replaceFragmentByQueryParams(Uri uri) {
    Uri newUri = uri;

    if (uri.hasFragment) {
      var fragment = uri.fragment;
      var uriWithoutFragment = uri.removeFragment();
      var hasParams = uriWithoutFragment.queryParameters.isNotEmpty;
      newUri =
          Uri.parse('$uriWithoutFragment${hasParams ? '&' : '?'}$fragment');
    }

    return newUri;
  }

  @override
  List<Object?> get props => [
        version,
        metadataUrl,
        sender,
        policyUuid,
        campaignId,
        templateId,
        metadataKey,
        metadataIv,
        attachmentTdoId,
      ];
}
