import 'package:get/get.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/core/utils/validators.dart';
import 'package:nexbanak/data/models/banking_models.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';

class ServicesController extends BaseController {
  final RxList<LoanModel> loans = <LoanModel>[].obs;
  final RxList<CardModel> cards = <CardModel>[].obs;
  final RxList<SavingsGoalModel> goals = <SavingsGoalModel>[].obs;
  final RxList<FixedDepositModel> fixedDeposits = <FixedDepositModel>[].obs;

  final RxString loanType = 'Personal loan'.obs;
  final RxString loanAmount = ''.obs;
  final RxInt loanTerm = 12.obs;
  final RxString repayAmount = ''.obs;
  final RxString goalName = ''.obs;
  final RxString goalTarget = ''.obs;
  final RxString goalDeadline = ''.obs;
  final RxString fdAmount = ''.obs;
  final RxInt fdTerm = 12.obs;

  final RxString selectedAccountId = 'acc_001'.obs;
  final RxString billerName = 'DESCO Electricity'.obs;
  final RxString customerCode = ''.obs;
  final RxString billAmount = ''.obs;
  final RxString billNote = ''.obs;

  final RxString operatorName = 'Grameenphone'.obs;
  final RxString mobileNumber = ''.obs;
  final RxString topupAmount = ''.obs;

  final RxString mfsProvider = 'bKash'.obs;
  final RxString mfsMobile = ''.obs;
  final RxString mfsAmount = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => guard(() async {
        final RepositoryProvider repos = Get.find<RepositoryProvider>();
        final List<dynamic> values = await Future.wait<dynamic>(<Future<dynamic>>[
          repos.banking.loans(),
          repos.banking.cards(),
          repos.banking.savingsGoals(),
          repos.banking.fixedDeposits(),
        ]);
        loans.assignAll(values[0] as List<LoanModel>);
        cards.assignAll(values[1] as List<CardModel>);
        goals.assignAll(values[2] as List<SavingsGoalModel>);
        fixedDeposits.assignAll(values[3] as List<FixedDepositModel>);
        return true;
      });

  Future<void> payBill() => guard(
        () async {
          final String? error = Validators.amount(billAmount.value);
          if (error != null) {
            showError(error);
            return false;
          }
          if (customerCode.value.trim().isEmpty) {
            showError('Enter account/customer code');
            return false;
          }
          await Get.find<RepositoryProvider>().banking.createBillPayment(
                accountId: selectedAccountId.value,
                billerName: billerName.value,
                customerCode: customerCode.value,
                amount: billAmount.value,
                note: billNote.value,
              );
          await load();
          return true;
        },
        successMessage: 'Bill paid successfully!',
      );

  Future<void> topupMobile() => guard(
        () async {
          final String? error = Validators.amount(topupAmount.value);
          if (error != null) {
            showError(error);
            return false;
          }
          if (mobileNumber.value.trim().length < 10) {
            showError('Enter a valid mobile number');
            return false;
          }
          await Get.find<RepositoryProvider>().banking.createMobileTopup(
                accountId: selectedAccountId.value,
                operatorName: operatorName.value,
                mobileNumber: mobileNumber.value,
                amount: topupAmount.value,
              );
          await load();
          return true;
        },
        successMessage: 'Mobile top-up successful!',
      );

  Future<void> transferMfs() => guard(
        () async {
          final String? error = Validators.amount(mfsAmount.value);
          if (error != null) {
            showError(error);
            return false;
          }
          if (mfsMobile.value.trim().length < 10) {
            showError('Enter a valid recipient mobile number');
            return false;
          }
          await Get.find<RepositoryProvider>().banking.createMfsTransfer(
                accountId: selectedAccountId.value,
                mfsProvider: mfsProvider.value,
                recipientMobile: mfsMobile.value,
                amount: mfsAmount.value,
              );
          await load();
          return true;
        },
        successMessage: 'MFS Transfer completed!',
      );

  Future<void> applyLoan() => guard(
        () async {
          final num? parsed = num.tryParse(loanAmount.value);
          if (parsed == null || parsed <= 0) {
            throw ArgumentError('Enter a valid loan amount');
          }
          await Get.find<RepositoryProvider>().banking.applyLoan(
                type: loanType.value,
                amount: loanAmount.value,
                termMonths: loanTerm.value,
              );
          await load();
          return true;
        },
        successMessage: 'Loan application submitted for review.',
      );

  Future<void> repayLoan(String loanId) {
    final String? error = Validators.amount(repayAmount.value);
    if (error != null) {
      showError(error);
      return Future<void>.value();
    }
    return guard(() async {
      await Get.find<RepositoryProvider>().banking.repayLoan(loanId, repayAmount.value);
      await load();
      return true;
    }, successMessage: 'Repayment recorded.');
  }

  Future<void> setCardStatus(String id, String status) => guard(
        () async {
          await Get.find<RepositoryProvider>().banking.setCardStatus(id, status);
          await load();
          return true;
        },
        successMessage: 'Card status updated.',
      );

  Future<void> addGoal() => guard(
        () async {
          await Get.find<RepositoryProvider>().banking.addSavingsGoal(
                name: goalName.value,
                target: goalTarget.value,
                deadline: goalDeadline.value,
              );
          await load();
          return true;
        },
        successMessage: 'Savings goal created.',
      );

  Future<void> openFixedDeposit() => guard(
        () async {
          await Get.find<RepositoryProvider>().banking.openFixedDeposit(
                amount: fdAmount.value,
                termMonths: fdTerm.value,
              );
          await load();
          return true;
        },
        successMessage: 'Fixed deposit opened.',
      );
}
