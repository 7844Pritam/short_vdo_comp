import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as emoji_picker;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

class ChallengeFormWidget extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const ChallengeFormWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  });

  @override
  State<ChallengeFormWidget> createState() => _ChallengeFormWidgetState();
}

class _ChallengeFormWidgetState extends State<ChallengeFormWidget> {
  bool _showEmojiPicker = false;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _onEmojiSelected(emoji_picker.Emoji emoji) {
    final currentText = widget.titleController.text;
    final selection = widget.titleController.selection;
    final newText = currentText.replaceRange(
      selection.start,
      selection.end,
      emoji.emoji,
    );

    widget.titleController.text = newText;
    widget.titleController.selection = TextSelection.collapsed(
      offset: selection.start + emoji.emoji.length,
    );

    widget.onTitleChanged(newText);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Challenge Title Field
        Text(
          'Challenge Title',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.elevatedSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _titleFocusNode.hasFocus
                  ? AppTheme.primaryOrange
                  : AppTheme.borderGray,
              width: _titleFocusNode.hasFocus ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.titleController,
                  focusNode: _titleFocusNode,
                  maxLength: 100,
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your challenge title...',
                    hintStyle: AppTheme.darkTheme.textTheme.bodyMedium
                        ?.copyWith(color: AppTheme.textSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    counterStyle: AppTheme.darkTheme.textTheme.bodySmall
                        ?.copyWith(color: AppTheme.textSecondary),
                  ),
                  onChanged: widget.onTitleChanged,
                ),
              ),
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _showEmojiPicker = !_showEmojiPicker;
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'emoji_emotions',
                  color: _showEmojiPicker
                      ? AppTheme.primaryOrange
                      : AppTheme.textSecondary,
                  size: 24,
                ),
              ),
            ],
          ),
        ),

        // Emoji Picker
        if (_showEmojiPicker) ...[
          SizedBox(height: 1.h),
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              color: AppTheme.elevatedSurface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderGray),
            ),
            child: emoji_picker.EmojiPicker(
              onEmojiSelected: (category, emoji) => _onEmojiSelected(emoji),
              config: emoji_picker.Config(
                height: 30.h,
                // bgColor: AppTheme.elevatedSurface,
                // indicatorColor: AppTheme.primaryOrange,
                // iconColor: AppTheme.textSecondary,
                // iconColorSelected: AppTheme.primaryOrange,
                // enableSkinTones: true,
                // initCategory: emoji_picker.Category.RECENT,
                // columns: 7,
                // emojiSizeMax: 32.0,
                // verticalSpacing: 0,
                // horizontalSpacing: 0,
                // skinToneDialogBgColor: AppTheme.elevatedSurface,
              ),
            ),
          ),
        ],

        SizedBox(height: 3.h),

        // Challenge Description Field
        Text(
          'Challenge Description',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.elevatedSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _descriptionFocusNode.hasFocus
                  ? AppTheme.primaryOrange
                  : AppTheme.borderGray,
              width: _descriptionFocusNode.hasFocus ? 2.0 : 1.0,
            ),
          ),
          child: TextField(
            controller: widget.descriptionController,
            focusNode: _descriptionFocusNode,
            maxLines: 4,
            maxLength: 500,
            style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText:
                  'Describe your challenge in detail. What should participants do? What are the rules?',
              hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              counterStyle: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            onChanged: widget.onDescriptionChanged,
          ),
        ),
      ],
    );
  }
}
