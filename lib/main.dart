//import 'dart:html';

import 'package:flutter/material.dart';

const Color dkOrange = Color(0xFFFF6D00);
const Color backgroundOrange = Color(0xFF9D5900);
const Color dkLightOrange = Color(0xFFFFBB89);

const darkTitleStyle = TextStyle(
  fontFamily: 'Creepy',
  fontSize: 30.0,
  color: dkOrange,
);

const lightTitleStyle = TextStyle(
  fontFamily: 'Lunacy',
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  color: dkLightOrange,
);

const bodyTextStyle = TextStyle(
  fontFamily: 'Lunacy',
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: dkLightOrange,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String title = 'Mix and Match';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundOrange,
        appBar: AppBar(
            backgroundColor: backgroundOrange,
            title: const Center(
              child: Text(
                title,
                style: darkTitleStyle,
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
  late List<String> cardFaces;
  /*
  0 == not visited
  1 == visited not matched
  2 == matched
   */
  List<int> visitedCardsList = List.filled(16, 0);
  int numberFlips = 0, numberMatchedPairs = 0, numberFlipped = 0;

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
                style: lightTitleStyle,
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
            style: bodyTextStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Number of Pairs: $numberMatchedPairs',
            style: bodyTextStyle,
          ),
        ),
      ],
    );
  }

  List<Widget> cardList() {
    return List<Widget>.generate(16, (int cardIndex) {
      //return Builder(builder: (BuildContext context) {
      return Builder(builder: (BuildContext context) {
        return singleCardContainer(cardIndex);
      });
    });
  }

  GestureDetector singleCardContainer(int cardIndex) {
    return GestureDetector(
        onTap: () {
          flipFunction(cardIndex);
        },
        child: singleCard(cardIndex));
  }

  void matchingCards(int selectedCardIndex) {
    return setState(() {
      if (visitedCardsList[selectedCardIndex] != 1) {
        return;
      }
      String selectedCard = cardFaces[selectedCardIndex];

      for (int i = 0; i < cardFaces.length; i++) {
        if (i != selectedCardIndex) {
          if (visitedCardsList[i] == 1 && cardFaces[i] == selectedCard) {
            visitedCardsList[selectedCardIndex] = 2;
            visitedCardsList[i] = 2;
            numberMatchedPairs += 1;
            numberFlipped = 0;
          }
        }
      }
    });
  }

  void flipFunction(int cardToFlip) {
    return setState(() {
      if (visitedCardsList[cardToFlip] == 0 && numberFlipped < 2) {
        visitedCardsList[cardToFlip] = 1;
        numberFlips += 1;
        numberFlipped += 1;
        matchingCards(cardToFlip);
      } else if (visitedCardsList[cardToFlip] == 1) {
        visitedCardsList[cardToFlip] = 0;
        numberFlipped -= 1;
      }
    });
  }

  Image singleCard(int cardIndex) {
    if (visitedCardsList[cardIndex] == 0) {
      return Image.asset('assets/images/CardBack.png');
    } else {
      return Image.asset('assets/images/' + cardFaces[cardIndex] + '.png');
    }
  }

  void setupCards() {
    return setState(() {
      cardFaces = [
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
      cardFaces.shuffle();
      visitedCardsList = List.filled(16, 0);
      numberFlips = 0;
      numberMatchedPairs = 0;
    });
  }
}
