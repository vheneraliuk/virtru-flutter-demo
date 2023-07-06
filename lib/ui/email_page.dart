import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:virtru_demo_flutter/bloc/bloc.dart';
import 'package:virtru_demo_flutter/helpers/helpers.dart';
import 'package:virtru_demo_flutter/model/api_models.dart';
import 'package:virtru_demo_flutter/repo/repo.dart';
import 'package:virtru_demo_flutter/ui/ui.dart';

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VirtruAppBar(
      body: BlocBuilder<EmailCubit, EmailState>(
        builder: (context, state) {
          return switch (state) {
            EmailStateSuccess _ => ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Text(
                      state.policy.displayName ?? '(No subject)',
                      style: const TextStyle(
                          fontSize: 26, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                        child: Icon(Icons.account_circle_rounded)),
                    title: Text(
                      state.policy.sentFrom,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      getDateTimeString(state.policy.secureEmailSentAt),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      children: _addChips(state.policy),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Html(
                      style: {
                        "div": Style(
                          fontSize: FontSize.xLarge,
                        ),
                      },
                      data: state.decryptedEmail,
                    ),
                  )
                ],
              ),
            EmailStateError _ => Center(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.error.message,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.error, fontSize: 26),
                ),
              )),
            EmailStateInitial _ => const Center(
                child: CircularProgressIndicator(),
              )
          };
        },
      ),
      title: 'Email',
    );
  }

  static go(BuildContext context,
      {required String policyId, required String metaDataKey}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => EmailCubit(
            acmRepo: AcmRepository(userRepo: UserRepository()),
            policyId: policyId,
            metadataKeyBase64: metaDataKey,
          ),
          child: const EmailPage(),
        ),
      ),
    );
  }

  List<Widget> _addChips(ExtendedPolicy policy) {
    final List<Widget> chips = List.empty(growable: true);
    chips.add(const Chip(label: Text("Encrypted")));
    if (!policy.simplePolicy.authorizations.contains('forward')) {
      chips.add(const Chip(label: Text("Disable Forwarding")));
    }
    if (policy.simplePolicy.activeEnd != null) {
      chips.add(
        Chip(
            label: Text(
                "Expires on ${getDateTimeString(policy.simplePolicy.activeEnd!)}")),
      );
    }
    return chips;
  }
}
