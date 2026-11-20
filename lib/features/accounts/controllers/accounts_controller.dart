import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/core/services/storage_service.dart';

class AccountsController extends BaseController {
  final RxList<AccountModel> accounts = <AccountModel>[].obs;
  final RxBool balanceHidden = false.obs;
  final RxString requestType = 'savings'.obs;
  final RxString requestName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    balanceHidden.value =
        StorageService.instance.getBool(StorageService.balanceHiddenKey);
    load();
  }

  Future<void> load() => guard(() async {
        accounts.assignAll(await Get.find<RepositoryProvider>().banking.accounts());
        return true;
      });

  void openDetail(AccountModel account) =>
      Get.toNamed(Routes.accountDetail, arguments: account.id);

  AccountModel? findById(String id) {
    try {
      return accounts.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> submitAccountRequest() => guard(
        () async {
          await Get.find<RepositoryProvider>().banking.requestAccount(
                requestType.value,
                requestName.value,
              );
          await load();
          return true;
        },
        successMessage: 'Account request submitted for review.',
      );
}
