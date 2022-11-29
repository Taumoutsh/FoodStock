import 'package:logging/logging.dart';

class ApplicationStartMonitor {
  final log = Logger('ApplicationStartService');

  bool isInitialRefreshComplete = false;

  static final ApplicationStartMonitor _instance = ApplicationStartMonitor._internal();

  factory ApplicationStartMonitor() {
    return _instance;
  }

  ApplicationStartMonitor._internal();
}