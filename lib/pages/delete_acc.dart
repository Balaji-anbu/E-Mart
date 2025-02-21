import 'package:e_mart/constants/colors.dart';
import 'package:e_mart/widgets/notification_service.dart';
import 'package:flutter/material.dart';

class DeleteAcc extends StatelessWidget {
  DeleteAcc({super.key,});
  final NotificationService _notificationService = NotificationService(); // Initialize here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Text(
            'Delete My Account',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'You will not be able to access your personal data, which includes old orders, stored addresses, payment methods, and so on.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
          ),
          ElevatedButton(
            onPressed: () async {
              await _notificationService.showNotification(
                0,
                'Delete Account',
                'Your Account being deleted from app permanantly',
              );
            },
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: GColors.secondary,foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
