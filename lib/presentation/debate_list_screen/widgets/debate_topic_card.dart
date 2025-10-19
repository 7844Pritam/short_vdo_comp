import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DebateTopicCard extends StatelessWidget {
  final Map<String, dynamic> debateData;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const DebateTopicCard({
    super.key,
    required this.debateData,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isHotDebate = debateData['isHot'] ?? false;
    final category = debateData['category'] ?? 'General';
    final responseCount = debateData['responseCount'] ?? 0;
    final responses = (debateData['responses'] as List?) ?? [];

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        onLongPress?.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isHotDebate
              ? Border.all(color: AppTheme.primaryOrange, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, category, isHotDebate),
            _buildContent(theme),
            if (responses.isNotEmpty) _buildResponsePreviews(theme, responses),
            _buildFooter(theme, responseCount),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String category, bool isHotDebate) {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            child: CustomImageWidget(
              imageUrl: debateData['author']?['avatar'] ?? '',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              semanticLabel: debateData['author']?['avatarSemanticLabel'] ??
                  'User profile picture',
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  debateData['author']?['name'] ?? 'Anonymous',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  debateData['timeAgo'] ?? '1h ago',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (isHotDebate) ...[
                CustomIconWidget(
                  iconName: 'local_fire_department',
                  color: AppTheme.primaryOrange,
                  size: 20,
                ),
                SizedBox(width: 1.w),
              ],
              _buildCategoryTag(theme, category),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTag(ThemeData theme, String category) {
    Color tagColor;
    switch (category.toLowerCase()) {
      case 'politics':
        tagColor = Colors.blue;
        break;
      case 'entertainment':
        tagColor = Colors.purple;
        break;
      case 'sports':
        tagColor = Colors.green;
        break;
      case 'technology':
        tagColor = Colors.orange;
        break;
      default:
        tagColor = theme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: tagColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tagColor, width: 1),
      ),
      child: Text(
        category,
        style: theme.textTheme.labelSmall?.copyWith(
          color: tagColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            debateData['title'] ?? 'Debate Topic',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (debateData['description'] != null) ...[
            SizedBox(height: 1.h),
            Text(
              debateData['description'],
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResponsePreviews(ThemeData theme, List responses) {
    return Container(
      margin: EdgeInsets.only(top: 2.h),
      height: 12.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        itemCount: responses.length > 5 ? 5 : responses.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final response = responses[index] as Map<String, dynamic>;
          return Container(
            width: 20.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.secondaryContainer,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  CustomImageWidget(
                    imageUrl: response['thumbnail'] ?? '',
                    width: 20.w,
                    height: 12.h,
                    fit: BoxFit.cover,
                    semanticLabel: response['thumbnailSemanticLabel'] ??
                        'Video response thumbnail',
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.w, vertical: 0.2.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        response['duration'] ?? '0:30',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6.h - 8,
                    left: 10.w - 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'play_arrow',
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, int responseCount) {
    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'forum',
            color: theme.colorScheme.onSurfaceVariant,
            size: 18,
          ),
          SizedBox(width: 1.w),
          Text(
            '$responseCount responses',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          if (debateData['endTime'] != null) ...[
            CustomIconWidget(
              iconName: 'schedule',
              color: theme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              'Ends ${debateData['endTime']}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}