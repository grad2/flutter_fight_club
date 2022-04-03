import 'package:flutter/material.dart';
import 'package:flutter_fight_club/pages/statistics_page.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/secondary_action_button.dart';
import 'fight_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key,}) : super(key: key);

  @override
  _MainPageContent createState() => _MainPageContent();
}
class _MainPageContent extends State<MainPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24,),
            Center(
              child: Text(
                "The\nFight\nClub".toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  color: FightClubColors.darkGreyText,
                ),
              ),
            ),
            const Expanded(child: SizedBox(),),
            FutureBuilder(
                future: SharedPreferences.getInstance().then(
                    (sharedPreferences) => sharedPreferences.getString("last_fight_result"),
                ),
                builder: (context, snapshot) {
                  if(!snapshot.hasData || snapshot.data == null){
                    return const SizedBox();
                  }
                  return Center(child: Text(snapshot.data.toString()),);
                }
            ),
            const Expanded(child: SizedBox()),
            SecondaryActionButton(
              text: "Statistics",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StatisticsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12,),
            ActionButton(
              text: "Start",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FightPage(),
                  ),
                );
              },
              color: FightClubColors.blackButton,
            ),
            const SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }
}

