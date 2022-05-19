import 'package:bottino_fortino/models/constants/globals.dart';
import 'package:bottino_fortino/models/constants/theme_dark.dart';
import 'package:bottino_fortino/models/constants/theme_light.dart';
import 'package:bottino_fortino/modules/bot/models/interfaces/pipeline.interface.dart';
import 'package:bottino_fortino/modules/settings/providers/settings.provider.dart';
import 'package:bottino_fortino/providers/file_storage.provider.dart';
import 'package:bottino_fortino/providers/init.provider.dart';
import 'package:bottino_fortino/providers/pipeline.provider.dart';
import 'package:bottino_fortino/router/app_router.dart';
import 'package:bottino_fortino/utils/provider_logger.utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/localization/l10n.dart';

Future<void> main() async {
  runApp(ProviderScope(
    child: BottinoFortino(),
    observers: [ProviderLoggerUtils()],
  ));
}

class BottinoFortino extends ConsumerWidget {
  BottinoFortino({Key? key}) : super(key: key);

  final _router = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: ref.watch(initProvider).when(
            data: (_) {
              // Autosave bots to file when pipelineProvider changes
              ref.listen<List<Pipeline>>(pipelineProvider,
                  (prevPipelines, newPipelines) {
                ref
                    .watch(fileStorageProvider)
                    .upsertBots(newPipelines.map((e) => e.bot));
              });
              return MaterialApp.router(
                scaffoldMessengerKey: snackbarKey,
                routerDelegate: _router.delegate(),
                routeInformationProvider: _router.routeInfoProvider(),
                routeInformationParser: _router.defaultRouteParser(),
                localizationsDelegates: const [
                  FormBuilderLocalizations.delegate
                ],
                theme: themeLight,
                darkTheme: themeDark,
                themeMode: ref.watch(settingsProvider).themeMode,
              );
            },
            error: (error, st) => Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            loading: () => Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
    );
  }
}
