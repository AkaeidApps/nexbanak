import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/services/storage_service.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/models/dashboard_models.dart';
import 'package:nexbanak/data/models/notification_model.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/shared/widgets/app_shell.dart';

class CustomerHomeController extends BaseController {
  final Rxn<CustomerStats> stats = Rxn<CustomerStats>();
  final RxList<AccountModel> accounts = <AccountModel>[].obs;
  final RxList<TransactionModel> recent = <TransactionModel>[].obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool balanceHidden = false.obs;

  @override
  void onInit() {
    super.onInit();
    balanceHidden.value = StorageService.instance.getBool(
      StorageService.balanceHiddenKey,
    );
    load();
  }

  Future<void> load() => guard(() async {
        final RepositoryProvider repos = Get.find<RepositoryProvider>();
        final List<dynamic> values = await Future.wait<dynamic>(<Future<dynamic>>[
          repos.banking.customerStats(),
          repos.banking.accounts(),
          repos.banking.transactions(limit: 6),
          repos.banking.notifications(),
        ]);
        stats.value = values[0] as CustomerStats;
        accounts.assignAll(values[1] as List<AccountModel>);
        recent.assignAll(values[2] as List<TransactionModel>);
        notifications.assignAll(values[3] as List<NotificationModel>);
        return true;
      });

  Future<void> toggleBalance() async {
    balanceHidden.value = !balanceHidden.value;
    await StorageService.instance.setBool(
      StorageService.balanceHiddenKey,
      balanceHidden.value,
    );
  }

  int get unreadCount =>
      notifications.where((n) => !n.isRead).length;

  String get firstName {
    final String? name = Get.find<AuthService>().user?.name;
    if (name == null || name.isEmpty) return 'there';
    return name.split(' ').first;
  }

  void openNotifications() => Get.toNamed(Routes.notifications);
  void openTransfer() => Get.find<ShellController>(tag: 'customer').changeTab(2);
  void openTransactions() => Get.find<ShellController>(tag: 'customer').changeTab(3);
  void openAccounts() => Get.find<ShellController>(tag: 'customer').changeTab(1);
  void openDeposit() => Get.toNamed(Routes.deposit);
  void openWithdrawal() => Get.toNamed(Routes.withdrawal);
  void openLoans() => Get.toNamed(Routes.loans);
  void openCards() => Get.toNamed(Routes.cards);
  void openStatement() => Get.toNamed(Routes.customerTransactions);
}
