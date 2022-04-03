import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/secondary_action_button.dart';
import 'fight_page.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key,}) : super(key: key);

  @override
  _StatisticsPageContent createState() => _StatisticsPageContent();
}

class _StatisticsPageContent extends State<StatisticsPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 24),
              alignment: Alignment.center,
              child: const Text(
                "Statistics",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SecondaryActionButton(
                text: "Back",
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

