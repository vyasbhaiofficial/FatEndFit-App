import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../utils/app_color.dart';


class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final isOnline = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity().then((_) {
      // initial state check
      if (!isOnline.value) {
        _showNoInternetDialog();
      }
    });

    // Observe isOnline changes to show/hide dialog
    ever(isOnline, (bool online) {
      if (!online) {
        _showNoInternetDialog();
      } else {
        _closeNoInternetDialog();
      }
    });
  }

  Future<ConnectivityService> initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      isOnline.value = false;
    }

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
          (List<ConnectivityResult> result) {
        _updateConnectionStatus(result);
      },
    );

    return this;
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final wasOffline = !isOnline.value;

    isOnline.value = result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.ethernet);

    print('🌐 Connectivity Status: ${isOnline.value ? "ONLINE ✅" : "OFFLINE ❌"}');

    if (wasOffline && isOnline.value) {
      print('📡 Back online!');
    }
  }

  Future<bool> isConnected() async {
    try {
      final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.ethernet);
    } catch (e) {
      return false;
    }
  }

  void checkAndShowDialog() async {
    if (!await isConnected()) {
      _showNoInternetDialog();
    }
  }

  /// Show No Internet Dialog
  void _showNoInternetDialog() {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: _NoInternetDialog(),
        ),
        barrierDismissible: false,
        transitionCurve: Curves.easeInOut,
        transitionDuration: const Duration(milliseconds: 400),
      );
    }
  }

  /// Close dialog
  void _closeNoInternetDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}

/// Custom No Internet Dialog Widget
class _NoInternetDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.transparent,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColor.yellow,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              ),
            ],
          ),
          width: Get.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 60, color: AppColor.black),
              const SizedBox(height: 16),
              Text(
                "No Internet Connection",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Please check your network and try again.",
                style: TextStyle(fontSize: 14, color: AppColor.black),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}