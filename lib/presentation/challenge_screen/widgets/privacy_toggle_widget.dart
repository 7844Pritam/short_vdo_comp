import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PrivacyToggleWidget extends StatelessWidget {
  final bool isPublic;
  final Function(bool) onPrivacyChanged;

  const PrivacyToggleWidget({
    super.key,
    required this.isPublic,
    required this.onPrivacyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Challenge Privacy',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onPrivacyChanged(true);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isPublic
                        ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                        : AppTheme.elevatedSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isPublic
                          ? AppTheme.primaryOrange
                          : AppTheme.borderGray,
                      width: isPublic ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'public',
                        color: isPublic
                            ? AppTheme.primaryOrange
                            : AppTheme.textSecondary,
                        size: 32,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Public',
                        style: AppTheme.darkTheme.textTheme.titleSmall
                            ?.copyWith(
                              color: isPublic
                                  ? AppTheme.primaryOrange
                                  : AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Anyone can join',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onPrivacyChanged(false);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: !isPublic
                        ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                        : AppTheme.elevatedSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: !isPublic
                          ? AppTheme.primaryOrange
                          : AppTheme.borderGray,
                      width: !isPublic ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'lock',
                        color: !isPublic
                            ? AppTheme.primaryOrange
                            : AppTheme.textSecondary,
                        size: 32,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Private',
                        style: AppTheme.darkTheme.textTheme.titleSmall
                            ?.copyWith(
                              color: !isPublic
                                  ? AppTheme.primaryOrange
                                  : AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Invite only',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
