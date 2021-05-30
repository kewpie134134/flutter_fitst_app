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
            child: Text(wordPair.asPascalCase),
          )),
    );
  }
}
