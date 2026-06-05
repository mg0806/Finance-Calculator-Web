import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  var _isSending = false;

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
    setState(() => _isSending = true);
    try {
      final response = await http.post(
        Uri.base.resolve('/api/contact'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _name.text.trim(),
          'email': _email.text.trim(),
          'message': _message.text.trim(),
        }),
      );

      if (!mounted) return;
      if (response.statusCode >= 200 && response.statusCode < 300) {
        _formKey.currentState!.reset();
        _name.clear();
        _email.clear();
        _message.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Message sent! We'll get back to you within 24 hours."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not send your message. Please try again.'),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not send your message. Please try again.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
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
                            onPressed: _isSending ? null : _submit,
                            icon: _isSending
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Icons.send_outlined),
                            label: Text(
                                _isSending ? 'Sending...' : 'Send Message')),
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
