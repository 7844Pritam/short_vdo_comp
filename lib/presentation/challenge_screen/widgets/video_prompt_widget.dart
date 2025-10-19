import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoPromptWidget extends StatefulWidget {
  final XFile? selectedVideo;
  final Function(XFile?) onVideoSelected;

  const VideoPromptWidget({
    super.key,
    this.selectedVideo,
    required this.onVideoSelected,
  });

  @override
  State<VideoPromptWidget> createState() => _VideoPromptWidgetState();
}

class _VideoPromptWidgetState extends State<VideoPromptWidget> {
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isRecording = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first,
            )
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first,
            );

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      // Silent fail - camera not available
    }
  }

  Future<void> _recordVideo() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      if (_isRecording) {
        final XFile video = await _cameraController!.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });
        widget.onVideoSelected(video);
      } else {
        await _cameraController!.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _pickVideoFromGallery() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 1),
      );

      if (video != null) {
        widget.onVideoSelected(video);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Video Prompt (Optional)',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
            color: AppTheme.elevatedSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.selectedVideo != null
                  ? AppTheme.primaryOrange
                  : AppTheme.borderGray,
              width: widget.selectedVideo != null ? 2.0 : 1.0,
            ),
          ),
          child: widget.selectedVideo != null
              ? _buildVideoPreview()
              : _buildVideoUploadOptions(),
        ),
        SizedBox(height: 1.h),
        Text(
          'Add a reference video to show participants what you\'re looking for',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppTheme.deepCharcoal,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'play_circle_filled',
                    color: AppTheme.primaryOrange,
                    size: 48,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Video Selected',
                    style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onVideoSelected(null);
            },
            child: Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppTheme.pureBlack.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoUploadOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isCameraInitialized && _cameraController != null) ...[
          Container(
            width: 80.w,
            height: 15.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderGray),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CameraPreview(_cameraController!),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: _isRecording ? 'stop' : 'videocam',
                label: _isRecording ? 'Stop' : 'Record',
                onTap: _recordVideo,
                color: _isRecording
                    ? AppTheme.errorRed
                    : AppTheme.primaryOrange,
              ),
              _buildActionButton(
                icon: 'photo_library',
                label: 'Gallery',
                onTap: _pickVideoFromGallery,
                color: AppTheme.primaryOrange,
              ),
            ],
          ),
        ] else ...[
          CustomIconWidget(
            iconName: 'videocam_off',
            color: AppTheme.textSecondary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Camera not available',
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          _buildActionButton(
            icon: 'photo_library',
            label: 'Choose from Gallery',
            onTap: _pickVideoFromGallery,
            color: AppTheme.primaryOrange,
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(iconName: icon, color: color, size: 20),
            SizedBox(width: 2.w),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
