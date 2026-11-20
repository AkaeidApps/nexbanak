import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/core/network/api_client.dart';
import 'package:nexbanak/data/providers/demo_data_source.dart';
import 'package:nexbanak/data/repositories/admin_repository.dart';
import 'package:nexbanak/data/repositories/auth_repository.dart';
import 'package:nexbanak/data/repositories/banking_repository.dart';

/// Wires the correct implementations for demo vs. live backend in one place.
class RepositoryProvider extends GetxService {
  late final AuthRepository auth;
  late final BankingRepository banking;
  late final AdminRepository admin;
  late final DemoDataSource? demo;

  @override
  void onInit() {
    super.onInit();
    if (AppConstants.useMock) {
      demo = DemoDataSource();
      auth = DemoAuthRepository(demo!);
      banking = DemoBankingRepository(demo!);
      admin = DemoAdminRepository(demo!);
    } else {
      demo = null;
      final ApiClient api = Get.find<ApiClient>();
      auth = RemoteAuthRepository(api);
      banking = RemoteBankingRepository(api);
      admin = RemoteAdminRepository(api);
    }
  }
}
