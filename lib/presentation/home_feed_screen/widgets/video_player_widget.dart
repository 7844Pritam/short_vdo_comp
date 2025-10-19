import 'package:flutter/material.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool isPlaying;
  final bool isMuted;
  final VoidCallback onDoubleTap;
  final VoidCallback onLongPress;
  final Function(bool) onPlayingChanged;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.isPlaying,
    required this.isMuted,
    required this.onDoubleTap,
    required this.onLongPress,
    required this.onPlayingChanged,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeAnimation;
  bool _showLikeAnimation = false;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _likeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _likeAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  void _triggerLikeAnimation() {
    setState(() {
      _showLikeAnimation = true;
    });
    _likeAnimationController.forward().then((_) {
      _likeAnimationController.reset();
      setState(() {
        _showLikeAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPlayingChanged(!widget.isPlaying);
      },
      onDoubleTap: () {
        _triggerLikeAnimation();
        widget.onDoubleTap();
      },
      onLongPress: widget.onLongPress,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.pureBlack,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video placeholder with thumbnail
            CustomImageWidget(
              imageUrl: widget.videoUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              semanticLabel: "Video thumbnail showing content preview",
            ),
            // Play/Pause overlay
            if (!widget.isPlaying)
              Center(
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppTheme.pureBlack.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: AppTheme.textPrimary,
                    size: 12.w,
                  ),
                ),
              ),
            // Like animation overlay
            if (_showLikeAnimation)
              Center(
                child: AnimatedBuilder(
                  animation: _likeAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _likeAnimation.value,
                      child: Opacity(
                        opacity: 1.0 - _likeAnimation.value,
                        child: CustomIconWidget(
                          iconName: 'favorite',
                          color: AppTheme.primaryOrange,
                          size: 25.w,
                        ),
                      ),
                    );
                  },
                ),
              ),
            // Video progress indicator
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 0.5.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppTheme.primaryOrange,
            AppTheme.primaryOrange.withValues(alpha: 0.3),
          ],
          stops: const [0.3, 1.0], // Simulated progress
        ),
      ),
    );
  }
}
