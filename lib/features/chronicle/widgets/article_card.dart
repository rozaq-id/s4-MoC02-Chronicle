import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Sample article model used to render list cards.
class Article {
  const Article({
    required this.id,
    required this.year,
    required this.title,
    required this.excerpt,
    this.imageUrl,
  });

  final String id;
  final String year;
  final String title;
  final String excerpt;
  final String? imageUrl;
}

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.article, required this.onTap});

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.customSurface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppColors.customSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.customBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.goldDeep,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        article.year,
                        style: AppTextStyles.ui(
                          weight: FontWeight.bold,
                        ).copyWith(
                          fontSize: 12,
                          color: const Color(0xFF181309),
                          letterSpacing: 0.05 * 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.display(weight: FontWeight.bold)
                          .copyWith(
                            fontSize: 20,
                            color: AppColors.textAccent,
                            height: 28 / 20,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.excerpt,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.ui().copyWith(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Thumbnail
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.inputBg,
                  borderRadius: BorderRadius.circular(8),
                  image: article.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(article.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: article.imageUrl == null
                    ? const Icon(
                        Icons.image,
                        color: AppColors.placeholder,
                        size: 32,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Featured card for the top of Home with a hero image.
class FeaturedArticleCard extends StatelessWidget {
  const FeaturedArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  final Article article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: article.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(article.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : const DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/seed/chronicle/700/400',
                      ),
                      fit: BoxFit.cover,
                    ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x80000000),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.40),
                    Colors.black.withValues(alpha: 0.95),
                  ],
                  stops: const [0.0, 0.40, 1.0],
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.goldDeep,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      article.year,
                      style: AppTextStyles.ui(
                        weight: FontWeight.bold,
                      ).copyWith(
                        fontSize: 14,
                        color: const Color(0xFF181309),
                        letterSpacing: 0.05 * 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.display(weight: FontWeight.bold)
                        .copyWith(
                          fontSize: 28,
                          color: AppColors.textAccent,
                          height: 36 / 28,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
