import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../navigation.dart';
import '../seo_service.dart';
import 'affiliate_disclosure.dart';
import 'calculator_cta_banner.dart';
import 'yieldwise_footer.dart';
import 'yieldwise_page_scaffold.dart';
import 'yieldwise_section_hero.dart';

class ArticlePageTemplate extends StatefulWidget {
  const ArticlePageTemplate({
    required this.article,
    required this.intro,
    required this.blocks,
    required this.ctas,
    super.key,
  });

  final ArticleModel article;
  final String intro;
  final List<ArticleBlock> blocks;
  final List<CalculatorCtaBanner> ctas;

  @override
  State<ArticlePageTemplate> createState() => _ArticlePageTemplateState();
}

class _ArticlePageTemplateState extends State<ArticlePageTemplate> {
  @override
  void initState() {
    super.initState();
    setSeoMeta(
        title: '${widget.article.title} - YieldWise',
        description: widget.article.description);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return YieldWisePageScaffold(
      title: 'YieldWise',
      showBack: true,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  YieldWiseSectionHero(
                    title: widget.article.title,
                    subtitle: widget.intro,
                    icon: Icons.article_outlined,
                    trailing: SizedBox(
                      width: 220,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _HeaderChip(label: widget.article.category),
                          _HeaderChip(label: widget.article.readTime),
                          const _HeaderChip(
                              label: 'Not SEBI-registered advice'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (final block in widget.blocks)
                    _ArticleBlockView(block: block),
                  ...widget.ctas.map((cta) => Padding(
                      padding: const EdgeInsets.only(top: 12), child: cta)),
                  const SizedBox(height: 12),
                  const AffiliateDisclosure(),
                  const SizedBox(height: 24),
                  Text('Related Articles',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final article in articles
                          .where((item) => item.slug != widget.article.slug)
                          .take(3))
                        SizedBox(
                          width: 280,
                          child: Card(
                            child: ListTile(
                              title: Text(article.title,
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                              subtitle: Text(article.category),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () => goNamed(context, article.route),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const YieldWiseFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleBlock {
  const ArticleBlock.heading(this.text)
      : type = ArticleBlockType.heading,
        rows = const [],
        headers = const [];

  const ArticleBlock.paragraph(this.text)
      : type = ArticleBlockType.paragraph,
        rows = const [],
        headers = const [];

  const ArticleBlock.bullets(this.rows)
      : type = ArticleBlockType.bullets,
        text = '',
        headers = const [];

  const ArticleBlock.tip(this.text)
      : type = ArticleBlockType.tip,
        rows = const [],
        headers = const [];

  const ArticleBlock.table({required this.headers, required this.rows})
      : type = ArticleBlockType.table,
        text = '';

  final ArticleBlockType type;
  final String text;
  final List<String> headers;
  final List<List<String>> rows;
}

enum ArticleBlockType { heading, paragraph, bullets, tip, table }

class _ArticleBlockView extends StatelessWidget {
  const _ArticleBlockView({required this.block});

  final ArticleBlock block;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    switch (block.type) {
      case ArticleBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 8),
          child: Text(block.text,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800)),
        );
      case ArticleBlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(block.text, style: theme.textTheme.bodyMedium),
        );
      case ArticleBlockType.bullets:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final item in block.rows.map((row) => row.first))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.circle,
                          size: 8, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(item, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                ),
            ],
          ),
        );
      case ArticleBlockType.tip:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    left:
                        BorderSide(width: 4, color: theme.colorScheme.primary)),
              ),
              padding: const EdgeInsets.all(14),
              child: Text(block.text,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ),
          ),
        );
      case ArticleBlockType.table:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  for (final header in block.headers)
                    DataColumn(label: Text(header))
                ],
                rows: [
                  for (final row in block.rows)
                    DataRow(
                        cells: [for (final cell in row) DataCell(Text(cell))]),
                ],
              ),
            ),
          ),
        );
    }
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF042C24),
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}
