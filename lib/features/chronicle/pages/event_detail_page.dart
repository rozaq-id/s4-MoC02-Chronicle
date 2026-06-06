import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/wikipedia_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../widgets/related_event_card.dart';

/// Arguments passed to the detail page route.
class EventDetailArgs {
  const EventDetailArgs({required this.id, required this.year});
  final String id;
  final String year;
}

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key, required this.args});

  final EventDetailArgs args;

  // Sample content keyed by id — replace with a real data layer.
  static const Map<String, _EventSeed> _seeds = {
    'wwii-end': _EventSeed(
      year: '1945',
      title: 'End of WWII in Europe',
      hero: 'https://images.unsplash.com/photo-1551434678-e076c223a692?w=1200',
      paragraphs: [
        'Victory in Europe Day, generally known as V-E Day, was celebrated on Tuesday, 8 May 1945, to mark the formal acceptance by the Allies of World War II of Nazi Germany\'s unconditional surrender of its armed forces. It thus marked the end of World War II in Europe.',
        'The term V-E Day existed as early as September 1944, in anticipation of victory. On 30 April 1945, Adolf Hitler committed suicide during the Battle of Berlin. Germany\'s surrender was authorized by his successor, Reichspräsident Karl Dönitz.',
        'The act of military surrender was first signed at 02:41 on 7 May in SHAEF headquarters at Reims, and a slightly modified document was signed on 8 May in Berlin. Massive celebrations took place across the globe, with millions of people rejoicing in the streets of London, Paris, and New York.',
      ],
    ),
  };

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final WikipediaService _wikiService = WikipediaService();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  double _scrollProgress = 0.0;
  double _parallaxOffset = 0.0;
  String _title = '';
  String? _imageUrl;
  List<String> _paragraphs = [];
  String _year = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadDetail();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;
    final offset = _scrollController.offset;
    setState(() {
      _scrollProgress = (offset / maxScroll).clamp(0.0, 1.0);
      // Parallax: move image slower than scroll
      _parallaxOffset = offset * 0.4;
    });
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
    });

    final summary = await _wikiService.fetchPageSummary(widget.args.id);
    if (summary != null) {
      final summaryExtract = summary['extract'] as String? ?? '';
      final fullExtract = await _wikiService.fetchPageExtract(
        summary['title'] as String? ?? widget.args.id,
      );
      final extract =
          fullExtract != null && fullExtract.length > summaryExtract.length
          ? fullExtract
          : summaryExtract;

      setState(() {
        _title = summary['title'] as String? ?? '';
        _imageUrl =
            summary['originalimage']?['source'] as String? ??
            summary['thumbnail']?['source'] as String?;
        _paragraphs = extract
            .split('\n')
            .where((p) => p.trim().isNotEmpty)
            .toList();
        _year = widget.args.year;
        _isLoading = false;
      });
    } else {
      // Fallback to local seeds
      final seed =
          EventDetailPage._seeds[widget.args.id] ??
          EventDetailPage._seeds['wwii-end']!;
      setState(() {
        _title = seed.title;
        _imageUrl = seed.hero;
        _paragraphs = seed.paragraphs;
        _year = widget.args.year.isNotEmpty ? widget.args.year : seed.year;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: BottomNavBar(currentIndex: 1, onTap: _goToTab),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.goldDeep),
            )
          : Stack(
              children: [
                // Scrollable content
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ParallaxHeroImage(
                            heroUrl: _imageUrl ?? '',
                            parallaxOffset: _parallaxOffset,
                          ),
                          Transform.translate(
                            offset: const Offset(0, -52),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _year.isNotEmpty ? _year : widget.args.year,
                                    style: AppTextStyles.yearBadge.copyWith(
                                      color: AppColors.gold,
                                      fontSize: 56,
                                      height: 1,
                                      letterSpacing: -1.12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _title,
                                    style:
                                        AppTextStyles.display(
                                          weight: FontWeight.w600,
                                        ).copyWith(
                                          fontSize: 34,
                                          color: AppColors.textPrimary,
                                          height: 42 / 34,
                                          letterSpacing: -0.4,
                                        ),
                                  ),
                                  const SizedBox(height: 28),
                                  _ArticleBody(paragraphs: _paragraphs),
                                  const SizedBox(height: 24),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _PillButton(
                                        label: 'Read on Wikipedia',
                                        icon: Icons.open_in_new,
                                        filled: true,
                                        onTap: () {},
                                      ),
                                      const SizedBox(height: 12),
                                      _PillButton(
                                        label: 'Share Event',
                                        icon: Icons.share_outlined,
                                        filled: false,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                  if (_related.isNotEmpty) ...[
                                    const SizedBox(height: 48),
                                    Text(
                                      'Related Events',
                                      style:
                                          AppTextStyles.display(
                                            weight: FontWeight.w600,
                                          ).copyWith(
                                            fontSize: 26,
                                            color: AppColors.textAccent,
                                            height: 32 / 26,
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 136,
                                      child: ListView.separated(
                                        clipBehavior: Clip.none,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: _related.length,
                                        separatorBuilder: (_, _) =>
                                            const SizedBox(width: 16),
                                        itemBuilder: (context, i) {
                                          final r = _related[i];
                                          return RelatedEventCard(
                                            year: r.year,
                                            title: r.title,
                                            onTap: () {},
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Gold progress indicator at top
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _ScrollProgressBar(progress: _scrollProgress),
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 12,
                  left: 16,
                  child: _FrostedIconButton(
                    icon: Icons.arrow_back,
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 12,
                  right: 16,
                  child: _FrostedIconButton(
                    icon: Icons.bookmark_outline,
                    onTap: () {},
                  ),
                ),
              ],
            ),
    );
  }

  void _goToTab(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        return;
      case 1:
        context.go('/explore');
        return;
      case 2:
        context.go('/bookmarks');
        return;
      case 3:
        context.go('/settings');
        return;
    }
  }
}

class _ScrollProgressBar extends StatelessWidget {
  const _ScrollProgressBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 3,
        backgroundColor: AppColors.border.withValues(alpha: 0.22),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
      ),
    );
  }
}

class _ArticleBody extends StatelessWidget {
  const _ArticleBody({required this.paragraphs});

  final List<String> paragraphs;

  bool _isSectionHeading(String text, int index) {
    final trimmed = text.trim();
    if (index == 0 || trimmed.length < 3 || trimmed.length > 72) return false;
    if (trimmed.endsWith('.') ||
        trimmed.endsWith(',') ||
        trimmed.endsWith(';')) {
      return false;
    }
    return !trimmed.contains(':') && trimmed.split(RegExp(r'\s+')).length <= 8;
  }

  bool _headingHasBodyAfter(int index) {
    for (var i = index + 1; i < paragraphs.length; i++) {
      final text = paragraphs[i].trim();
      if (text.isEmpty) continue;
      if (_isSectionHeading(text, i)) return false;
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (index, paragraph) in paragraphs.indexed)
          if (_isSectionHeading(paragraph, index) &&
              _headingHasBodyAfter(index))
            Padding(
              padding: const EdgeInsets.only(top: 22, bottom: 12),
              child: Text(
                paragraph,
                style: AppTextStyles.display(weight: FontWeight.w600).copyWith(
                  color: AppColors.textAccent,
                  fontSize: 24,
                  height: 32 / 24,
                ),
                textAlign: TextAlign.left,
              ),
            )
          else if (!_isSectionHeading(paragraph, index))
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Text(
                paragraph,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 28 / 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
      ],
    );
  }
}

class _ParallaxHeroImage extends StatelessWidget {
  const _ParallaxHeroImage({
    required this.heroUrl,
    required this.parallaxOffset,
  });
  final String heroUrl;
  final double parallaxOffset;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    final heroHeight = media.height < 760 ? 360.0 : 442.0;

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.translate(
            offset: Offset(0, -heroHeight * 0.1 + parallaxOffset * 0.32),
            child: SizedBox(
              height: heroHeight * 1.2,
              child: Image.network(
                heroUrl,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (_, _, _) => Container(
                  color: AppColors.cardDark,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.placeholder,
                  ),
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.background.withValues(alpha: 0.08),
                  AppColors.background.withValues(alpha: 0.18),
                  AppColors.background,
                ],
                stops: const [0.0, 0.52, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FrostedIconButton extends StatelessWidget {
  const _FrostedIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.cardDark.withValues(alpha: 0.72),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.55),
              width: 1,
            ),
          ),
          child: Icon(icon, size: 20, color: AppColors.gold),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return Material(
        color: AppColors.gold,
        borderRadius: BorderRadius.circular(9999),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(9999),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.ui(weight: FontWeight.w700).copyWith(
                    fontSize: 14,
                    color: AppColors.textOnGold,
                    letterSpacing: 0.05 * 14,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, size: 18, color: AppColors.textOnGold),
              ],
            ),
          ),
        ),
      );
    }
    return Material(
      color: AppColors.cardDark,
      borderRadius: BorderRadius.circular(9999),
      child: InkWell(
        borderRadius: BorderRadius.circular(9999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppColors.border.withValues(alpha: 0.75)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.ui(weight: FontWeight.w600).copyWith(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.05 * 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventSeed {
  const _EventSeed({
    required this.year,
    required this.title,
    required this.hero,
    required this.paragraphs,
  });
  final String year;
  final String title;
  final String hero;
  final List<String> paragraphs;
}

const List<_RelatedSeed> _related = [];

class _RelatedSeed {
  const _RelatedSeed({required this.year, required this.title});
  final String year;
  final String title;
}
