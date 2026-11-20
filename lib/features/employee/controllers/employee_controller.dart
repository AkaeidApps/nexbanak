import 'package:get/get.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/data/models/admin_models.dart';
import 'package:nexbanak/data/models/transaction_model.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/shared/widgets/dialogs.dart';

class EmployeeController extends BaseController {
  final RxList<PersonRecord> customers = <PersonRecord>[].obs;
  final RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  final RxList<KycRecord> kyc = <KycRecord>[].obs;
  final RxList<AuditEvent> workHistory = <AuditEvent>[].obs;
  final RxString search = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => guard(() async {
        final admin = Get.find<RepositoryProvider>().admin;
        final List<dynamic> values = await Future.wait<dynamic>(<Future<dynamic>>[
          admin.customers(search: search.value),
          Get.find<RepositoryProvider>().banking.transactions(limit: 30),
          admin.kycRecords(status: 'pending'),
          admin.auditLogs(),
        ]);
        customers.assignAll(values[0] as List<PersonRecord>);
        transactions.assignAll(values[1] as List<TransactionModel>);
        kyc.assignAll(values[2] as List<KycRecord>);
        workHistory.assignAll(values[3] as List<AuditEvent>);
        return true;
      }, silent: true);

  void onSearch(String value) {
    search.value = value;
    load();
  }

  void showCustomer(PersonRecord person) {
    Get.dialog<bool>(
      ConfirmationDialog(
        title: person.name,
        message: 'Customer ID: ${person.id}\n${person.email}\n${person.phone}\nKYC: ${person.kyc}\nStatus: ${person.status}',
        confirmLabel: 'Close',
      ),
    );
  }
}
