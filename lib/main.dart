import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // StatelessWidget を継承するkとでアプリ自体が Widget になる
  @override
  // build() メソッドでウィジェットの UI を作成する
  Widget build(BuildContext context) {
    // 表示される文字列をランダムな英語に変更する
    final wordPair = WordPair.random();

    // マテリアルデザインでのアプリを作成するための宣言
    return MaterialApp(
      // 右上のデバッグラベルを非表示にする
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      // Scaffold ウィジェットは、アプリケーションバーやタイトル、ホーム画面のウィジェットツリーを、
      // 保持する body プロパティを提供している
      // ただし、ウィジェットのサブツリーはかなり複雑になる可能性がある
      home: Scaffold(
          // appBar は Widget のヘッダーに表示するアプリケーションバーを表現することができる
          appBar: AppBar(title: Text('Welcome to Flutter')),
          // body では様々な表現が可能で、今回は Center で中央配置、Text で文字列を配置している
          body: Center(
            // StatefulWidget を利用して文字列を表示する
            child: RandomWords(),
          )),
    );
  }
}

// 最小の状態保持クラスを作成する (StatefulWidget の中身部分)
// State<RondomWords> と書くことで、汎用の State クラスのジェネリクスに RandomWords を記載し、
// RandomWords ウィジェットの状態を維持できるようにする
class RandomWordsState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return Text(wordPair.asPascalCase);
  }
}

// RandomWords ウィジェットを、StatefulWidget を継承することで作成する
// (State クラスのインスタンスを作成する、StatefulWidget クラス)
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
