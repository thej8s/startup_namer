import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Startup Name Generator',
    theme: ThemeData(          // Add the 3 lines from here...
      primaryColor: Colors.red,
    ),
    home: RandomWords(),
  );
}
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}


class _RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];// NEW
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18); // NEW
  @override
  Widget build(BuildContext context) {


    return Scaffold (                     // Add from here...
      appBar: AppBar(
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText('Startup Name Generator',
                textStyle: TextStyle(fontFamily: 'KronaOne',
                  color: Colors.white,
                ),
              ),
            ],
            isRepeatingAnimation: true,
          ),
        actions: <Widget>[      // Add 3 lines from here...
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved) ],                      // ... to here.


      ),
      body: _buildSuggestions(),
    );                                      // ... to here.
  }

    Widget _buildSuggestions() {
      return ListView.builder(
          padding: const EdgeInsets.all(16),

          itemBuilder: (BuildContext _context, int i) {

            if (i.isOdd) {
              return Divider();
            }

            final int index = i ~/ 2;

            if (index >= _suggestions.length) {

              _suggestions.addAll(generateWordPairs().take(10));
            }
            return _buildRow(_suggestions[index]);
          }
      );
    }

    Widget _buildRow(WordPair pair) {
      final alreadySaved = _saved.contains(pair);
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: TextStyle(
          fontSize: 18,
          fontFamily: 'KronaOne')
        ),
        trailing: Icon(   // NEW from here...
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),                // ... to here.
        onTap: () {
          final player = AudioCache();
          player.play('button.wav'); // NEW lines from here...
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },               // ... to here.
      );
    }
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
                (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'KronaOne'),

              ),
              );
            },
          );
          final List<Widget> divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

          return Scaffold(         // Add 6 lines from here...
            appBar: AppBar(
                title: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Saved Suggestions',
                      textStyle: TextStyle(fontFamily: 'KronaOne',
                        color: Colors.white,
                      ),
                    )
                  ],
                  isRepeatingAnimation: true,
                )
            ),
            body: ListView(children: divided),
          );                       // ... to here.
        },
      ),
    );
  }
  }
