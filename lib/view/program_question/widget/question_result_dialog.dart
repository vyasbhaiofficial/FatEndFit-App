import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../program_question_controller.dart';


extension QuestionResultDialog on QuestionController {
  void showResultBottomSheet(
      {required int correct,
        required int wrong,
        required double percent}) async {
    await showModalBottomSheet(enableDrag: false,useSafeArea: true,showDragHandle: false,
      context: Get.context!,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SafeArea(bottom: true,
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.75,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, -3))
                  ],
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 6,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Icon(Icons.emoji_events,
                          color: Colors.amber, size: 80),
                      const SizedBox(height: 12),
                      Text(
                        "Result",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
          
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _statBox("✅ Correct", correct.toString(), Colors.green),
                          _statBox("❌ Wrong", wrong.toString(), Colors.red),
                          _statBox("📊 Score",
                              "${percent.toStringAsFixed(1)}%", Colors.blue),
                        ],
                      ),
          
                      const SizedBox(height: 30),
          
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.back(result: true);
                          Get.back(result: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text("Close",
                            style: TextStyle(
                                fontSize: 16, color: Colors.white)),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _statBox(String title, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 6),
        Text(title,
            style: const TextStyle(fontSize: 14, color: Colors.black54)),
      ],
    );
  }
}
