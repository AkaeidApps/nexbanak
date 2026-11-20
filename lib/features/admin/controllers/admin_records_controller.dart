import 'package:get/get.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/data/models/admin_models.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';
import 'package:nexbanak/shared/widgets/dialogs.dart';

/// Backs the Customers, Employees, Branches and KYC management screens.
class AdminRecordsController extends BaseController {
  AdminRecordsController(this.kind);

  final String kind;
  final RxList<PersonRecord> people = <PersonRecord>[].obs;
  final RxList<BranchRecord> branches = <BranchRecord>[].obs;
  final RxList<KycRecord> kyc = <KycRecord>[].obs;
  final RxString search = ''.obs;
  final RxString status = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => guard(() async {
        final repo = Get.find<RepositoryProvider>().admin;
        switch (kind) {
          case 'customers':
            people.assignAll(await repo.customers(search: search.value, status: status.value));
          case 'employees':
            people.assignAll(await repo.employees(search: search.value, status: status.value));
          case 'branches':
            branches.assignAll(await repo.branches(search: search.value));
          case 'kyc':
            kyc.assignAll(await repo.kycRecords(status: status.value));
        }
        return true;
      }, silent: true);

  void onSearch(String value) {
    search.value = value;
    load();
  }

  void onStatus(String value) {
    status.value = value;
    load();
  }

  void showPerson(PersonRecord person) {
    Get.dialog<bool>(
      ConfirmationDialog(
        title: person.name,
        message: '${person.email}\n${person.phone}\nBranch: ${person.branch}\nKYC: ${person.kyc}\nStatus: ${person.status}',
        confirmLabel: 'Close',
      ),
    );
  }

  Future<void> reviewKyc(KycRecord record, String decision) async {
    final bool? confirmed = await Get.dialog<bool>(
      ConfirmationDialog(
        title: '${decision == 'verified' ? 'Verify' : 'Reject'} KYC?',
        message: '${record.customerName} — ${record.documentType}',
        confirmLabel: decision == 'verified' ? 'Verify' : 'Reject',
      ),
    );
    if (confirmed != true) return;
    await guard(() async {
      await Get.find<RepositoryProvider>().admin.reviewKyc(
            record.id,
            decision,
            Get.find<AuthService>().user?.id ?? 'system',
          );
      await load();
      return true;
    }, successMessage: 'KYC $decision.');
  }
}
