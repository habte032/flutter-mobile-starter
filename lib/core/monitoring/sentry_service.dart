import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../config/app_config.dart';

@singleton
class SentryService {
  final AppConfig _appConfig;

  SentryService(this._appConfig);

  Future<void> initialize() async {
    if (_appConfig.sentryDsn.isEmpty) return;

    await SentryFlutter.init(
      (options) {
        options.dsn = _appConfig.sentryDsn;
        options.environment = _appConfig.sentryEnvironment;
        options.debug = kDebugMode;
        options.tracesSampleRate = _appConfig.isDevelopment ? 1.0 : 0.1;
        options.beforeSend = (event, hint) {
          if (_appConfig.isDevelopment) {
            debugPrint('Sentry Event: ${event.toString()}');
          }
          return event;
        };
      },
    );
  }

  void captureException(dynamic exception, {dynamic stackTrace, String? tag}) {
    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        if (tag != null) scope.setTag('error_type', tag);
      },
    );
  }

  void captureMessage(String message, {SentryLevel level = SentryLevel.info}) {
    Sentry.captureMessage(message, level: level);
  }

  void addBreadcrumb(String message, {String? category, Map<String, dynamic>? data}) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        data: data,
        timestamp: DateTime.now(),
      ),
    );
  }
}