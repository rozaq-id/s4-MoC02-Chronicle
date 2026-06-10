import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/wikipedia_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/bottom_nav_bar.dart';
import '../../../shared/widgets/category_tabs.dart';
import '../widgets/article_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WikipediaService _wikiService = WikipediaService();
  final ScrollController _scrollController = ScrollController();
  ChronicleCategory _selectedCategory = ChronicleCategory.events;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String _errorMessage = '';

  static const int _pageSize = 10;
  int _currentPage = 1;
  bool _hasMore = true;

  List<Article> _featured = [];
  List<Article> _events = [];
  List<Article> _births = [];
  List<Article> _deaths = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _currentPage = 1;
      _hasMore = true;
    });

    try {
      final now = DateTime.now();
      final result = await _wikiService.fetchOnThisDay(now.month, now.day);
      setState(() {
        _featured = result['featured'] ?? [];
        _events = result['events'] ?? [];
        _births = result['births'] ?? [];
        _deaths = result['deaths'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load Wikipedia data.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;

    final allArticles = _filteredArticles;
    final totalPages = (allArticles.length / _pageSize).ceil();
    if (_currentPage >= totalPages) {
      setState(() => _hasMore = false);
      return;
    }

    setState(() => _isLoadingMore = true);
    // Simulate loading delay for pagination feel
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _currentPage++;
      _isLoadingMore = false;
    });
  }

  List<Article> get _filteredFeatured {
    if (_selectedCategory == ChronicleCategory.events) {
      return _featured;
    }
    return [];
  }

  List<Article> get _filteredArticles {
    switch (_selectedCategory) {
      case ChronicleCategory.events:
        if (_featured.isNotEmpty) {
          final featuredId = _featured.first.id;
          return _events.where((a) => a.id != featuredId).toList();
        }
        return _events;
      case ChronicleCategory.births:
        return _births;
      case ChronicleCategory.deaths:
        return _deaths;
    }
  }

  List<Article> get _visibleArticles {
    final all = _filteredArticles;
    final count = _currentPage * _pageSize;
    return all.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Text(
                        'Chronicle',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.display(weight: FontWeight.w600)
                            .copyWith(
                              fontSize: 28,
                              color: AppColors.textAccent,
                              height: 36 / 28,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: AppColors.onSurfaceVariant,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        _formatDate(DateTime.now()),
                        style: AppTextStyles.display(weight: FontWeight.bold)
                            .copyWith(
                              fontSize: 48,
                              color: AppColors.textAccent,
                              height: 56 / 48,
                            ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Today in History',
                      style: AppTextStyles.ui().copyWith(
                        fontSize: 18,
                        color: AppColors.onSurfaceVariant,
                        height: 28 / 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Tabs
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: CategoryTabs(
                    selected: _selectedCategory,
                    onChanged: (cat) {
                      setState(() {
                        _selectedCategory = cat;
                        _currentPage = 1;
                        _hasMore = true;
                      });
                    },
                  ),
                ),
              ),
            ),

            // Content Loading / Error / List
            if (_isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 64),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.goldDeep),
                  ),
                ),
              )
            else if (_errorMessage.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 64),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: AppTextStyles.ui().copyWith(
                        fontSize: 16,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              )
            else ...[
              // Featured Card
              if (_filteredFeatured.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: FeaturedArticleCard(
                      article: _filteredFeatured.first,
                      onTap: () => _openDetail(_filteredFeatured.first),
                    ),
                  ),
                ),

              // Article list
              if (_visibleArticles.isNotEmpty)
                SliverList.separated(
                  itemCount: _visibleArticles.length + (_hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, i) {
                    // Show loading indicator at the bottom
                    if (i == _visibleArticles.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: AppColors.goldDeep,
                            ),
                          ),
                        ),
                      );
                    }

                    final article = _visibleArticles[i];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        i == _visibleArticles.length - 1 && !_hasMore ? 24 : 0,
                      ),
                      child: ArticleCard(
                        article: article,
                        onTap: () => _openDetail(article),
                      ),
                    );
                  },
                ),

              // Empty state placeholder for other categories
              if (_filteredFeatured.isEmpty &&
                  _visibleArticles.isEmpty &&
                  !_hasMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 64),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.history_toggle_off,
                            color: AppColors.onSurfaceVariant,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No items for this category yet.',
                            style: AppTextStyles.ui().copyWith(
                              fontSize: 16,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],

            // Bottom padding for nav bar
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: _goToTab),
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

  void _openDetail(Article article) {
    context.go(
      '/detail/${article.id}?year=${Uri.encodeComponent(article.year)}',
    );
  }
}
