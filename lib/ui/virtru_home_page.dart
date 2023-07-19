import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/model/model.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';
import 'package:virtru_demo_flutter/ui/ui.dart';

class VirtruHomePage extends StatefulWidget {
  const VirtruHomePage({super.key});

  @override
  State<VirtruHomePage> createState() => _VirtruHomePageState();
}

class _VirtruHomePageState extends State<VirtruHomePage>
    with AfterLayoutMixin<VirtruHomePage> {
  final _appLinks = AppLinks();

  void _parseInitialAppUri(Uri? uri) {
    if (uri == null) return;
    var link = SecureReaderLink.fromUri(uri);
    if (link == null) return;
    debugPrint('Received URI: $uri');
    debugPrint('MetaData Version: ${link.version}');
    debugPrint('MetaData Url: ${link.metadataUrl}');
    debugPrint('MetaData Key: ${link.metadataKey}');
    debugPrint('MetaData Iv: ${link.metadataIv}');
    debugPrint('Attachment Tdo Id: ${link.attachmentTdoId}');
    debugPrint('Sender: ${link.sender}');
    debugPrint('Policy Uuid: ${link.policyUuid}');
    debugPrint('Campaign Id: ${link.campaignId}');
    debugPrint('Template Id: ${link.templateId}');

    EmailPage.go(
      context,
      policyId: link.getPolicyId(),
      metaDataKey: link.metadataKey,
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    if (kIsWeb) {
      _appLinks.getInitialAppLink().then((uri) => _parseInitialAppUri(uri));
    } else {
      _appLinks.allUriLinkStream.listen((uri) => _parseInitialAppUri(uri));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => AccountsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(
              userRepo: RepositoryProvider.of(context),
            ),
          ),
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(
              userRepo: RepositoryProvider.of(context),
              accountRepo: RepositoryProvider.of(context),
            ),
          ),
        ],
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return switch (state) {
              AuthStateAuthenticated _ => RepositoryProvider(
                  create: (context) =>
                      AcmRepository(userRepo: RepositoryProvider.of(context)),
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                          create: (context) =>
                              EncryptCubit(RepositoryProvider.of(context))),
                      BlocProvider(
                          create: (context) => DecryptCubit(
                                RepositoryProvider.of(context),
                                RepositoryProvider.of(context),
                              )),
                      BlocProvider(
                        create: (context) => SentEmailsCubit(
                            acmRepo: RepositoryProvider.of(context)),
                      ),
                      BlocProvider(
                        create: (context) => ReceivedEmailsCubit(
                            acmRepo: RepositoryProvider.of(context)),
                      ),
                      BlocProvider(
                        create: (context) => SentFilesCubit(
                            acmRepo: RepositoryProvider.of(context)),
                      ),
                      BlocProvider(
                        create: (context) => ReceivedFilesCubit(
                            acmRepo: RepositoryProvider.of(context)),
                      ),
                    ],
                    child: const MainPage(),
                  ),
                ),
              AuthStateUnauthenticated _ => const LoginPage(),
              AuthStateUnknown _ => const VirtruAppBar(
                  title: 'Flutter Demo',
                  body: Center(
                    child: CircularProgressIndicator(),
                  )),
            };
          },
        ),
      ),
    );
  }
}
