import 'package:flutter/material.dart';
import 'package:short_video_comp/presentation/battle_screen/battle_screen.dart';
import 'package:short_video_comp/presentation/challenge_screen/challenge_screen.dart';
import 'package:short_video_comp/presentation/competition_list_screen/competition_list_screen.dart';
import 'package:short_video_comp/presentation/debate_detail_screen/debate_detail_screen.dart';
import 'package:short_video_comp/presentation/debate_list_screen/debate_list_screen.dart';
import 'package:short_video_comp/presentation/home_feed_screen/home_feed_screen.dart';


class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String debateDetail = '/debate-detail-screen';
  static const String challenge = '/challenge-screen';
  static const String competitionList = '/competition-list-screen';
  static const String debateList = '/debate-list-screen';
  static const String battle = '/battle-screen';
  static const String homeFeed = '/home-feed-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeFeedScreen(),
    debateDetail: (context) => const DebateDetailScreen(),
    challenge: (context) => const ChallengeScreen(),
    competitionList: (context) => const CompetitionListScreen(),
    debateList: (context) => const DebateListScreen(),
    battle: (context) => const BattleScreen(),
    homeFeed: (context) => const HomeFeedScreen(),
    // TODO: Add your other routes here
  };
}
