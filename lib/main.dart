import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme(
            Theme.of(context).textTheme,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLives;
  int enemysLives = maxLives;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5DEF0),
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
                maxLivesCount: maxLives,
                yourLivesCount: yourLives,
                enemysLivesCount: enemysLives,
            ),
            const Expanded(child: SizedBox()),
            ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDefendingBodyPart: _selectDefendingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            const SizedBox(height: 14,),
            GoButton(
                text: yourLives == 0 || enemysLives == 0 ? "start new game" : "Go",
                onTap: _onGoButtonClicked,
                color: _getGoButtonColor(),
            ),
            const SizedBox(height: 16,),
          ],
        ),
      ),
    );
  }
  Color _getGoButtonColor() {
    if(yourLives == 0 || enemysLives == 0){
      return const Color.fromRGBO(0, 0, 0, 0.87);
    }else if(attackingBodyPart == null || defendingBodyPart == null){
      return Colors.black38;
    }else{
      return const Color.fromRGBO(0, 0, 0, 0.87);
    }
  }
  void _onGoButtonClicked(){
    if(yourLives == 0 || enemysLives == 0){
      setState(() {
        yourLives = maxLives;
        enemysLives = maxLives;
      });
    }else if( attackingBodyPart != null && defendingBodyPart != null){
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;
        if(enemyLoseLife){
          enemysLives -= 1;
        }
        if(youLoseLife){
          yourLives -= 1;
        }
        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        attackingBodyPart = null;
        defendingBodyPart = null;
      });
    }
  }
  void _selectDefendingBodyPart(final BodyPart value){
    if(yourLives == 0 || enemysLives == 0){
      return;
    }else{
      setState(() {
        defendingBodyPart = value;
      });
    }
  }

  void _selectAttackingBodyPart(final BodyPart value){
    if(yourLives == 0 || enemysLives == 0){
      return;
    }else{
      setState(() {
        attackingBodyPart = value;
      });
    }
  }
}
class GoButton extends StatelessWidget{
  final String text;
  final VoidCallback onTap;
  final Color color;


  const GoButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FightersInfo extends StatelessWidget{
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;


  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemysLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          LivesWidget(
            overallLivesCount: maxLivesCount,
            currentLivesCount: yourLivesCount,
          ),
          Column(
            children: const [
              SizedBox(height: 16,),
              Text("You"),
              SizedBox(height: 12,),
              ColoredBox(
                color: Colors.red,
                child: SizedBox(height: 92, width: 92,),
              ),
            ],
          ),
          const ColoredBox(
            color: Colors.green,
            child: SizedBox(height: 44, width: 44,),
          ),
          Column(
            children: const [
              SizedBox(height: 16,),
              Text(
                "Enemy",
                style: TextStyle(
                  color: Color(0xFF161616)
                ),
              ),
              SizedBox(height: 12,),
              ColoredBox(
                color: Colors.blue,
                child: SizedBox(height: 92, width: 92,),
              ),
            ],
          ),
          LivesWidget(
            overallLivesCount: maxLivesCount,
            currentLivesCount: enemysLivesCount,
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
                      color: Color(0xFF161616)
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
                      color: Color(0xFF161616)
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(overallLivesCount, (index) {
        if(index < currentLivesCount){
          return Image.asset(FightClubIons.heartFull, width: 18, height: 18,);
        }else {
          return Image.asset(FightClubIons.heartEmpty, width: 18, height: 18,);
        }
      }),
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
      child: SizedBox(
        height: 40,
        child: ColoredBox(
          color: selected ? const Color(0xFF1C79CE) : Colors.black38,
          child: Center(
            child: Text(
              bodyPart.name.toUpperCase(),
              style: TextStyle(
                color: selected ? const Color(0xFFFFFFFF) : const Color(0xFF161616)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
