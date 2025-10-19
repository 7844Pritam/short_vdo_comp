import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

enum DebateSortOption {
  trending,
  recent,
  mostResponses,
  endingSoon,
}

class DebateSortSheet extends StatelessWidget {
  final DebateSortOption currentSort;
  final Function(DebateSortOption)? onSortChanged;

  const DebateSortSheet({
    super.key,
    required this.currentSort,
    this.onSortChanged,
  });

  static void show(
    BuildContext context, {
    required DebateSortOption currentSort,
    Function(DebateSortOption)? onSortChanged,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DebateSortSheet(
        currentSort: currentSort,
        onSortChanged: onSortChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            _buildHeader(theme),
            _buildSortOptions(theme, context),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Sort Debates',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: theme.colorScheme.onSecondaryContainer,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOptions(ThemeData theme, BuildContext context) {
    final sortOptions = [
      {
        'option': DebateSortOption.trending,
        'title': 'Trending',
        'subtitle': 'Most popular debates right now',
        'icon': 'trending_up',
      },
      {
        'option': DebateSortOption.recent,
        'title': 'Recent',
        'subtitle': 'Newest debates first',
        'icon': 'schedule',
      },
      {
        'option': DebateSortOption.mostResponses,
        'title': 'Most Responses',
        'subtitle': 'Debates with highest engagement',
        'icon': 'forum',
      },
      {
        'option': DebateSortOption.endingSoon,
        'title': 'Ending Soon',
        'subtitle': 'Debates closing within 24 hours',
        'icon': 'timer',
      },
    ];

    return Column(
      children: sortOptions.map((optionData) {
        final option = optionData['option'] as DebateSortOption;
        final isSelected = currentSort == option;

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onSortChanged?.call(option);
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: optionData['icon'] as String,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSecondaryContainer,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        optionData['title'] as String,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        optionData['subtitle'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}