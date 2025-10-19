import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserSearchModal extends StatefulWidget {
  final Function(String) onUserSelected;

  const UserSearchModal({super.key, required this.onUserSelected});

  @override
  State<UserSearchModal> createState() => _UserSearchModalState();
}

class _UserSearchModalState extends State<UserSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredUsers = [];

  final List<Map<String, dynamic>> _mockUsers = [
    {
      "id": 1,
      "username": "DanceQueen23",
      "name": "Sarah Johnson",
      "avatar": "https://images.unsplash.com/photo-1678567372775-849213018256",
      "semanticLabel":
          "Profile photo of a young woman with blonde hair and blue eyes, smiling at the camera",
      "followers": 15420,
      "isFollowing": true,
      "category": "Dance",
    },
    {
      "id": 2,
      "username": "VocalMaster",
      "name": "Michael Chen",
      "avatar": "https://images.unsplash.com/photo-1698072556534-40ec6e337311",
      "semanticLabel":
          "Professional headshot of an Asian man with short black hair wearing a navy blue shirt",
      "followers": 8930,
      "isFollowing": false,
      "category": "Singing",
    },
    {
      "id": 3,
      "username": "ComedyKing",
      "name": "Alex Rodriguez",
      "avatar": "https://images.unsplash.com/photo-1633625763717-045645e9e739",
      "semanticLabel":
          "Casual photo of a Hispanic man with a beard, wearing a red t-shirt and smiling broadly",
      "followers": 22100,
      "isFollowing": true,
      "category": "Comedy",
    },
    {
      "id": 4,
      "username": "DebateChamp",
      "name": "Emma Wilson",
      "avatar": "https://images.unsplash.com/photo-1658543825231-eea46743dd16",
      "semanticLabel":
          "Professional photo of a woman with brown hair in business attire, looking confident",
      "followers": 5670,
      "isFollowing": false,
      "category": "Debate",
    },
    {
      "id": 5,
      "username": "FreestylePro",
      "name": "Jordan Smith",
      "avatar": "https://images.unsplash.com/photo-1630963655804-2c9a7d8fde3b",
      "semanticLabel":
          "Street style photo of a young Black man wearing a baseball cap and hoodie",
      "followers": 18750,
      "isFollowing": true,
      "category": "Freestyle",
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredUsers = _mockUsers;
    _searchController.addListener(_filterUsers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _mockUsers.where((user) {
        final username = (user['username'] as String).toLowerCase();
        final name = (user['name'] as String).toLowerCase();
        return username.contains(query) || name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.borderGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Opponent',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.deepCharcoal,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderGray),
              ),
              child: TextField(
                controller: _searchController,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  prefixIcon: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
              ),
            ),
          ),

          // Users list
          Expanded(
            child: _filteredUsers.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    itemCount: _filteredUsers.length,
                    separatorBuilder: (context, index) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return _buildUserTile(user);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.textSecondary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No users found',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try searching with a different name',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onUserSelected(user['username'] as String);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.deepCharcoal,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderGray.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            // Avatar
            CustomImageWidget(
              imageUrl: user['avatar'] as String,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              semanticLabel: user['semanticLabel'] as String,
            ),
            SizedBox(width: 3.w),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'] as String,
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '@${user['username'] as String}',
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user['category'] as String,
                          style: AppTheme.darkTheme.textTheme.labelSmall
                              ?.copyWith(
                                color: AppTheme.primaryOrange,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${(user['followers'] as int) ~/ 1000}K followers',
                        style: AppTheme.darkTheme.textTheme.labelSmall
                            ?.copyWith(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Following status
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: (user['isFollowing'] as bool)
                    ? AppTheme.primaryOrange.withValues(alpha: 0.1)
                    : AppTheme.borderGray.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: (user['isFollowing'] as bool)
                      ? AppTheme.primaryOrange
                      : AppTheme.borderGray,
                ),
              ),
              child: Text(
                (user['isFollowing'] as bool) ? 'Following' : 'Follow',
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: (user['isFollowing'] as bool)
                      ? AppTheme.primaryOrange
                      : AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
