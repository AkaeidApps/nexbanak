import 'package:get/get.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/core/utils/validators.dart';
import 'package:nexbanak/data/models/admin_models.dart';
import 'package:nexbanak/data/models/notification_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';

class SystemController extends BaseController {
  final RxList<AuditEvent> audit = <AuditEvent>[].obs;
  final RxList<Map<String, dynamic>> reportRows = <Map<String, dynamic>>[].obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxMap<String, dynamic> settings = <String, dynamic>{}.obs;
  final RxString auditSearch = ''.obs;
  final RxString reportType = 'monthly'.obs;
  final RxString sessionTimeout = '15'.obs;
  final RxString dailyTransferLimit = '10000.00'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() => guard(() async {
        final admin = Get.find<RepositoryProvider>().admin;
        final List<dynamic> values = await Future.wait<dynamic>(<Future<dynamic>>[
          admin.auditLogs(search: auditSearch.value),
          admin.report(reportType.value),
          admin.settings(),
          admin.notifications(),
        ]);
        audit.assignAll(values[0] as List<AuditEvent>);
        reportRows.assignAll(values[1] as List<Map<String, dynamic>>);
        settings.assignAll(values[2] as Map<String, dynamic>);
        notifications.assignAll(values[3] as List<NotificationModel>);
        sessionTimeout.value =
            (settings['sessionTimeoutMinutes'] ?? 15).toString();
        dailyTransferLimit.value =
            (settings['dailyTransferLimit'] ?? '10000.00').toString();
        return true;
      }, silent: true);

  Future<void> loadReport() => guard(() async {
        reportRows.assignAll(
          await Get.find<RepositoryProvider>().admin.report(reportType.value),
        );
        return true;
      });

  Future<void> saveSettings() => guard(() async {
        final int? timeout = int.tryParse(sessionTimeout.value);
        if (timeout == null || timeout < 5 || timeout > 120) {
          throw StateError('Session timeout must be between 5 and 120 minutes');
        }
        final String? amountError = Validators.amount(dailyTransferLimit.value);
        if (amountError != null) throw StateError(amountError);
        await Get.find<RepositoryProvider>().admin.saveSettings(<String, dynamic>{
          'sessionTimeoutMinutes': timeout,
          'dailyTransferLimit': dailyTransferLimit.value,
        });
        return true;
      }, successMessage: 'System settings saved.');
}
