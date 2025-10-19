import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OpponentSelectionWidget extends StatelessWidget {
  final String? selectedOpponent;
  final Function() onSelectOpponent;

  const OpponentSelectionWidget({
    super.key,
    this.selectedOpponent,
    required this.onSelectOpponent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Opponent',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onSelectOpponent();
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppTheme.elevatedSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedOpponent != null
                    ? AppTheme.primaryOrange
                    : AppTheme.borderGray,
                width: selectedOpponent != null ? 2.0 : 1.0,
              ),
            ),
            child: selectedOpponent != null
                ? _buildSelectedOpponent()
                : _buildSelectOpponentPrompt(),
          ),
        ),
        if (selectedOpponent == null) ...[
          SizedBox(height: 1.h),
          Text(
            'Choose a specific opponent or leave empty for open challenge',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectedOpponent() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.primaryOrange,
          child: Text(
            selectedOpponent![0].toUpperCase(),
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.pureBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                selectedOpponent!,
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Selected opponent',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        CustomIconWidget(
          iconName: 'edit',
          color: AppTheme.primaryOrange,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildSelectOpponentPrompt() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.borderGray,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: 'person_add',
            color: AppTheme.textSecondary,
            size: 20,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Opponent',
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Tap to choose from your followers',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: AppTheme.textSecondary,
          size: 16,
        ),
      ],
    );
  }
}
