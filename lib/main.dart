import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:logger/logger.dart';
import 'package:wasel/core/language/language_cubit.dart';
import 'package:wasel/core/theme/theme_cubit.dart';
import 'package:wasel/core/utils/bloc_observer.dart';
import 'package:wasel/core/utils/local_storage.dart';
import 'package:wasel/core/utils/service_locator.dart';
import 'package:wasel/features/no_internet/presentation/manager/connection_cubit.dart';
import 'package:wasel/my_app.dart';

// SharedReservationModel? bookingModel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  final logger = Logger();

  try {
    // Initialize service locator with logger
    await setupLocator(logger: logger);

    // Initialize BLoC observer
    Bloc.observer = AppBlocObserver(logger: logger);

    // Initialize local storage
    final localStorage = await LocalStorage.init(logger: logger);

    // Initialize flutter_translate with explicit basePath
    var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en',
      supportedLocales: ['en', 'ar'],
      basePath: 'assets/i18n', // Explicitly specify the i18n folder
    );

    // Get initial theme brightness (saved or device)
    final initialBrightness = await ThemeCubit.getInitialBrightness(
      localStorage,
    );

    // Get initial locale (saved or default)
    final initialLocale = await LanguageCubit.getInitialLocale(localStorage);

    // Run the app
    runApp(
      LocalizedApp(
        delegate,
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => ConnectionCubit()),
            BlocProvider(
              create: (_) => ThemeCubit(
                localStorage: localStorage,
                initialBrightness: initialBrightness,
              ),
            ),
            BlocProvider(
              create: (_) => LanguageCubit(
                localStorage: localStorage,
                initialLocale: initialLocale,
              ),
            ),
          ],
          child: MyApp(localStorage: localStorage),
        ),
      ),
    );
  } catch (e, stackTrace) {
    logger.e(
      'Application initialization failed',
      error: e,
      stackTrace: stackTrace,
    );
  }
}
