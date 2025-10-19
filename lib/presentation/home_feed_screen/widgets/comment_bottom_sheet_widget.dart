import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommentBottomSheetWidget extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final Function(String) onAddComment;

  const CommentBottomSheetWidget({
    super.key,
    required this.comments,
    required this.onAddComment,
  });

  @override
  State<CommentBottomSheetWidget> createState() =>
      _CommentBottomSheetWidgetState();
}

class _CommentBottomSheetWidgetState extends State<CommentBottomSheetWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildCommentsList(),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderGray,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Comments',
            style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${widget.comments.length}',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.textSecondary,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    if (widget.comments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'chat_bubble_outline',
              color: AppTheme.textSecondary,
              size: 15.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No comments yet',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Be the first to comment!',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      itemCount: widget.comments.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final comment = widget.comments[index];
        return _buildCommentItem(comment);
      },
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User avatar
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.borderGray,
              width: 1,
            ),
          ),
          child: ClipOval(
            child: CustomImageWidget(
              imageUrl: comment["userAvatar"] as String,
              width: 10.w,
              height: 10.w,
              fit: BoxFit.cover,
              semanticLabel: comment["userAvatarSemanticLabel"] as String,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        // Comment content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment["username"] as String,
                    style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    comment["timeAgo"] as String,
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                comment["text"] as String,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'favorite_border',
                          color: AppTheme.textSecondary,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${comment["likes"] as int}',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                    child: Text(
                      'Reply',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        border: Border(
          top: BorderSide(
            color: AppTheme.borderGray,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.elevatedSurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.borderGray,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    hintStyle:
                        AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            GestureDetector(
              onTap: () {
                if (_commentController.text.trim().isNotEmpty) {
                  HapticFeedback.lightImpact();
                  widget.onAddComment(_commentController.text.trim());
                  _commentController.clear();
                  _commentFocusNode.unfocus();
                }
              },
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: _commentController.text.trim().isNotEmpty
                      ? AppTheme.primaryOrange
                      : AppTheme.borderGray,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'send',
                  color: _commentController.text.trim().isNotEmpty
                      ? AppTheme.pureBlack
                      : AppTheme.textSecondary,
                  size: 5.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
