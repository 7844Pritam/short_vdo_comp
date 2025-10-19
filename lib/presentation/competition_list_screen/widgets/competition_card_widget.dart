import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompetitionCardWidget extends StatelessWidget {
  final Map<String, dynamic> competition;
  final VoidCallback? onTap;
  final VoidCallback? onSubmitResponse;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onViewResults;

  const CompetitionCardWidget({
    super.key,
    required this.competition,
    this.onTap,
    this.onSubmitResponse,
    this.onAccept,
    this.onDecline,
    this.onViewResults,
  });

  @override
  Widget build(BuildContext context) {
    final status = competition['status'] as String? ?? 'active';
    final category = competition['category'] as String? ?? 'Dance';
    final creatorName = competition['creatorName'] as String? ?? 'Unknown';
    final creatorAvatar = competition['creatorAvatar'] as String? ?? '';
    final creatorAvatarLabel =
        competition['creatorAvatarLabel'] as String? ?? 'Profile photo';
    final deadline = competition['deadline'] as String? ?? '';
    final participantCount = competition['participantCount'] as int? ?? 0;
    final prizePoints = competition['prizePoints'] as int? ?? 0;
    final winnerName = competition['winnerName'] as String? ?? '';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          onLongPress: () {
            HapticFeedback.mediumImpact();
            _showContextMenu(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(creatorAvatar, creatorAvatarLabel, creatorName, category, status),
                SizedBox(height: 2.h),
                _buildContent(deadline, participantCount, prizePoints, status, winnerName),
                SizedBox(height: 2.h),
                _buildFooter(),
                if (_shouldShowActionButtons(status)) ...[
                  SizedBox(height: 2.h),
                  _buildActionButtons(status),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String creatorAvatar, String creatorAvatarLabel, String creatorName, String category, String status) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: creatorAvatar,
              width: 12.w,
              height: 12.w,
              fit: BoxFit.cover,
              semanticLabel: creatorAvatarLabel,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                creatorName,
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              _buildCategoryBadge(category),
            ],
          ),
        ),
        _buildStatusIndicator(status),
      ],
    );
  }

  Widget _buildCategoryBadge(String category) {
    Color badgeColor;
    IconData badgeIcon;

    switch (category.toLowerCase()) {
      case 'dance':
        badgeColor = AppTheme.primaryOrange;
        badgeIcon = Icons.music_note;
        break;
      case 'singing':
        badgeColor = AppTheme.successGreen;
        badgeIcon = Icons.mic;
        break;
      case 'debate':
        badgeColor = AppTheme.warningOrange;
        badgeIcon = Icons.forum;
        break;
      default:
        badgeColor = AppTheme.primaryOrange;
        badgeIcon = Icons.star;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: _getIconName(badgeIcon),
            color: badgeColor,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            category,
            style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color statusColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'active':
        statusColor = AppTheme.successGreen;
        statusText = 'Active';
        break;
      case 'pending':
        statusColor = AppTheme.warningOrange;
        statusText = 'Pending';
        break;
      case 'completed':
        statusColor = AppTheme.textSecondary;
        statusText = 'Completed';
        break;
      default:
        statusColor = AppTheme.textSecondary;
        statusText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        statusText,
        style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContent(String deadline, int participantCount, int prizePoints, String status, String winnerName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (deadline.isNotEmpty) ...[
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.textSecondary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Deadline: $deadline',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
        ],
        Row(
          children: [
            CustomIconWidget(
              iconName: 'people',
              color: AppTheme.textSecondary,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text(
              '$participantCount participants',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(width: 4.w),
            CustomIconWidget(
              iconName: 'stars',
              color: AppTheme.primaryOrange,
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              '$prizePoints pts',
              style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.primaryOrange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        if (status.toLowerCase() == 'completed' && winnerName.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'emoji_events',
                color: AppTheme.primaryOrange,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Winner: $winnerName',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 1,
      color: AppTheme.borderGray.withValues(alpha: 0.3),
    );
  }

  bool _shouldShowActionButtons(String status) {
    return status.toLowerCase() == 'active' ||
        status.toLowerCase() == 'pending' ||
        status.toLowerCase() == 'completed';
  }

  Widget _buildActionButtons(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return _buildActiveButtons();
      case 'pending':
        return _buildPendingButtons();
      case 'completed':
        return _buildCompletedButtons();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildActiveButtons() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onSubmitResponse?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryOrange,
          foregroundColor: AppTheme.pureBlack,
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Submit Response',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPendingButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onDecline?.call();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorRed,
              side: BorderSide(color: AppTheme.errorRed, width: 1.5),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Decline',
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              onAccept?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen,
              foregroundColor: AppTheme.pureBlack,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Accept',
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedButtons() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          onViewResults?.call();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryOrange,
          side: BorderSide(color: AppTheme.primaryOrange, width: 1.5),
          padding: EdgeInsets.symmetric(vertical: 1.5.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'View Results',
          style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.elevatedSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              icon: Icons.share,
              title: 'Share Challenge',
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            _buildContextMenuItem(
              icon: Icons.person_add,
              title: 'Invite Friends',
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
            ),
            _buildContextMenuItem(
              icon: Icons.report,
              title: 'Report',
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              },
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: _getIconName(icon),
        color: isDestructive ? AppTheme.errorRed : AppTheme.textPrimary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          color: isDestructive ? AppTheme.errorRed : AppTheme.textPrimary,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String _getIconName(IconData icon) {
    if (icon == Icons.music_note) return 'music_note';
    if (icon == Icons.mic) return 'mic';
    if (icon == Icons.forum) return 'forum';
    if (icon == Icons.star) return 'star';
    if (icon == Icons.schedule) return 'schedule';
    if (icon == Icons.people) return 'people';
    if (icon == Icons.stars) return 'stars';
    if (icon == Icons.emoji_events) return 'emoji_events';
    if (icon == Icons.share) return 'share';
    if (icon == Icons.person_add) return 'person_add';
    if (icon == Icons.report) return 'report';
    return 'star';
  }
}