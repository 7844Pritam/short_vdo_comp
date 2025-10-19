import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BattleBottomActions extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onComment;
  final VoidCallback? onReport;
  final int commentCount;
  final bool hasWinner;
  final String? winnerName;

  const BattleBottomActions({
    super.key,
    this.onShare,
    this.onComment,
    this.onReport,
    this.commentCount = 0,
    this.hasWinner = false,
    this.winnerName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            AppTheme.pureBlack.withValues(alpha: 0.9),
            AppTheme.pureBlack.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Winner announcement (if applicable)
            if (hasWinner && winnerName != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryOrange, AppTheme.accentOrange],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'emoji_events',
                      color: AppTheme.pureBlack,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        '$winnerName Wins!',
                        style: AppTheme.darkTheme.textTheme.titleMedium
                            ?.copyWith(
                              color: AppTheme.pureBlack,
                              fontWeight: FontWeight.w700,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
            ],

            // Action buttons row
            Row(
              children: [
                // Share button
                Expanded(
                  child: _buildActionButton(
                    icon: 'share',
                    label: 'Share',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onShare?.call();
                    },
                  ),
                ),

                SizedBox(width: 3.w),

                // Comment button
                Expanded(
                  child: _buildActionButton(
                    icon: 'chat_bubble_outline',
                    label: commentCount > 0
                        ? '$commentCount Comments'
                        : 'Comment',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onComment?.call();
                    },
                  ),
                ),

                SizedBox(width: 3.w),

                // Report button
                _buildIconButton(
                  icon: 'flag_outlined',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onReport?.call();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderGray, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.textPrimary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Flexible(
              child: Text(
                label,
                style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.elevatedSurface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderGray, width: 1),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ),
      ),
    );
  }
}
