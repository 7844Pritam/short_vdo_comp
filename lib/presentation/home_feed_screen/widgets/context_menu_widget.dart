import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContextMenuWidget extends StatelessWidget {
  final VoidCallback onNotInterested;
  final VoidCallback onReport;
  final VoidCallback onSave;
  final VoidCallback onClose;

  const ContextMenuWidget({
    super.key,
    required this.onNotInterested,
    required this.onReport,
    required this.onSave,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: AppTheme.overlayColor,
        child: Center(
          child: Container(
            width: 80.w,
            decoration: BoxDecoration(
              color: AppTheme.elevatedSurface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem(
                  icon: 'visibility_off',
                  title: 'Not Interested',
                  subtitle: 'See fewer videos like this',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onNotInterested();
                    onClose();
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: 'report',
                  title: 'Report',
                  subtitle: 'Report inappropriate content',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onReport();
                    onClose();
                  },
                  isDestructive: true,
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: 'bookmark_border',
                  title: 'Save Video',
                  subtitle: 'Add to your saved collection',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onSave();
                    onClose();
                  },
                ),
                SizedBox(height: 2.h),
                _buildCancelButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppTheme.errorRed.withValues(alpha: 0.1)
                    : AppTheme.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color:
                    isDestructive ? AppTheme.errorRed : AppTheme.primaryOrange,
                size: 6.w,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      color: isDestructive
                          ? AppTheme.errorRed
                          : AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.textSecondary,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.5,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      color: AppTheme.borderGray,
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onClose();
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          color: AppTheme.borderGray.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Cancel',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
