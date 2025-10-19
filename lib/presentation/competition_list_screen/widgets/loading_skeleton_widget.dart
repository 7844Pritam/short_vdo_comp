import 'package:flutter/material.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoadingSkeletonWidget extends StatefulWidget {
  const LoadingSkeletonWidget({super.key});

  @override
  State<LoadingSkeletonWidget> createState() => _LoadingSkeletonWidgetState();
}

class _LoadingSkeletonWidgetState extends State<LoadingSkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: 5,
      itemBuilder: (context, index) => _buildSkeletonCard(),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonHeader(),
              SizedBox(height: 2.h),
              _buildSkeletonContent(),
              SizedBox(height: 2.h),
              _buildSkeletonFooter(),
              SizedBox(height: 2.h),
              _buildSkeletonButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonHeader() {
    return Row(
      children: [
        _buildSkeletonCircle(12.w),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonBox(30.w, 2.h),
              SizedBox(height: 1.h),
              _buildSkeletonBox(20.w, 1.5.h),
            ],
          ),
        ),
        _buildSkeletonBox(15.w, 3.h),
      ],
    );
  }

  Widget _buildSkeletonContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSkeletonBox(60.w, 1.5.h),
        SizedBox(height: 1.h),
        _buildSkeletonBox(40.w, 1.5.h),
      ],
    );
  }

  Widget _buildSkeletonFooter() {
    return Container(
      height: 1,
      color: AppTheme.borderGray.withValues(alpha: 0.3),
    );
  }

  Widget _buildSkeletonButton() {
    return _buildSkeletonBox(double.infinity, 6.h);
  }

  Widget _buildSkeletonBox(double width, double height) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color:
                AppTheme.borderGray.withValues(alpha: _animation.value * 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonCircle(double size) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color:
                AppTheme.borderGray.withValues(alpha: _animation.value * 0.3),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
