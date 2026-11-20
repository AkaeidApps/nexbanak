import 'package:get/get.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/models/banking_models.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';

class AdminOperationsController extends BaseController {
  final RxList<AccountModel> accounts = <AccountModel>[].obs;
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxList<LoanModel> loans = <LoanModel>[].obs;
  final RxList<CardModel> cards = <CardModel>[].obs;
  final RxString search = ''.obs;
  final RxString type = 'all'.obs;
  final RxString status = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => guard(() async {
        final banking = Get.find<RepositoryProvider>().banking;
        final List<dynamic> values = await Future.wait<dynamic>(<Future<dynamic>>[
          banking.accounts(),
          banking.transactions(),
          banking.loans(),
          banking.cards(),
        ]);
        accounts.assignAll(values[0] as List<AccountModel>);
        transactions.assignAll(values[1] as List<TransactionModel>);
        loans.assignAll(values[2] as List<LoanModel>);
        cards.assignAll(values[3] as List<CardModel>);
        return true;
      }, silent: true);

  List<TransactionModel> get filteredTransactions => transactions.where((t) {
        if (type.value != 'all' && t.type != type.value) return false;
        if (status.value != 'all' && t.status != status.value) return false;
        if (search.value.isEmpty) return true;
        final String q = search.value.toLowerCase();
        return t.title.toLowerCase().contains(q) ||
            t.reference.toLowerCase().contains(q);
      }).toList();

  List<AccountModel> get filteredAccounts => accounts.where((a) {
        if (status.value != 'all' && a.status != status.value) return false;
        if (search.value.isEmpty) return true;
        final String q = search.value.toLowerCase();
        return a.name.toLowerCase().contains(q) ||
            a.accountNumber.contains(q);
      }).toList();
}
