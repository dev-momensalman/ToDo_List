import 'package:flutter/material.dart';
import '../../services/notification_service.dart';
import 'dart:developer';

class NotificationTestView extends StatefulWidget {
  const NotificationTestView({super.key});

  @override
  State<NotificationTestView> createState() => _NotificationTestViewState();
}

class _NotificationTestViewState extends State<NotificationTestView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF6C5CE7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Notification Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 20),

            // Body Input
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Notification Body',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.message),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            // Token Input
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: 'FCM Token (Optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.key),
                hintText: 'Leave empty to use current user token',
              ),
            ),
            const SizedBox(height: 30),

            // Send Test Notification Button
            ElevatedButton(
              onPressed: _isLoading ? null : _sendTestNotification,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C5CE7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Send Test Notification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // Subscribe to Topic Button
            ElevatedButton(
              onPressed: _isLoading ? null : _subscribeToTopic,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00CEC9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Subscribe to CloudNote Topic',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // Info Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notification Features:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildFeatureItem('✅ Firebase Cloud Messaging'),
                    _buildFeatureItem('✅ Local Notifications'),
                    _buildFeatureItem('✅ Background Support'),
                    _buildFeatureItem('✅ Topic Subscriptions'),
                    _buildFeatureItem('✅ Token Management'),
                    _buildFeatureItem('✅ Permission Handling'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  Future<void> _sendTestNotification() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in title and body'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // For demo purposes, we'll just log the notification
      // In a real app, you'd send this to your backend
      log('Sending test notification...');
      log('Title: ${_titleController.text}');
      log('Body: ${_bodyController.text}');
      log(
        'Token: ${_tokenController.text.isNotEmpty ? _tokenController.text : "Current user token"}',
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test notification logged successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear fields
      _titleController.clear();
      _bodyController.clear();
      _tokenController.clear();
    } catch (e) {
      log('Error sending test notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _subscribeToTopic() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await NotificationService().subscribeToTopic('cloudnote_updates');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subscribed to CloudNote topic successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      log('Error subscribing to topic: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
