import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ResponseThumbnailsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> responses;
  final int selectedIndex;
  final Function(int) onResponseSelected;

  const ResponseThumbnailsWidget({
    super.key,
    required this.responses,
    required this.selectedIndex,
    required this.onResponseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: responses.length,
        separatorBuilder: (context, index) => SizedBox(width: 3.w),
        itemBuilder: (context, index) {
          final response = responses[index];
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onResponseSelected(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 20.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isSelected ? AppTheme.primaryOrange : AppTheme.borderGray,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(7),
                      ),
                      child: Stack(
                        children: [
                          CustomImageWidget(
                            imageUrl: response["thumbnail"] as String,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            semanticLabel:
                                response["thumbnailSemanticLabel"] as String,
                          ),

                          // Play indicator
                          Center(
                            child: Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.pureBlack.withValues(alpha: 0.7),
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'play_arrow',
                                color: AppTheme.textPrimary,
                                size: 4.w,
                              ),
                            ),
                          ),

                          // Duration badge
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 1.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.pureBlack.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                response["duration"] as String,
                                style: AppTheme.darkTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontSize: 8.sp,
                                ),
                              ),
                            ),
                          ),

                          // Selection indicator
                          if (isSelected)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                width: 4.w,
                                height: 4.w,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryOrange,
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.pureBlack,
                                  size: 2.5.w,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Creator info
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                          : AppTheme.elevatedSurface,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(7),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          response["creatorName"] as String,
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: isSelected
                                ? AppTheme.primaryOrange
                                : AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 9.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'thumb_up',
                              color: AppTheme.textSecondary,
                              size: 2.5.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              response["voteCount"].toString(),
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.textSecondary,
                                fontSize: 8.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
