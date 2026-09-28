import 'package:flutter/material.dart';

class LegalCenterScreen extends StatelessWidget {
  const LegalCenterScreen({super.key});

  void _openDocument(
    BuildContext context, {
    required String title,
    required List<LegalSection> sections,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LegalDocumentScreen(title: title, sections: sections),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Legal & Privacy')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Martigo Legal & Privacy',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Information about your data, account, payments, accessibility '
              'and use of Martigo.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            _LegalTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'How Martigo handles personal information.',
              onTap: () {
                _openDocument(
                  context,
                  title: 'Privacy Policy',
                  sections: _privacySections,
                );
              },
            ),

            _LegalTile(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              subtitle: 'Rules for using Martigo.',
              onTap: () {
                _openDocument(
                  context,
                  title: 'Terms & Conditions',
                  sections: _termsSections,
                );
              },
            ),

            _LegalTile(
              icon: Icons.cookie_outlined,
              title: 'Cookie & Local Storage Policy',
              subtitle: 'How the web version may store preferences.',
              onTap: () {
                _openDocument(
                  context,
                  title: 'Cookie & Local Storage Policy',
                  sections: _cookieSections,
                );
              },
            ),

            _LegalTile(
              icon: Icons.currency_rupee_rounded,
              title: 'Refund Policy',
              subtitle: 'Refund information for customers and sellers.',
              onTap: () {
                _openDocument(
                  context,
                  title: 'Refund Policy',
                  sections: _refundSections,
                );
              },
            ),

            _LegalTile(
              icon: Icons.storage_outlined,
              title: 'Data We Collect',
              subtitle: 'A clear list of information Martigo may use.',
              onTap: () {
                _openDocument(
                  context,
                  title: 'Data We Collect',
                  sections: _dataSections,
                );
              },
            ),

            _LegalTile(
              icon: Icons.hub_outlined,
              title: 'Third-Party Services',
              subtitle: 'Services Martigo may integrate with.',
              onTap: () {
                _openDocument(
                  context,
                  title: 'Third-Party Services',
                  sections: _thirdPartySections,
                );
              },
            ),

            _LegalTile(
              icon: Icons.accessibility_new_rounded,
              title: 'Accessibility',
              subtitle: 'Our accessibility goals and support.',
              onTap: () {
                _openDocument(
                  context,
                  title: 'Accessibility',
                  sections: _accessibilitySections,
                );
              },
            ),

            _LegalTile(
              icon: Icons.verified_outlined,
              title: 'Transparency & Business Details',
              subtitle: 'Demo content, claims and business information.',
              onTap: () {
                _openDocument(
                  context,
                  title: 'Transparency & Business Details',
                  sections: _transparencySections,
                );
              },
            ),

            const SizedBox(height: 20),

            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Development notice: Martigo currently uses mock/local '
                  'features in parts of the application. Policies must be '
                  'reviewed again when real authentication, payments, '
                  'analytics or production databases are enabled.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegalTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _LegalTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: 16,
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class LegalDocumentScreen extends StatelessWidget {
  final String title;
  final List<LegalSection> sections;

  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: SelectionArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text(
                'Last updated: September 2026',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              for (final section in sections) ...[
                Text(
                  section.heading,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  section.body,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LegalSection {
  final String heading;
  final String body;

  const LegalSection({required this.heading, required this.body});
}

const _privacySections = [
  LegalSection(
    heading: '1. Information we collect',
    body:
        'Martigo may collect information you provide when creating an '
        'account, such as your name, mobile number, email address and '
        'account details. Sellers may also provide business name, owner '
        'details and business address.',
  ),
  LegalSection(
    heading: '2. Community and pre-order information',
    body:
        'Martigo may process your selected apartment, college, supermarket '
        'or canteen community, along with products, quantities, pickup dates '
        'and other information required to provide pre-order services.',
  ),
  LegalSection(
    heading: '3. How information is used',
    body:
        'Information may be used to operate your account, process '
        'pre-orders, connect customers with their selected community, help '
        'sellers understand demand, provide support and improve Martigo.',
  ),
  LegalSection(
    heading: '4. Data sharing',
    body:
        'Information should only be shared with service providers or '
        'businesses when needed to operate Martigo, process a requested '
        'service, comply with law or protect the platform.',
  ),
  LegalSection(
    heading: '5. Security',
    body:
        'Martigo aims to use appropriate technical and organizational '
        'measures to protect user information. No online system can '
        'guarantee absolute security.',
  ),
];

const _termsSections = [
  LegalSection(
    heading: '1. Using Martigo',
    body:
        'You must provide accurate information and use Martigo only for '
        'lawful purposes. You are responsible for activity performed using '
        'your account.',
  ),
  LegalSection(
    heading: '2. Pre-orders',
    body:
        'Availability, pickup times and fulfilment may depend on the selected '
        'seller or community. Users should review order information before '
        'confirming a pre-order.',
  ),
  LegalSection(
    heading: '3. Sellers',
    body:
        'Sellers are responsible for keeping product, menu, stock, pricing '
        'and fulfilment information accurate.',
  ),
  LegalSection(
    heading: '4. Accounts and misuse',
    body:
        'Martigo may restrict accounts that misuse the service, attempt '
        'fraud, interfere with the platform or violate applicable rules.',
  ),
];

const _cookieSections = [
  LegalSection(
    heading: 'Cookies',
    body:
        'Martigo should only use cookies when required for application '
        'functionality or when a future service such as analytics requires '
        'them. Optional tracking cookies should not be enabled without '
        'appropriate disclosure and consent.',
  ),
  LegalSection(
    heading: 'Local storage',
    body:
        'The web application may use browser storage to remember application '
        'state or preferences. This information should only be stored when '
        'needed for Martigo features.',
  ),
  LegalSection(
    heading: 'Future analytics',
    body:
        'If analytics or advertising technologies are added later, this '
        'policy and the consent experience must be updated before they are '
        'enabled.',
  ),
];

const _refundSections = [
  LegalSection(
    heading: 'Customer orders',
    body:
        'Refund eligibility for a customer order may depend on whether the '
        'seller has already prepared or fulfilled the order. The final '
        'production policy should define cancellation deadlines and seller '
        'responsibilities clearly.',
  ),
  LegalSection(
    heading: 'Seller subscriptions',
    body:
        'If paid seller memberships are enabled, subscription charges, '
        'renewals, cancellations and refund eligibility must be shown before '
        'payment.',
  ),
  LegalSection(
    heading: 'Payment provider',
    body:
        'When online payments are enabled, payment processing may be handled '
        'by an external payment provider. Martigo should not store raw card '
        'details.',
  ),
];

const _dataSections = [
  LegalSection(
    heading: 'Customer information',
    body:
        'Name, mobile number, email address, selected community, cart '
        'contents, pre-order details, pickup date and pickup time.',
  ),
  LegalSection(
    heading: 'Seller information',
    body:
        'Business or store name, owner name, mobile number, email address, '
        'business address, community information, products, menu items, '
        'stock information and order-management data.',
  ),
  LegalSection(
    heading: 'Technical information',
    body:
        'When production services are enabled, Martigo may process basic '
        'technical information needed for security, diagnostics and '
        'application operation.',
  ),
];

const _thirdPartySections = [
  LegalSection(
    heading: 'Supabase',
    body:
        'Martigo plans to use Supabase for services such as authentication '
        'and database storage. This section should be reviewed when the '
        'production integration is enabled.',
  ),
  LegalSection(
    heading: 'Payment services',
    body:
        'Martigo may use a payment provider such as Razorpay for seller '
        'subscriptions or other payments. Payment providers operate under '
        'their own terms and privacy practices.',
  ),
  LegalSection(
    heading: 'Other services',
    body:
        'Any future analytics, maps, messaging, hosting or notification '
        'services should be disclosed here before production use.',
  ),
];

const _accessibilitySections = [
  LegalSection(
    heading: 'Accessible interface',
    body:
        'Martigo aims to provide readable text, clear labels, sufficient '
        'colour contrast and touch targets that are easy to use.',
  ),
  LegalSection(
    heading: 'Keyboard access',
    body:
        'Interactive controls should support keyboard navigation on the web '
        'where Flutter and the user device provide keyboard interaction.',
  ),
  LegalSection(
    heading: 'Clear controls',
    body:
        'Buttons should use meaningful labels and important actions should '
        'not rely on colour alone.',
  ),
];

const _transparencySections = [
  LegalSection(
    heading: 'Demo and development content',
    body:
        'Mock accounts, demonstration products, sample demand figures and '
        'other development data should not be presented as real customer '
        'reviews, verified sales or actual business performance.',
  ),
  LegalSection(
    heading: 'Claims',
    body:
        'Marketing claims should be accurate and supported. Martigo should '
        'not publish fake ratings, fabricated testimonials or unsupported '
        'business claims.',
  ),
  LegalSection(
    heading: 'Business details',
    body:
        'Before public commercial launch, Martigo should provide genuine '
        'business contact details and an appropriate support method.',
  ),
];
