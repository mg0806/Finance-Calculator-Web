import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LiveFinanceNews extends StatefulWidget {
  const LiveFinanceNews({
    this.pageSize = 9,
    this.showPageTitle = false,
    this.enableLoadMore = false,
    super.key,
  });

  final int pageSize;
  final bool showPageTitle;
  final bool enableLoadMore;

  @override
  State<LiveFinanceNews> createState() => _LiveFinanceNewsState();
}

class _LiveFinanceNewsState extends State<LiveFinanceNews> {
  static const _green = Color(0xFF1A3A2A);
  static const _gold = Color(0xFFF0A500);
  static final Map<String, _CachedNews> _cache = {};
  static const _cacheDuration = Duration(minutes: 15);

  var _activeTab = _newsTabs.first;
  var _articles = <_NewsArticle>[];
  var _source = _NewsSource.newsData;
  var _loading = true;
  var _loadingMore = false;
  var _error = false;
  String? _nextPage;
  int _rssPage = 1;
  bool _rssCanLoadMore = true;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadTab(_activeTab));
  }

  Future<void> _loadTab(_NewsTab tab, {bool forceRefresh = false}) async {
    final requestId = ++_requestId;
    final cacheKey = _cacheKey(tab, widget.pageSize);
    final cached = _cache[cacheKey];
    final fresh = cached != null &&
        DateTime.now().difference(cached.createdAt) < _cacheDuration;

    setState(() {
      _activeTab = tab;
      _loading = true;
      _loadingMore = false;
      _error = false;
      _articles = fresh && !forceRefresh ? cached.articles : _articles;
    });

    if (fresh && !forceRefresh) {
      setState(() {
        _articles = cached.articles;
        _source = cached.source;
        _nextPage = cached.nextPage;
        _rssPage = cached.rssPage;
        _rssCanLoadMore = cached.rssCanLoadMore;
        _loading = false;
      });
      return;
    }

    try {
      final result = await _fetchNewsData(tab, widget.pageSize);
      if (!mounted || requestId != _requestId) return;
      _cache[cacheKey] = _CachedNews(
        articles: result.articles,
        source: result.source,
        nextPage: result.nextPage,
        rssPage: 1,
      );
      setState(() {
        _articles = result.articles;
        _source = result.source;
        _nextPage = result.nextPage;
        _rssPage = 1;
        _rssCanLoadMore = result.canLoadMore;
        _loading = false;
      });
    } catch (_) {
      try {
        final result = await _fetchRss(tab, widget.pageSize, page: 1);
        if (!mounted || requestId != _requestId) return;
        _cache[cacheKey] = _CachedNews(
          articles: result.articles,
          source: result.source,
          nextPage: null,
          rssPage: 1,
          rssCanLoadMore: result.canLoadMore,
        );
        setState(() {
          _articles = result.articles;
          _source = result.source;
          _nextPage = null;
          _rssPage = 1;
          _rssCanLoadMore = result.canLoadMore;
          _loading = false;
        });
      } catch (_) {
        if (!mounted || requestId != _requestId) return;
        setState(() {
          _articles = [];
          _loading = false;
          _error = true;
        });
      }
    }
  }

  Future<void> _refresh() async {
    _cache.remove(_cacheKey(_activeTab, widget.pageSize));
    await _loadTab(_activeTab, forceRefresh: true);
  }

  bool get _canLoadMore =>
      (_source == _NewsSource.rss && _rssCanLoadMore) || _nextPage != null;

  Future<void> _loadMore() async {
    if (_loading || _loadingMore || !_canLoadMore) return;

    setState(() {
      _loadingMore = true;
      _error = false;
    });

    try {
      final result = _source == _NewsSource.newsData && _nextPage != null
          ? await _fetchNewsData(
              _activeTab,
              widget.pageSize,
              page: _nextPage,
            )
          : await _fetchRss(
              _activeTab,
              widget.pageSize,
              page: _rssPage + 1,
            );

      if (!mounted) return;
      final existingUrls = _articles.map((article) => article.url).toSet();
      final newArticles = result.articles
          .where((article) => !existingUrls.contains(article.url))
          .toList();
      setState(() {
        _articles = [..._articles, ...newArticles];
        _nextPage = result.nextPage;
        _rssPage = _source == _NewsSource.rss ? _rssPage + 1 : _rssPage;
        _rssCanLoadMore = _source == _NewsSource.rss
            ? result.canLoadMore && newArticles.isNotEmpty
            : _rssCanLoadMore;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showPageTitle) ...[
          Text(
            'Finance News',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: _green,
            ),
          ),
          const SizedBox(height: 8),
        ],
        _NewsHeader(loading: _loading, onRefresh: _refresh),
        const SizedBox(height: 14),
        _TabBar(
          activeTab: _activeTab,
          onSelect: (tab) => _loadTab(tab),
        ),
        const SizedBox(height: 16),
        if (_loading)
          _NewsGrid(
            children: [
              for (var i = 0; i < widget.pageSize; i++) const _SkeletonCard(),
            ],
          )
        else if (_error || _articles.isEmpty)
          const _ErrorCard()
        else
          _NewsGrid(
            children: [
              for (final article in _articles) _ArticleCard(article: article),
            ],
          ),
        if (widget.enableLoadMore && !_loading && !_error && _canLoadMore) ...[
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.center,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
              ),
              onPressed: _loadingMore ? null : _loadMore,
              icon: _loadingMore
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.add_circle_outline),
              label: Text(_loadingMore ? 'Loading' : 'Load more'),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          _source == _NewsSource.newsData
              ? 'Powered by NewsData.io \u00B7 Updates every 15 min'
              : 'Source: Economic Times \u00B7 Updates every 15 min',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _cacheKey(_NewsTab tab, int size) => '${tab.key}:$size';
}

class _NewsHeader extends StatelessWidget {
  const _NewsHeader({required this.loading, required this.onRefresh});

  final bool loading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final title = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.newspaper_outlined,
                color: _LiveFinanceNewsState._gold),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Live Finance News',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: _LiveFinanceNewsState._green,
                ),
              ),
            ),
          ],
        );

        final refresh = OutlinedButton.icon(
          onPressed: loading ? null : onRefresh,
          icon: loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
          label: const Text('Refresh'),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 6),
              Text(
                'Stay updated with the latest financial news from India',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              refresh,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: 6),
                  Text(
                    'Stay updated with the latest financial news from India',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            refresh,
          ],
        );
      },
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.activeTab, required this.onSelect});

  final _NewsTab activeTab;
  final ValueChanged<_NewsTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final tab in _newsTabs)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                selected: activeTab.key == tab.key,
                label: Text(tab.label),
                selectedColor: _LiveFinanceNewsState._green,
                labelStyle: TextStyle(
                  color: activeTab.key == tab.key ? Colors.white : null,
                  fontWeight: FontWeight.w800,
                ),
                showCheckmark: false,
                onSelected: (_) => onSelect(tab),
              ),
            ),
        ],
      ),
    );
  }
}

class _NewsGrid extends StatelessWidget {
  const _NewsGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 980
            ? 3
            : constraints.maxWidth >= 640
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: columns == 1 ? 1.78 : 1.32,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article});

  final _NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openUrl(article.url),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3D1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          article.source,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF513600),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    article.timeAgo,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.25,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _openUrl(article.url),
                iconAlignment: IconAlignment.end,
                icon: const Icon(Icons.arrow_forward, size: 17),
                label: const Text('Read more'),
                style: TextButton.styleFrom(
                  foregroundColor: _LiveFinanceNewsState._green,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _SkeletonLine(width: 92, height: 24, radius: 999),
                Spacer(),
                _SkeletonLine(width: 46, height: 12),
              ],
            ),
            SizedBox(height: 18),
            _SkeletonLine(width: double.infinity, height: 18),
            SizedBox(height: 8),
            _SkeletonLine(width: 240, height: 18),
            SizedBox(height: 16),
            _SkeletonLine(width: double.infinity, height: 13),
            SizedBox(height: 7),
            _SkeletonLine(width: 210, height: 13),
            Spacer(),
            _SkeletonLine(width: 110, height: 14),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: _LiveFinanceNewsState._gold),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Couldn't load news right now. Try again later.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsArticle {
  const _NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.source,
    required this.publishedAt,
  });

  final String title;
  final String description;
  final String url;
  final String source;
  final DateTime? publishedAt;

  String get timeAgo {
    final published = publishedAt;
    if (published == null) return 'Latest';
    final diff = DateTime.now().difference(published.toLocal());
    if (diff.inMinutes < 1) return 'Now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}

class _NewsTab {
  const _NewsTab({
    required this.key,
    required this.label,
    required this.rssUrl,
  });

  final String key;
  final String label;
  final String rssUrl;
}

class _NewsResult {
  const _NewsResult({
    required this.articles,
    required this.source,
    this.canLoadMore = true,
    this.nextPage,
  });

  final List<_NewsArticle> articles;
  final _NewsSource source;
  final String? nextPage;
  final bool canLoadMore;
}

class _CachedNews {
  _CachedNews({
    required this.articles,
    required this.source,
    required this.rssPage,
    this.rssCanLoadMore = true,
    this.nextPage,
  }) : createdAt = DateTime.now();

  final List<_NewsArticle> articles;
  final _NewsSource source;
  final String? nextPage;
  final int rssPage;
  final bool rssCanLoadMore;
  final DateTime createdAt;
}

enum _NewsSource { newsData, rss }

const _newsTabs = [
  _NewsTab(
    key: 'business',
    label: 'Business',
    rssUrl:
        'https://economictimes.indiatimes.com/markets/rssfeeds/1977021501.cms',
  ),
  _NewsTab(
    key: 'markets',
    label: 'Markets',
    rssUrl:
        'https://economictimes.indiatimes.com/markets/stocks/rssfeeds/2146842.cms',
  ),
  _NewsTab(
    key: 'mutual_funds',
    label: 'Mutual Funds',
    rssUrl: 'https://economictimes.indiatimes.com/mf/rssfeeds/44048.cms',
  ),
  _NewsTab(
    key: 'tax_gst',
    label: 'Tax & GST',
    rssUrl:
        'https://economictimes.indiatimes.com/wealth/tax/rssfeeds/78570550.cms',
  ),
  _NewsTab(
    key: 'real_estate',
    label: 'Real Estate',
    rssUrl:
        'https://economictimes.indiatimes.com/realestate/rssfeeds/26820549.cms',
  ),
];

Future<_NewsResult> _fetchNewsData(
  _NewsTab tab,
  int count, {
  String? page,
}) async {
  final params = {
    'tab': tab.key,
    'size': '$count',
    if (page != null && page.isNotEmpty) 'page': page,
  };
  final uri =
      Uri.base.resolveUri(Uri(path: '/api/news', queryParameters: params));
  final response = await http.get(uri).timeout(const Duration(seconds: 12));
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw StateError('NewsData unavailable');
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final results = (data['results'] as List<dynamic>? ?? [])
      .whereType<Map<String, dynamic>>()
      .map((item) {
        final title = _cleanText(item['title']);
        final url = _cleanText(item['link']);
        return _NewsArticle(
          title: title,
          description: _cleanText(item['description']).isEmpty
              ? title
              : _cleanText(item['description']),
          url: url,
          source: _cleanText(item['source_name']).isEmpty
              ? 'NewsData.io'
              : _cleanText(item['source_name']),
          publishedAt: DateTime.tryParse(_cleanText(item['pubDate'])),
        );
      })
      .where((article) => article.title.isNotEmpty && article.url.isNotEmpty)
      .take(count)
      .toList();

  if (results.isEmpty) throw StateError('No NewsData articles');

  return _NewsResult(
    articles: results,
    source: _NewsSource.newsData,
    nextPage: _cleanText(data['nextPage']).isEmpty
        ? null
        : _cleanText(data['nextPage']),
  );
}

Future<_NewsResult> _fetchRss(
  _NewsTab tab,
  int count, {
  required int page,
}) async {
  final params = {
    'rss_url': tab.rssUrl,
    'count': '$count',
    if (page > 1) 'page': '$page',
  };
  var response = await http
      .get(Uri.https('api.rss2json.com', '/v1/api.json', params))
      .timeout(const Duration(seconds: 12));
  if (response.statusCode == 422) {
    response = await http
        .get(Uri.https('api.rss2json.com', '/v1/api.json', {
          'rss_url': tab.rssUrl,
          if (page > 1) 'page': '$page',
        }))
        .timeout(const Duration(seconds: 12));
  }
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw StateError('RSS unavailable');
  }

  final data = jsonDecode(response.body) as Map<String, dynamic>;
  if (data['status'] != 'ok') throw StateError('RSS unavailable');

  final rawItems = data['items'] as List<dynamic>? ?? [];
  final items = rawItems
      .whereType<Map<String, dynamic>>()
      .map((item) {
        final title = _cleanText(item['title']);
        final url = _cleanText(item['link']);
        return _NewsArticle(
          title: title,
          description: _stripHtml(_cleanText(item['description'])).isEmpty
              ? title
              : _stripHtml(_cleanText(item['description'])),
          url: url,
          source: 'Economic Times',
          publishedAt: DateTime.tryParse(_cleanText(item['pubDate'])),
        );
      })
      .where((article) => article.title.isNotEmpty && article.url.isNotEmpty)
      .take(count)
      .toList();

  if (items.isEmpty) throw StateError('No RSS articles');

  return _NewsResult(
    articles: items,
    source: _NewsSource.rss,
    canLoadMore: rawItems.length >= count,
  );
}

String _cleanText(Object? value) {
  if (value == null) return '';
  return value.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

String _stripHtml(String value) {
  return value
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

Future<void> _openUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  await launchUrl(uri, webOnlyWindowName: '_blank');
}
