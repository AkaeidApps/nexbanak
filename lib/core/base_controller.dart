import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/core/errors/app_exception.dart';

/// Common loading / error / snackbar behaviour for every feature controller.
abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  /// Accepts a dynamic future so void loaders can return a completion marker
  /// while typed callers still get their model inferred at the call site.
  Future<T?> guard<T>(
    Future<dynamic> Function() action, {
    String? successMessage,
    bool silent = false,
  }) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final dynamic result = await action();
      if (successMessage != null && !silent) showSuccess(successMessage);
      if (result is T) return result;
      return null;
    } on AppException catch (e) {
      errorMessage.value = e.message;
      if (!silent) showError(e.message);
      return null;
    } catch (e) {
      errorMessage.value = e.toString();
      if (!silent) showError('Something went wrong. Please try again.');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void showSuccess(String message) => Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
      );

  void showError(String message) => Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: const Color(0xFFFFFFFF),
        margin: const EdgeInsets.all(16),
      );
}
