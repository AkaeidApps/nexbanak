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
