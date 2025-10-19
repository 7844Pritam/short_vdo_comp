import 'package:flutter/material.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BattleVsDivider extends StatefulWidget {
  final String battleStatus;
  final bool isActive;

  const BattleVsDivider({
    super.key,
    required this.battleStatus,
    this.isActive = true,
  });

  @override
  State<BattleVsDivider> createState() => _BattleVsDividerState();
}

class _BattleVsDividerState extends State<BattleVsDivider>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (widget.isActive) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      child: Stack(
        children: [
          // Background line
          Positioned.fill(
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryOrange.withValues(alpha: 0.3),
                    AppTheme.primaryOrange,
                    AppTheme.primaryOrange.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),

          // VS indicator in center
          Positioned(
            top: 50.h - 30, // Center vertically
            left: -25,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isActive ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryOrange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.4),
                          blurRadius: widget.isActive ? 12 : 8,
                          spreadRadius: widget.isActive ? 2 : 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'VS',
                        style: AppTheme.darkTheme.textTheme.titleSmall
                            ?.copyWith(
                              color: AppTheme.pureBlack,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Battle status indicator
          Positioned(
            top: 50.h + 40,
            left: -30,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _getStatusColor().withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getStatusColor(), width: 1),
              ),
              child: Text(
                widget.battleStatus.toUpperCase(),
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (widget.battleStatus.toLowerCase()) {
      case 'live':
      case 'active':
        return AppTheme.successGreen;
      case 'ending soon':
      case 'final hours':
        return AppTheme.warningOrange;
      case 'ended':
      case 'completed':
        return AppTheme.textSecondary;
      default:
        return AppTheme.primaryOrange;
    }
  }
}
