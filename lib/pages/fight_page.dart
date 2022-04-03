import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/fight_club_colors.dart';
import '../resources/fight_club_icons.dart';
import '../resources/fight_club_images.dart';
import '../widgets/action_button.dart';

class FightPage extends StatefulWidget{
  const FightPage({Key? key}) : super(key: key);

  @override
  FightPageState createState() => FightPageState();

}

class FightPageState extends State<FightPage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLives;
  int enemyLives = maxLives;

  String textLog = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
              maxLivesCount: maxLives,
              yourLivesCount: yourLives,
              enemyLivesCount: enemyLives,
            ),
            const SizedBox(height: 30,),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                color: const Color(0xFFC5D1EA),
                alignment: Alignment.center,
                child: Text(
                  textLog,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: FightClubColors.darkGreyText,
                      fontSize: 10,
                      height: 20 / 10
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            ControlsWidget(
              defendingBodyPart: defendingBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
              attackingBodyPart: attackingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            const SizedBox(height: 14,),
            ActionButton(
              text: yourLives == 0 || enemyLives == 0 ? "Back" : "Go",
              onTap: _onGoButtonClicked,
              color: _getGoButtonColor(),
            ),
            const SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }
  String _getTextLog(){
    if(yourLives == 0 && enemyLives == 0){
      return "Draw";
    }
    if(enemyLives == 0){
      return "You won";
    }
    if(yourLives == 0){
      return "You lost";
    }
    String twoText = "";
    if(attackingBodyPart != whatEnemyDefends){
      twoText = "You hit enemy’s ${whatEnemyDefends.name}.\n";
    }else{
      twoText = "Your attack was blocked.\n";
    }
    if(defendingBodyPart != whatEnemyAttacks){
      return twoText + "Enemy hit your ${attackingBodyPart?.name}.";
    }else{
      return twoText + "Enemy’s attack was blocked.";
    }
  }

  Color _getGoButtonColor() {
    if(yourLives == 0 || enemyLives == 0){
      return FightClubColors.blackButton;
    }else if(attackingBodyPart == null || defendingBodyPart == null){
      return FightClubColors.greyButton;
    }else{
      return FightClubColors.blackButton;
    }
  }
  void _onGoButtonClicked(){
    if(yourLives == 0 || enemyLives == 0){
      Navigator.of(context).pop();
    }else if (attackingBodyPart != null && defendingBodyPart != null){
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
        if(enemyLoseLife){
          enemyLives -= 1;
        }
        if(youLoseLife){
          yourLives -= 1;
        }
        final FightResult? fightResult = FightResult.calculateResult(yourLives, enemyLives);
        if (fightResult != null){
          SharedPreferences.getInstance().then((value) {
            value.setString("last_fight_result", fightResult.result);
          });
        }
        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();
        textLog = _getTextLog();
        attackingBodyPart = null;
        defendingBodyPart = null;
      });
    }
  }

  void _selectDefendingBodyPart(final BodyPart value){
    if(yourLives == 0 || enemyLives == 0){
      return;
    }else{
      setState(() {
        defendingBodyPart = value;
      });
    }
  }

  void _selectAttackingBodyPart(final BodyPart value){
    if(yourLives == 0 || enemyLives == 0){
      return;
    }else{
      setState(() {
        attackingBodyPart = value;
      });
    }
  }
}

class FightersInfo extends StatelessWidget{
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemyLivesCount;


  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemyLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Expanded(
                child: ColoredBox(
                  color: FightClubColors.white,
                ),
              ),
              Expanded(
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, FightClubColors.darkPurple],
                        ),
                    ),
                ),
              ),
              Expanded(
                child: ColoredBox(
                  color: FightClubColors.darkPurple,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: yourLivesCount,
              ),
              Column(
                children:  [
                  const SizedBox(height: 16,),
                  const Text("You",
                    style: TextStyle(
                        color: FightClubColors.darkGreyText
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Image.asset(FightClubImages.youAvatar, width: 92, height: 92,),
                ],
              ),
              Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: FightClubColors.blackButton,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "vs",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 16,),
                  const Text(
                    "Enemy",
                    style: TextStyle(
                        color: FightClubColors.darkGreyText,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Image.asset(FightClubImages.enemyAvatar, width: 92, height: 92,),
                ],
              ),
              LivesWidget(
                overallLivesCount: maxLivesCount,
                currentLivesCount: enemyLivesCount,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ControlsWidget extends StatelessWidget{
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;

  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;


  const ControlsWidget({
    Key? key,
    required this.defendingBodyPart,
    required this.selectDefendingBodyPart,
    required this.attackingBodyPart,
    required this.selectAttackingBodyPart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 16,),
          Expanded(
              child: Column(
                children: [
                  Text(
                    "Defend".toUpperCase(),
                    style: const TextStyle(
                        color: FightClubColors.darkGreyText
                    ),
                  ),
                  const SizedBox(height: 13,),
                  BodyPartButton(
                    bodyPart: BodyPart.head,
                    selected: defendingBodyPart == BodyPart.head,
                    bodyPartSetter: selectDefendingBodyPart,
                  ),
                  const SizedBox(height: 14,),
                  BodyPartButton(
                    bodyPart: BodyPart.torso,
                    selected: defendingBodyPart == BodyPart.torso,
                    bodyPartSetter: selectDefendingBodyPart,
                  ),
                  const SizedBox(height: 14,),
                  BodyPartButton(
                    bodyPart: BodyPart.legs,
                    selected: defendingBodyPart == BodyPart.legs,
                    bodyPartSetter: selectDefendingBodyPart,
                  ),
                ],
              )
          ),
          const SizedBox(width: 12,),
          Expanded(
              child: Column(
                children: [
                  Text("Attack".toUpperCase(),
                    style: const TextStyle(
                        color: FightClubColors.darkGreyText
                    ),
                  ),
                  const SizedBox(height: 13,),
                  BodyPartButton(
                    bodyPart: BodyPart.head,
                    selected: attackingBodyPart == BodyPart.head,
                    bodyPartSetter: selectAttackingBodyPart,
                  ),
                  const SizedBox(height: 14,),
                  BodyPartButton(
                    bodyPart: BodyPart.torso,
                    selected: attackingBodyPart == BodyPart.torso,
                    bodyPartSetter: selectAttackingBodyPart,
                  ),
                  const SizedBox(height: 14,),
                  BodyPartButton(
                    bodyPart: BodyPart.legs,
                    selected: attackingBodyPart == BodyPart.legs,
                    bodyPartSetter: selectAttackingBodyPart,
                  ),
                ],
              )
          ),
          const SizedBox(width: 16,),
        ]
    );
  }
}

class LivesWidget extends StatelessWidget{
  final int overallLivesCount;
  final int currentLivesCount;


  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 106,
      width: 16,
      child: ListView.separated(
        itemBuilder: (_, index) {
          if(index < currentLivesCount){
            return Image.asset(FightClubIons.heartFull, width: 18, height: 18,);
          }else {
            return Image.asset(FightClubIons.heartEmpty, width: 18, height: 18,);
          }
        },
        separatorBuilder: (_, index){ return const SizedBox(height: 4,width: 0,);},
        itemCount: overallLivesCount,
      ),
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPartButton extends StatelessWidget{
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: Container(
        height: 40,
        color: selected ? FightClubColors.blueButton : FightClubColors.greyButton,
        alignment: Alignment.center,
        child: Text(
          bodyPart.name.toUpperCase(),
          style: TextStyle(
              color: selected ? FightClubColors.whiteText : FightClubColors.darkGreyText
          ),
        ),
      ),
    );
  }
}