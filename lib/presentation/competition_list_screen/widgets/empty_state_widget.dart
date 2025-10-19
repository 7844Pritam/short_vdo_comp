import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String category;
  final VoidCallback? onCreateChallenge;

  const EmptyStateWidget({
    super.key,
    required this.category,
    this.onCreateChallenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIllustration(),
          SizedBox(height: 4.h),
          _buildTitle(),
          SizedBox(height: 2.h),
          _buildDescription(),
          SizedBox(height: 4.h),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    IconData illustrationIcon;
    Color illustrationColor;

    switch (category.toLowerCase()) {
      case 'active':
        illustrationIcon = Icons.emoji_events_outlined;
        illustrationColor = AppTheme.primaryOrange;
        break;
      case 'pending':
        illustrationIcon = Icons.hourglass_empty;
        illustrationColor = AppTheme.warningOrange;
        break;
      case 'completed':
        illustrationIcon = Icons.check_circle_outline;
        illustrationColor = AppTheme.successGreen;
        break;
      default:
        illustrationIcon = Icons.sports_mma_outlined;
        illustrationColor = AppTheme.primaryOrange;
    }

    return Container(
      width: 30.w,
      height: 30.w,
      decoration: BoxDecoration(
        color: illustrationColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: illustrationColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: _getIconName(illustrationIcon),
          color: illustrationColor,
          size: 15.w,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    String title;

    switch (category.toLowerCase()) {
      case 'active':
        title = 'No Active Competitions';
        break;
      case 'pending':
        title = 'No Pending Invitations';
        break;
      case 'completed':
        title = 'No Completed Battles';
        break;
      default:
        title = 'No Competitions Found';
    }

    return Text(
      title,
      style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
        color: AppTheme.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    String description;

    switch (category.toLowerCase()) {
      case 'active':
        description =
            'Start your competitive journey by creating your first challenge or accepting invitations from other creators.';
        break;
      case 'pending':
        description =
            'You don\'t have any pending competition invitations at the moment. Check back later for new challenges.';
        break;
      case 'completed':
        description =
            'Complete some competitions to see your battle history and achievements here.';
        break;
      default:
        description =
            'No competitions match your current search criteria. Try adjusting your filters or search terms.';
    }

    return Text(
      description,
      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
        color: AppTheme.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButton() {
    if (category.toLowerCase() == 'pending' ||
        category.toLowerCase() == 'completed') {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onCreateChallenge?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryOrange,
          foregroundColor: AppTheme.pureBlack,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: AppTheme.pureBlack,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Text(
              'Create First Challenge',
              style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.pureBlack,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.emoji_events_outlined) return 'emoji_events_outlined';
    if (icon == Icons.hourglass_empty) return 'hourglass_empty';
    if (icon == Icons.check_circle_outline) return 'check_circle_outline';
    if (icon == Icons.sports_mma_outlined) return 'sports_mma_outlined';
    if (icon == Icons.add) return 'add';
    return 'star';
  }
}
