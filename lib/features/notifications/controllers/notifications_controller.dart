import 'package:get/get.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/data/models/notification_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';

class NotificationsController extends BaseController {
  final RxList<NotificationModel> items = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => guard(() async {
        items.assignAll(await Get.find<RepositoryProvider>().banking.notifications());
        return true;
      });

  Future<void> markRead(String id) => guard(() async {
        await Get.find<RepositoryProvider>().banking.markNotificationRead(id);
        await load();
        return true;
      }, silent: true);

  Future<void> markAllRead() => guard(() async {
        await Get.find<RepositoryProvider>().banking.markAllNotificationsRead();
        await load();
        return true;
      }, successMessage: 'All notifications marked as read.');

  int get unreadCount => items.where((n) => !n.isRead).length;
}
