import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BattleHeader extends StatelessWidget {
  final String competitionTitle;
  final String category;
  final String timeRemaining;
  final int totalVotes;
  final VoidCallback? onBack;

  const BattleHeader({
    super.key,
    required this.competitionTitle,
    required this.category,
    required this.timeRemaining,
    required this.totalVotes,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 12.h, 4.w, 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.pureBlack.withValues(alpha: 0.9),
            AppTheme.pureBlack.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top row with back button and category
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onBack?.call();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.elevatedSurface.withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'arrow_back_ios',
                      color: AppTheme.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: AppTheme.darkTheme.textTheme.labelSmall
                            ?.copyWith(
                              color: AppTheme.pureBlack,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 40), // Balance the back button
              ],
            ),

            SizedBox(height: 3.h),

            // Competition title
            Text(
              competitionTitle,
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 2.h),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  icon: 'timer',
                  label: 'Time Left',
                  value: timeRemaining,
                  color: AppTheme.warningOrange,
                ),
                Container(width: 1, height: 40, color: AppTheme.borderGray),
                _buildStatItem(
                  icon: 'how_to_vote',
                  label: 'Total Votes',
                  value: _formatVoteCount(totalVotes),
                  color: AppTheme.primaryOrange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        CustomIconWidget(iconName: icon, color: color, size: 24),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatVoteCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
