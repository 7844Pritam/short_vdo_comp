import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DurationPickerWidget extends StatelessWidget {
  final String selectedDuration;
  final Function(String) onDurationChanged;

  const DurationPickerWidget({
    super.key,
    required this.selectedDuration,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> durations = [
      '24 hours',
      '2 days',
      '3 days',
      '5 days',
      '7 days',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Challenge Duration',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: AppTheme.elevatedSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderGray),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedDuration,
              isExpanded: true,
              dropdownColor: AppTheme.elevatedSurface,
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.textSecondary,
                size: 24,
              ),
              items: durations.map((String duration) {
                return DropdownMenuItem<String>(
                  value: duration,
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        color: duration == selectedDuration
                            ? AppTheme.primaryOrange
                            : AppTheme.textSecondary,
                        size: 20,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        duration,
                        style: AppTheme.darkTheme.textTheme.bodyMedium
                            ?.copyWith(
                              color: duration == selectedDuration
                                  ? AppTheme.primaryOrange
                                  : AppTheme.textPrimary,
                              fontWeight: duration == selectedDuration
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  HapticFeedback.lightImpact();
                  onDurationChanged(newValue);
                }
              },
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Participants will have this amount of time to submit their entries',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
