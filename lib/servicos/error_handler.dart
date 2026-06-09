import 'dart:developer' as developer;

class ErrorHandler {
  // Log simples para desenvolvimento; substitua por Sentry/Crashlytics em produção.
  static void log(String message) => developer.log(message, name: 'ErrorHandler');

  static void logError(String message, Object error, StackTrace? st) {
    developer.log(message, error: error, stackTrace: st, name: 'ErrorHandler');
    // aqui você pode enviar para serviço de crash/report
  }
}
