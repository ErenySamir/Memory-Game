import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GameModel.dart';

class GameMemory extends StatefulWidget {
  @override
  State<GameMemory> createState() {
    return GameMemoryState();
  }
}

class GameMemoryState extends State<GameMemory> {
  List<GameModel> gameModel = [
    GameModel(imagename: 'assets/images/circle.png', show: false),
    GameModel(imagename: 'assets/images/star.png', show: false),
    GameModel(imagename: 'assets/images/triangle.png', show: false),
    GameModel(imagename: 'assets/images/Square.png', show: false),
    GameModel(imagename: 'assets/images/pentagonal.png', show: false),
    GameModel(imagename: 'assets/images/rectangular.png', show: false),
    //repeat 6 image
    GameModel(imagename: 'assets/images/rectangular.png', show: false),
    GameModel(imagename: 'assets/images/circle.png', show: false),
    GameModel(imagename: 'assets/images/pentagonal.png', show: false),
    GameModel(imagename: 'assets/images/star.png', show: false),
    GameModel(imagename: 'assets/images/triangle.png', show: false),
    GameModel(imagename: 'assets/images/Square.png', show: false),

  ];
//array openedCards is declared to keep track of the cards that have been opened by the player.
  List<GameModel> openedCards = [];
  //declared to count the number of pairs of cards that have been matched.
  int matchedPairs = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: Text('Memory Game'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // number of items in each row
          mainAxisSpacing: 14.0, // spacing between rows
          crossAxisSpacing: 12.0, // spacing between columns
        ),
        padding: EdgeInsets.all(10.0), // padding around the grid
        itemCount: gameModel.length, // total number of items
        itemBuilder: (BuildContext context, int index) {
          //GestureDetector widget is used to add interactivity to each card.
          return GestureDetector(
            onTap: () {
              //في حاله بدايه اللعبه قبل ما ابدا
              if (!gameModel[index].show! &&
                  openedCards.length < 2 &&
                  !openedCards.contains(gameModel[index])) {
                //اول ما ابدا العب ويظهر الصور
                setState(() {
                  gameModel[index].show = true;
                  openedCards.add(gameModel[index]);
//في حاله اني دست علي صورتيين ورا بعض بيدخل جوه if
                  if (openedCards.length == 2) {
                    //kol 2 بعتبر اني ببدا بصغر وواحد
                    if (openedCards[0].imagename ==
                        openedCards[1].imagename) {
                      //هيزود ويسييب المتشابهيين ظاهريين
                      // Matched
                      matchedPairs++;
                      // All pairs are matched, game completed
                      //كل الصور اتجمعت المتشابهه وخلصو
                      if (matchedPairs == gameModel.length ~/ 2) {
                        _showDialog('Congratulations!', 'You won the game.');
                      }
                      openedCards.clear();
                    } else {
                      // Not matched
                      //هخلي الصوره لو مش متشابهه تتعرض لثانيه بس
                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          openedCards.forEach((element) {
                            element.show = false;
                          });
                          openedCards.clear();
                        });
                      });
                    }
                  }
                });
              }
            },
            //الجزء الخاص بعرض الصوره
            child: Card(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (gameModel[index].show!)
                    Image.asset(gameModel[index].imagename!)
                  else
                    Image.asset('assets/images/think.png'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
//Dialog يتعرض اول ما اهلص اللعب اني كسبت ويظهر اني العب تاني
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Reset the game
                setState(() {
                  gameModel.forEach((element) {
                    element.show = false;
                  });
                  openedCards.clear();
                  matchedPairs = 0;
                });
                Navigator.of(context).pop();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
}