import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_strings.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/data/models/admin_models.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/shared/widgets/dialogs.dart';

class ApprovalsController extends BaseController {
  final RxList<ApprovalItem> items = <ApprovalItem>[].obs;
  final RxString filterType = 'all'.obs;
  final RxString filterStatus = 'pending'.obs;
  final RxString search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => guard(() async {
        items.assignAll(
          await Get.find<RepositoryProvider>().admin.approvals(
                type: filterType.value,
                status: filterStatus.value,
              ),
        );
        return true;
      }, silent: true);

  bool isSelfMaker(ApprovalItem item) {
    final String? id = Get.find<AuthService>().user?.id;
    return id != null && id == item.madeBy;
  }

  Future<void> approve(ApprovalItem item) async {
    if (isSelfMaker(item)) return showError(AppStrings.approvalRequired);
    final bool? confirmed = await Get.dialog<bool>(
      ConfirmationDialog(
        title: 'Approve ${item.type}?',
        message: 'This will authorize ${item.customerName}’s request for ${item.amount}.',
        confirmLabel: 'Approve',
      ),
    );
    if (confirmed != true) return;
    await guard(() async {
      await Get.find<RepositoryProvider>().admin.approve(
            item.id,
            Get.find<AuthService>().user!.id,
          );
      await load();
      return true;
    }, successMessage: 'Request approved and recorded in the audit log.');
  }

  Future<void> reject(ApprovalItem item) async {
    if (isSelfMaker(item)) return showError(AppStrings.approvalRequired);
    final String? reason = await Get.dialog<String>(
      ReasonDialog(title: 'Reject ${item.type}'),
    );
    if (reason == null) return;
    await guard(() async {
      await Get.find<RepositoryProvider>().admin.reject(
            item.id,
            Get.find<AuthService>().user!.id,
            reason,
          );
      await load();
      return true;
    }, successMessage: 'Request rejected.');
  }

  List<ApprovalItem> get filtered => items.where((item) {
        if (search.value.isEmpty) return true;
        final String q = search.value.toLowerCase();
        return item.customerName.toLowerCase().contains(q) ||
            item.type.toLowerCase().contains(q);
      }).toList();
}
