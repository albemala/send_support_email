import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:send_support_email/send_support_email.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AppView());
}

class AppView extends HookWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: ContentView(),
      ),
    );
  }
}

class ContentView extends HookWidget {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final packageInfo = useFuture(
      generatePackageInfo(),
    );
    final systemInfo = useFuture(
      generateSystemInfo(),
    );
    final deviceInfo = useFuture(
      generateDeviceInfo(),
    );
    final supportEmailContent = useFuture(
      generateSupportEmail('albemala@gmail.com'),
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Package info',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${packageInfo.data}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Text(
              'System info',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${systemInfo.data}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Text(
              'Device info',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${deviceInfo.data}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            Text(
              'Support email',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${supportEmailContent.data}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // add a button to send an email
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final emailContent = supportEmailContent.data;
                if (emailContent == null) return;

                final url = Uri.parse(emailContent);
                final didLaunch = await launchUrl(url);
                if (!didLaunch) {
                  print('Could not launch $url');
                }
              },
              child: const Text('Send support email'),
            ),
          ],
        ),
      ),
    );
  }
}
