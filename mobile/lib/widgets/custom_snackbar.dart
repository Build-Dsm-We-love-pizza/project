import 'package:flutter/material.dart';

extension ShowSnackBar on BuildContext {
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void showQRSnackBar(bool isSuccess, String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor:
            isSuccess ? Colors.green.shade400 : Colors.red.shade400,
        content: SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                isSuccess ? Icons.check : Icons.clear,
                color: Colors.white,
                size: 32,
              ),
              Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                width: 32,
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
