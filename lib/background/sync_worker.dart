import 'package:workmanager/workmanager.dart';
import '../core/constants/app_constants.dart';
class SyncWorker {
  static void register() {
    Workmanager().initialize(callbackDispatcher);
    Workmanager().registerPeriodicTask(
      AppConstants.syncTaskUniqueName,
      AppConstants.syncTaskName,
      frequency: const Duration(hours: 6),
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((taskName, inputData) async {
      return Future.value(true);
    });
  }
}
