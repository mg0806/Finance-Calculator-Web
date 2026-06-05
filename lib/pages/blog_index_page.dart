import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../navigation.dart';
import '../seo_service.dart';
import '../widgets/yieldwise_footer.dart';
import '../widgets/yieldwise_page_scaffold.dart';
import '../widgets/yieldwise_section_hero.dart';

class BlogIndexPage extends StatefulWidget {
  const BlogIndexPage({super.key});

  @override
  State<BlogIndexPage> createState() => _BlogIndexPageState();
}

class _BlogIndexPageState extends State<BlogIndexPage> {
  var query = '';

  @override
  void initState() {
    super.initState();
    setSeoMeta(
        title: 'Financial Guides & Articles - YieldWise',
        description:
            'Practical finance articles covering SIP, EMI, FD, PPF, retirement, and tax planning.');
  }

  @override
  Widget build(BuildContext context) {
    final filtered = articles.where((article) {
      final needle = query.toLowerCase();
      return article.title.toLowerCase().contains(needle) ||
          article.category.toLowerCase().contains(needle);
    }).toList();
    return YieldWisePageScaffold(
      title: 'Blog',
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const YieldWiseSectionHero(
            title: 'Financial Guides & Articles',
            subtitle:
                'Practical insights to help you make smarter money decisions.',
            icon: Icons.article_outlined,
          ),
          const SizedBox(height: 18),
          TextField(
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search articles'),
            onChanged: (value) => setState(() => query = value),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth >= 760;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: twoColumns ? 2 : 1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: twoColumns ? 2.25 : 1.55,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) => _ArticleCard(
                  article: filtered[index],
                  color: _blogColors[index % _blogColors.length],
                ),
              );
            },
          ),
          const YieldWiseFooter(),
        ],
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.color});

  final ArticleModel article;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => goNamed(context, article.route),
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 5)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(label: Text(article.category)),
              const SizedBox(height: 8),
              Text(article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(article.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium),
              const Spacer(),
              Row(
                children: [
                  Text(article.readTime, style: theme.textTheme.labelSmall),
                  const SizedBox(width: 12),
                  Text('June 2025', style: theme.textTheme.labelSmall),
                  const Spacer(),
                  TextButton(
                      onPressed: () => goNamed(context, article.route),
                      child: const Text('Read Article')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _blogColors = [
  Color(0xFF087A5D),
  Color(0xFF1E5EFF),
  Color(0xFF0B5CAD),
  Color(0xFFB75C12),
  Color(0xFF6D3FD1),
  Color(0xFFD92755),
];
