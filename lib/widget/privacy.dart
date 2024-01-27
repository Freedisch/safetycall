import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: 'Privacy Policy\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              TextSpan(text: 'Thank you for choosing Safety Call! This Privacy Policy outlines how we collect, use, and safeguard your personal information. By using Safety Call, you agree to the terms outlined in this policy.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Information We Collect\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: 'Personal Information\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'When you use Safety Call, we may collect personal information such as your name, phone number, and emergency contacts. This information is essential for the functionality of the app and is securely stored on your device.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Usage Data\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'Safety Call may collect usage data, including but not limited to call logs, messages, and app interactions. This data helps us enhance your experience and improve our services.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Location Information\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'Safety Call may request access to your device\'s location for emergency services. Your location data is not stored unless explicitly permitted by you.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Optional Features\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'Safety Call may offer optional features like video recording. We do not save video recordings unless you choose to enable this feature. Your privacy and consent are of utmost importance to us.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'How We Use Your Information\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: 'Emergency Situations\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'Your personal information and location data may be used in emergency situations to provide assistance and contact your designated emergency contacts.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'App Improvements\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'We use collected data to enhance and personalize your experience with Safety Call. This may include improving features, fixing issues, and optimizing performance.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Communication\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'Safety Call may use your contact information to send important updates, notifications, and relevant information related to the app.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Data Security\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: 'We prioritize the security of your data. Safety Call employs industry-standard security measures to protect your personal information from unauthorized access, disclosure, alteration, or destruction.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Third-Party Services\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: 'Safety Call may utilize third-party services for specific features. These services adhere to their own privacy policies, and we recommend reviewing their terms.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Your Choices\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: 'Consent\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'By using Safety Call, you consent to the collection and use of your information as outlined in this Privacy Policy.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Opt-Out\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextSpan(text: 'You may opt-out of certain data collection by adjusting your app settings. However, some features may require specific data for proper functionality.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Changes to this Policy\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: 'We reserve the right to update or modify this Privacy Policy at any time. Changes will be effective upon posting, and we encourage you to review this page periodically.\n\n', style: TextStyle(fontSize: 18)),
              TextSpan(text: 'Contact Us\n', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              TextSpan(text: 'If you have any questions or concerns about this Privacy Policy, please contact us at support@safetycall.com.\n', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
