import 'package:flutter/material.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChallengePreviewWidget extends StatelessWidget {
  final String title;
  final String description;
  final String category;
  final String duration;
  final bool isPublic;
  final String? opponent;
  final double prizePoints;
  final bool hasVideo;

  const ChallengePreviewWidget({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.isPublic,
    this.opponent,
    required this.prizePoints,
    required this.hasVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'preview',
                color: AppTheme.primaryOrange,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Challenge Preview',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Title
          if (title.isNotEmpty) ...[
            _buildPreviewItem(icon: 'title', label: 'Title', value: title),
            SizedBox(height: 1.5.h),
          ],

          // Category
          _buildPreviewItem(
            icon: 'category',
            label: 'Category',
            value: category,
          ),
          SizedBox(height: 1.5.h),

          // Duration
          _buildPreviewItem(
            icon: 'schedule',
            label: 'Duration',
            value: duration,
          ),
          SizedBox(height: 1.5.h),

          // Privacy
          _buildPreviewItem(
            icon: isPublic ? 'public' : 'lock',
            label: 'Privacy',
            value: isPublic ? 'Public Challenge' : 'Private Challenge',
          ),

          // Opponent
          if (opponent != null) ...[
            SizedBox(height: 1.5.h),
            _buildPreviewItem(
              icon: 'person',
              label: 'Opponent',
              value: opponent!,
            ),
          ],

          SizedBox(height: 1.5.h),

          // Prize Points
          _buildPreviewItem(
            icon: 'stars',
            label: 'Prize Points',
            value: '${prizePoints.toInt()} points',
          ),

          // Video Prompt
          if (hasVideo) ...[
            SizedBox(height: 1.5.h),
            _buildPreviewItem(
              icon: 'videocam',
              label: 'Video Prompt',
              value: 'Reference video included',
            ),
          ],

          // Description
          if (description.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'description',
                  color: AppTheme.textSecondary,
                  size: 16,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: AppTheme.darkTheme.textTheme.labelMedium
                            ?.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        description,
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.textSecondary,
          size: 16,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
