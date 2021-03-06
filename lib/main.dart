import 'package:F4Lab/providers/package_info.dart';
import 'package:F4Lab/providers/theme.dart';
import 'package:F4Lab/providers/user.dart';
import 'package:F4Lab/ui/config/config_page.dart';
import 'package:F4Lab/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    FlutterError.onError = MyApp.errorHandler;
  }

  static void errorHandler(FlutterErrorDetails details,
      {bool forceReport = false}) {
    final SentryClient sentry = new SentryClient(
        dsn: "https://a49f4f9002e04a81959c51f769a4e013@sentry.io/1406491");
    sentry.captureException(
      exception: details.exception,
      stackTrace: details.stack,
    );
  }

  List<SingleChildCloneableWidget> _buildProviders(BuildContext context) {
    return [
      ChangeNotifierProvider(builder: (_) => ThemeProvider()),
      ChangeNotifierProvider(builder: (_) => UserProvider()),
      ChangeNotifierProvider(builder: (_) => PackageInfoProvider()),
    ];
  }

  Map<String, WidgetBuilder> _buildRoutes() => {
        '/': (_) => HomePage(),
        '/config': (_) => ConfigPage(),
      };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: _buildProviders(context),
        child: Consumer<ThemeProvider>(builder: (context, theme, _) {
          return MaterialApp(
              title: 'GitLab',
              initialRoute: '/',
              theme: theme.currentTheme,
              routes: _buildRoutes());
        }));
  }
}
