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
      // アプリテーマは ThemeData クラスを設定することで変更可能
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
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
  // お気に入りに追加した単語のペアを保存する（Set を使用して、重複を許さないようにする）
  final _saved = <WordPair>{};
  // フォントサイズを指定するためのインスタンス
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        // アイコンと、それに対応するアクションを build メソッドに追加する
        // AppBar にリストアイコンを追加し、本アイコンをクリックすると保存したお気に入りを
        // 含む新しいルートが Navigator にプッシュされ、アイコンが表示される
        // action などのプロパティは、角括弧 ([]) でウィジェットの配列（children）を受け取る
        actions: [IconButton(onPressed: _pushSaved, icon: Icon(Icons.list))],
      ),
      // _buildSuggestions 関数を呼び出す
      body: _buildSuggestions(),
    );
  }

  // appBar のアイコンを選択した際の挙動を記述
  /*
   * ルートを作成して、Navigator のスタックにプッシュする
   * この操作により、新しいルートを表示するように画面が変わる
   * 新しいページのコンテンツは、匿名関数の MaterialPageRoute の builder プロパティに作成される
   */
  void _pushSaved() {
    // Navigator.push を呼び出すと、ルートがナビゲーターのスタックにプッシュされる
    Navigator.of(context).push(
        // MaterialPageRoute とそのビルダーを追加する
        // ここではListTile 行を生成するコードを追加する
        // ListItle のdivideTiles() 関数は各 ListTile の間に水平方向の間隔を追加する
        // divided 変数は、簡易関数である toList() によってリストに変換された最終行を保持する
        MaterialPageRoute<void>(builder: (BuildContext context) {
      final tiles = _saved.map(
        (WordPair pair) {
          return ListTile(
            title: Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
          );
        },
      );
      final divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      // builder プロパティは SavedSugestions という名前の
      // 新しいルートのアプリバーを含むScaffold を返す
      // 新しいルートの本文は、ListTiles 行を含む ListView で構成され、各行を分割線で区別する
      return Scaffold(
        appBar: AppBar(
          title: Text('Saved Suggestions'),
        ),
        body: ListView(children: divided),
      );
    }));
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
    // 単語のペアがすでにお気に入りに追加されていないことを確認する
    final alreadySaved = _saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        // ListTile オブジェクトにハート形のアイコンを追加して、お気に入り機能を有効にする
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        // リストをタップ操作可能にする
        onTap: () {
          // 状態が変更されたことをフレームワークに通知する
          // setState() を呼び出すと State オブジェクトの build() が呼び出され、UIが更新される
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }
}

// RandomWords ウィジェットを、StatefulWidget を継承することで作成する
// (State クラスのインスタンスを作成するStatefulWidget クラスで、これ自体はステートレス)
class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => new _RandomWordsState();
}
