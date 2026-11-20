import 'package:get/get.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/core/services/receipt_service.dart';
import 'package:nexbanak/core/utils/idempotency.dart';
import 'package:nexbanak/core/utils/validators.dart';
import 'package:nexbanak/data/models/account_model.dart';
import 'package:nexbanak/data/models/banking_models.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/shared/widgets/dialogs.dart';

class MoneyController extends BaseController {
  final RxList<AccountModel> accounts = <AccountModel>[].obs;
  final RxList<BeneficiaryModel> beneficiaries = <BeneficiaryModel>[].obs;
  final RxString mode = 'transfer'.obs;
  final RxBool balanceHidden = false.obs;
  final RxString selectedAccountId = ''.obs;
  final Rxn<BeneficiaryModel> selectedBeneficiary = Rxn<BeneficiaryModel>();
  final RxString amount = ''.obs;
  final RxString note = ''.obs;
  final RxString destinationAccount = ''.obs;
  final RxString otp = ''.obs;
  final RxString beneficiaryName = ''.obs;
  final RxString beneficiaryNumber = ''.obs;
  final RxString beneficiaryBank = 'NEXBANK'.obs;
  final RxString beneficiaryNickname = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => guard(() async {
        final RepositoryProvider repos = Get.find<RepositoryProvider>();
        final List<dynamic> values = await Future.wait<dynamic>(<Future<dynamic>>[
          repos.banking.accounts(),
          repos.banking.beneficiaries(),
        ]);
        accounts.assignAll(values[0] as List<AccountModel>);
        beneficiaries.assignAll(values[1] as List<BeneficiaryModel>);
        if (selectedAccountId.value.isEmpty && accounts.isNotEmpty) {
          selectedAccountId.value = accounts.first.id;
        }
        return true;
      });

  AccountModel? get selectedAccount {
    try {
      return accounts.firstWhere((a) => a.id == selectedAccountId.value);
    } catch (_) {
      return null;
    }
  }

  String? validateAmount(String? value) => Validators.amount(value);

  Future<void> deposit() => _submit(
        () => Get.find<RepositoryProvider>().banking.createDeposit(
              accountId: selectedAccountId.value,
              amount: amount.value,
              note: note.value,
              idempotencyKey: Idempotency.newKey(),
            ),
        'Deposit request submitted for approval.',
      );

  Future<void> withdrawal() => _submit(
        () => Get.find<RepositoryProvider>().banking.createWithdrawal(
              accountId: selectedAccountId.value,
              amount: amount.value,
              note: note.value,
              idempotencyKey: Idempotency.newKey(),
            ),
        'Withdrawal request submitted for approval.',
      );

  Future<void> transfer() => _submit(
        () => Get.find<RepositoryProvider>().banking.createTransfer(
              fromAccountId: selectedAccountId.value,
              toAccountNumber: destinationAccount.value,
              amount: amount.value,
              note: note.value,
              otp: otp.value,
              idempotencyKey: Idempotency.newKey(),
            ),
        'Transfer completed.',
      );

  Future<void> _submit(
    Future<TransactionModel> Function() action,
    String successMessage,
  ) async {
    final TransactionModel? txn = await guard(action, successMessage: successMessage);
    if (txn == null) return;
    await load();
    await Get.dialog<bool>(
      SuccessDialog(
        title: txn.status.toLowerCase() == 'completed'
            ? 'Transaction complete'
            : 'Request received',
        message: txn.status.toLowerCase() == 'completed'
            ? 'The backend confirmed your transaction.'
            : 'Your request is awaiting authorized approval.',
        reference: txn.reference,
      ),
    );
    amount.value = '';
    note.value = '';
    otp.value = '';
  }

  Future<void> addBeneficiary() => guard(
        () async {
          await Get.find<RepositoryProvider>().banking.addBeneficiary(
                name: beneficiaryName.value,
                accountNumber: beneficiaryNumber.value,
                bank: beneficiaryBank.value,
                nickname: beneficiaryNickname.value,
              );
          await load();
          return true;
        },
        successMessage: 'Beneficiary added.',
      );

  Future<void> removeBeneficiary(String id) => guard(
        () async {
          await Get.find<RepositoryProvider>().banking.deleteBeneficiary(id);
          await load();
          return true;
        },
        successMessage: 'Beneficiary removed.',
      );

  void useBeneficiary(BeneficiaryModel beneficiary) {
    selectedBeneficiary.value = beneficiary;
    destinationAccount.value = beneficiary.accountNumber;
  }

  Future<void> printReceipt(TransactionModel txn) =>
      Get.find<ReceiptService>().printReceipt(txn);
}
