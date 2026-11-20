import 'package:get/get.dart';
import 'package:nexbanak/core/base_controller.dart';
import 'package:nexbanak/data/models/dashboard_models.dart';
import 'package:nexbanak/data/providers/repository_provider.dart';

class AdminHomeController extends BaseController {
  final Rxn<AdminStats> stats = Rxn<AdminStats>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => guard(() async {
        stats.value = await Get.find<RepositoryProvider>().admin.adminStats();
        return true;
      });

  List<double> get depositSeries =>
      stats.value?.depositSeries ?? <double>[];
  List<double> get withdrawalSeries =>
      stats.value?.withdrawalSeries ?? <double>[];
  static const List<String> monthLabels = <String>[
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
}
