import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../seo_service.dart';
import '../widgets/yieldwise_footer.dart';
import '../widgets/yieldwise_page_scaffold.dart';
import '../widgets/yieldwise_section_hero.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();

  @override
  void initState() {
    super.initState();
    setSeoMeta(
        title: 'Contact YieldWise',
        description:
            'Get in touch with the YieldWise team for suggestions, bugs, or partnerships.');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final uri = Uri(
      scheme: 'mailto',
      path: 'manohargupta0806@gmail.com',
      queryParameters: {
        'subject': 'YieldWise contact from ${_name.text.trim()}',
        'body':
            'Name: ${_name.text.trim()}\nEmail: ${_email.text.trim()}\n\n${_message.text.trim()}',
      },
    );
    final opened = await launchUrl(uri);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(opened
            ? "Message sent! We'll get back to you within 24 hours."
            : 'Could not open your email app.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return YieldWisePageScaffold(
      title: 'Contact',
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const YieldWiseSectionHero(
            title: 'Get in Touch',
            subtitle:
                "Have a suggestion, found a bug, or want to collaborate? We'd love to hear from you.",
            icon: Icons.mail_outline,
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left:
                        BorderSide(color: theme.colorScheme.primary, width: 5),
                  ),
                ),
                padding: const EdgeInsets.only(left: 14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Enter your name'
                                  : null),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                  .hasMatch(email)
                              ? null
                              : 'Enter a valid email';
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                          controller: _message,
                          decoration:
                              const InputDecoration(labelText: 'Message'),
                          maxLines: 5,
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Enter your message'
                                  : null),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                            onPressed: _submit,
                            icon: const Icon(Icons.send_outlined),
                            label: const Text('Send Message')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 32),
          const Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.email_outlined),
                SizedBox(width: 8),
                Text('Email: manohargupta0806@gmail.com')
              ]),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.public),
                SizedBox(width: 8),
                Text('Website: yieldwise.online')
              ]),
            ],
          ),
          const SizedBox(height: 12),
          Text(
              'For business inquiries or affiliate partnerships, please mention the subject clearly.',
              style: theme.textTheme.labelSmall),
          const YieldWiseFooter(),
        ],
      ),
    );
  }
}
