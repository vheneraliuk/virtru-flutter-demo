import 'package:equatable/equatable.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';

class RcaLink extends Equatable {
  final String version;
  final String payloadUri;
  final String contractUri;
  final String algorithm;
  final String? wrappedKey;

  static RcaLink? fromString(String url) {
    return fromUri(Uri.parse(url));
  }

  static RcaLink? fromUri(Uri uri) {
    Uri newUri = _replaceFragmentByQueryParams(uri);
    var params = newUri.queryParameters;
    var version = params['v'];
    if (version == null) return null;
    var payloadUri = params['wu'];
    if (payloadUri == null) return null;
    var contractUri = params['pu'];
    if (contractUri == null) return null;
    var algorithm = params['al'];
    if (algorithm == null) return null;
    var wrappedKey = params['wk'];
    return RcaLink._(
      version: version,
      wrappedKey: wrappedKey,
      payloadUri: payloadUri,
      contractUri: contractUri,
      algorithm: algorithm,
    );
  }

  const RcaLink._({
    required this.version,
    required this.wrappedKey,
    required this.payloadUri,
    required this.contractUri,
    required this.algorithm,
  });

  String? getPolicyId() {
    return policyIdRegExp.stringMatch(contractUri);
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
        wrappedKey,
        payloadUri,
        contractUri,
        algorithm,
      ];
}
