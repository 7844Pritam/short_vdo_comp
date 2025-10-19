import 'package:flutter/material.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DebateTopicHeaderWidget extends StatelessWidget {
  final String topicTitle;
  final int participantCount;
  final int responseCount;
  final DateTime votingDeadline;

  const DebateTopicHeaderWidget({
    super.key,
    required this.topicTitle,
    required this.participantCount,
    required this.responseCount,
    required this.votingDeadline,
  });

  String _getTimeRemaining() {
    final now = DateTime.now();
    final difference = votingDeadline.difference(now);

    if (difference.isNegative) {
      return 'Voting Ended';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m left';
    } else {
      return '${difference.inMinutes}m left';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topicTitle,
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: 'people',
                  label: 'Participants',
                  value: participantCount.toString(),
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.borderGray,
              ),
              Expanded(
                child: _buildStatItem(
                  icon: 'chat_bubble_outline',
                  label: 'Responses',
                  value: responseCount.toString(),
                ),
              ),
              Container(
                width: 1,
                height: 4.h,
                color: AppTheme.borderGray,
              ),
              Expanded(
                child: _buildStatItem(
                  icon: 'schedule',
                  label: 'Time Left',
                  value: _getTimeRemaining(),
                  isDeadline: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
    bool isDeadline = false,
  }) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: isDeadline ? AppTheme.primaryOrange : AppTheme.textSecondary,
          size: 5.w,
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
            color: isDeadline ? AppTheme.primaryOrange : AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
