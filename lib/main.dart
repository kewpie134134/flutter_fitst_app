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
    // マテリアルデザインでのアプリを作成するための宣言
    return MaterialApp(
      // 右上のデバッグラベルを非表示にする
      debugShowCheckedModeBanner: false,
      title: 'Startup Name Generator',
      // Scaffold ウィジェットは、アプリケーションバーやタイトル、ホーム画面のウィジェットツリーを、
      // 保持する body プロパティを提供している
      // ただし、ウィジェットのサブツリーはかなり複雑になる可能性がある
      home: RandomWords(),
    );
  }
}

// 最小の状態保持クラスを作成する (StatefulWidget の中身部分)
// State<RondomWords> と書くことで、汎用の State クラスのジェネリクスに RandomWords を記載し、
// RandomWords ウィジェットの状態を維持できるようにする
class _RandomWordsState extends State<RandomWords> {
  // 変数やメソッド名の前につけるアンダースコア (_) は Private を意味し、
  // クラス内からしかアクセスはできない

  // 単語を保存するためのリスト
  final _suggestions = <WordPair>[];
  // フォントサイズを指定するためのインスタンス
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      // _buildSuggestions 関数を呼び出す
      body: _buildSuggestions(),
    );
  }

  // 本メソッドで ListView を作成する
  Widget _buildSuggestions() {
    // ListView クラスの builder にある itemBuilder には無名関数を定義する
    // 引数として BuildContext と行番号 (i) が渡される
    // i は 0 から始まり、呼び出されるたびに加算される
    // （今回の構成ではユーザーがスクロールする食べにリストが無限に増加する）
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // itemBuilder で一行ごとに処理が呼ばれ、偶数業の場合に ListTile を表示し、
      // 奇数行の時に Divider を表示する
      // itemBuilder はコールバック関数で、関数が呼び出されるたびにイテレータ (i) が1 ずつ増加する
      itemBuilder: (BuildContext _context, int i) {
        // 1 ピクセルの高さの仕切りを ListView に追加していく
        if (i.isOdd) return Divider();

        // 行数を 2 で割った時の整数値を求める
        // これにより、Divider で線を入れた行を除いた状態の英文数を計算する
        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          // 利用可能な英文リスト数を超えた場合は、さらに 10 個の英文を生成し、リストに追加
          _suggestions.addAll(generateWordPairs().take(10));
        }
        // 最後に現在の行で表示する英文をリストから取得し、_buildRow メソッドで表示用に整形
        return _buildRow(_suggestions[index]);
      },
    );
  }

  // _buildRow メソッド
  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
}

// RandomWords ウィジェットを、StatefulWidget を継承することで作成する
// (State クラスのインスタンスを作成するStatefulWidget クラスで、これ自体はステートレス)
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => new _RandomWordsState();
}
