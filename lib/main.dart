//import 'dart:html';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String title = 'Mix and Match';
  static const Color dkOrange = Color(0xFFFF6D00);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF9D5900),
        appBar: AppBar(
            backgroundColor: const Color(0xFF9D5900),
            title: const Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Creepy',
                  fontSize: 30.0,
                  color: dkOrange,
                ),
              ),
            )),
        body: const CardGame(),
      ),
    );
  }
}

class CardGame extends StatefulWidget {
  const CardGame({Key? key}) : super(key: key);

  @override
  _CardGameState createState() => _CardGameState();
}

class _CardGameState extends State<CardGame> {
  late List<String> txtImages;
  /*
  0 == not visited
  1 == visited not matched
  2 == matched
   */
  List<int> visited = List.filled(16, 0);
  int numberFlips = 0, numberMatchedPairs = 0, numberFlipped = 0;
  static const Color dkLightOrange = Color(0xFFFFBB89);
  @override
  void initState() {
    super.initState();
    setupCards();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        infoRow(),
        Flexible(
          fit: FlexFit.tight,
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            padding: const EdgeInsets.all(10.0),
            children: cardList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: setupCards,
              child: const Text(
                'RESET',
                style: TextStyle(
                  fontFamily: 'Lunacy',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: dkLightOrange,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Row infoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Number of Flips: $numberFlips',
            style: const TextStyle(
              fontFamily: 'Lunacy',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: dkLightOrange,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Number of Pairs: $numberMatchedPairs',
            style: const TextStyle(
              fontFamily: 'Lunacy',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: dkLightOrange,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> cardList() {
    return List<Widget>.generate(16, (int i) {
      //return Builder(builder: (BuildContext context) {
      return Builder(builder: (BuildContext context) {
        return singleCardContainer(i);
      });
    });
  }

  GestureDetector singleCardContainer(int i) {
    return GestureDetector(
        onTap: () {
          flipFunction(i);
        },
        child: singleCard(i));
  }

  void matchingCards(int i) {
    return setState(() {
      if (visited[i] != 1) {
        return;
      }
      String card1 = txtImages[i];
      for (int idx = 0; idx < txtImages.length; idx++) {
        if (idx != i) {
          if (visited[idx] == 1 && txtImages[idx] == card1) {
            visited[i] = 2;
            visited[idx] = 2;
            numberMatchedPairs += 1;
            numberFlipped = 0;
          }
        }
      }
    });
  }

  void flipFunction(int i) {
    return setState(() {
      if (visited[i] == 0 && numberFlipped < 2) {
        visited[i] = 1;
        numberFlips += 1;
        numberFlipped += 1;
        matchingCards(i);
      } else if (visited[i] == 1) {
        visited[i] = 0;
        numberFlipped -= 1;
      }
    });
  }

  Image singleCard(int i) {
    if (visited[i] == 0) {
      return Image.asset('assets/images/CardBack.png');
    } else {
      return Image.asset('assets/images/' + txtImages[i] + '.png');
    }
  }

  void setupCards() {
    return setState(() {
      txtImages = [
        'Bat',
        'Bones',
        'Eye',
        'Bones',
        'Ghost',
        'Bat',
        'Cauldron',
        'Pumpkin',
        'Skull',
        'Dracula',
        'Eye',
        'Ghost',
        'Dracula',
        'Cauldron',
        'Pumpkin',
        'Skull'
      ];
      txtImages.shuffle();
      visited = List.filled(16, 0);
      numberFlips = 0;
      numberMatchedPairs = 0;
    });
  }
}
