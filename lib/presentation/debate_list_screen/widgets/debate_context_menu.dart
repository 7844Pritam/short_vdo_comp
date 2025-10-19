import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DebateContextMenu extends StatelessWidget {
  final Map<String, dynamic> debateData;
  final VoidCallback? onFollow;
  final VoidCallback? onShare;
  final VoidCallback? onReport;

  const DebateContextMenu({
    super.key,
    required this.debateData,
    this.onFollow,
    this.onShare,
    this.onReport,
  });

  static void show(
    BuildContext context, {
    required Map<String, dynamic> debateData,
    VoidCallback? onFollow,
    VoidCallback? onShare,
    VoidCallback? onReport,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DebateContextMenu(
        debateData: debateData,
        onFollow: onFollow,
        onShare: onShare,
        onReport: onReport,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFollowing = debateData['isFollowing'] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(theme, context),
            _buildDebateInfo(theme),
            _buildMenuOptions(theme, context, isFollowing),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: CustomIconWidget(
              iconName: 'close',
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebateInfo(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
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
                  debateData['title'] ?? 'Debate Topic',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'by ${debateData['author']?['name'] ?? 'Anonymous'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptions(
      ThemeData theme, BuildContext context, bool isFollowing) {
    final menuOptions = [
      {
        'icon': isFollowing ? 'notifications_off' : 'notifications',
        'title': isFollowing ? 'Unfollow Debate' : 'Follow Debate',
        'subtitle': isFollowing
            ? 'Stop receiving notifications for this debate'
            : 'Get notified when new responses are posted',
        'onTap': onFollow,
        'color':
            isFollowing ? theme.colorScheme.error : theme.colorScheme.primary,
      },
      {
        'icon': 'share',
        'title': 'Share Topic',
        'subtitle': 'Share this debate with friends',
        'onTap': onShare,
        'color': theme.colorScheme.primary,
      },
      {
        'icon': 'report',
        'title': 'Report',
        'subtitle': 'Report inappropriate content',
        'onTap': onReport,
        'color': theme.colorScheme.error,
      },
    ];

    return Column(
      children: menuOptions.map((option) {
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
            option['onTap'] as VoidCallback?;
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (option['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: option['icon'] as String,
                    color: option['color'] as Color,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option['title'] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        option['subtitle'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
