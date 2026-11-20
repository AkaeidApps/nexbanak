import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/core/services/receipt_service.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';

class TransactionsController extends BaseController {
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxString search = ''.obs;
  final RxString type = 'all'.obs;
  final RxString status = 'all'.obs;
  final RxString accountId = ''.obs;
  final Rxn<TransactionModel> selected = Rxn<TransactionModel>();
  final RxBool statementMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => guard(() async {
        transactions.assignAll(
          await Get.find<RepositoryProvider>().banking.transactions(
                accountId: accountId.value.isEmpty ? null : accountId.value,
                type: type.value,
                status: status.value,
                search: search.value,
              ),
        );
        return true;
      }, silent: true);

  void setFilter({String? type, String? status}) {
    if (type != null) this.type.value = type;
    if (status != null) this.status.value = status;
    load();
  }

  void onSearchChanged(String value) {
    search.value = value;
    load();
  }

  void openDetail(TransactionModel txn) {
    selected.value = txn;
    Get.toNamed(Routes.transactionDetail, arguments: txn.id);
  }

  Future<TransactionModel?> detail(String id) => guard(
        () => Get.find<RepositoryProvider>().banking.transaction(id),
        silent: true,
      );

  Future<void> printReceipt(TransactionModel txn) =>
      Get.find<ReceiptService>().printReceipt(txn);
}
