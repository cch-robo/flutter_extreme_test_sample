# flutter_extreme_test_sample

インスタンス差替可能なファクトリを利用して、  
アプリケーションのウィジェットツリー中の任意オブジェクトをテスト時に外部から注入する、  
エクストリーム（極端）な Widget test ＆ Integration test についてのサンプルです。

サンプル中では、  
アプリケーションのウィジェットツリー中の ViewModel をテスト時に外部から注入して参照可能にすることで、  
Widget test や Integration test であっても、単体テストや通常結合テストのように  
ViewModel の振る舞い（内部状態）を直接検証しています。

```
# プロジェクト・ディレクトリ構成

lib/
  + main.dart                       # カウンタアプリ （テスト時のインスタンス差替対応のみ追加）
  + swappable_instance_factory.dart # テスト時のインスタンス差替可能ファクトリのライブラリ
 
test/
  + widget_test.dart         # 通常のウィジェットテスト（画面のカウンタ表示から検証を行う）
  + widget_extreme_test.dart # extremeウィジェット単体テスト（ViewModelを参照して検証を行う）
 
integration_test/            # アプリをシミュレータにインストールしてテストを行う。
  + app_test.dart            # 通常のアプリ E2E テスト（画面のカウンタ表示から検証を行う）
  + app_extreme_test.dart    # extreme アプリ 結合テスト（ViewModelを参照して検証を行う）

test_driver/
  + integration_test.dart    # Web テスト用のドライバー設定（特に使わない） 
```

## widget test 実行コマンド

see [An introduction to unit testing](https://flutter.dev/docs/cookbook/testing/unit/introduction)

```shell
# widget test ファイルを直接実行するコマンド
$ flutter test test/widget_test.dart

# extreme widget test ファイルを直接実行するコマンド
$ flutter test test/widget_extreme_test.dart
```

```shell
# widget test ディレクトリの全テストファイルを実行するコマンド
$ flutter test test/
```

## integration test 実行コマンド

see [An introduction to integration testing](https://flutter.dev/docs/cookbook/testing/integration/introduction) .

```shell
# integration test ファイルを直接実行するコマンド
$ flutter test integration_test/app_test.dart

# extreme integration test ファイルを直接実行するコマンド
$ flutter test integration_test/app_extreme_test.dart
```

```shell
# integration test ディレクトリの全テストファイルを実行するコマンド
$ flutter test integration_test/
```

## 留意事項
このサンプルプロジェクトは、一般的なテストコードのサンプルではないことに留意ください。

これは、テストコード記述を最小にするための **extreme/極端** なサンプルです。  
一般的なテストコードのサンプルではないことに留意ください。

たとえば、Reverpodの ProviderScopeを ウィジェットツリーのルートに配置するケースでは、  
Widget test において `WidgetTester#pumpWidget(MyHomePage())`のように、  
MyHomePageからウィジェットツリーを切り出すと providerオブジェクトが機能しません。

ウィジェットツリーのルートから扱わずに、MyHomePageのコンポーネントをテストする場合は、  
MyHomePage を当該テスト専用のウィジェットツリーに追加した形のテストコード作成が必要です。  
これは、本来のアプリコードを改変した環境でのテストになります。

* *Riverpodを使っている場合は、当該テスト用のウィジェットツリーとして、  
  ProviderScope()の overrides: オプション引数でクロージャ内の  
  必要なproviderオブジェクトを上書きしたルートウィジェットを作るでしょう。*  
  See [Overriding the behavior of a provider during tests.](https://riverpod.dev/docs/cookbooks/testing/#overriding-the-behavior-of-a-provider-during-tests)

サンプル内部では、  
**境界付き依存性レベルツリー** に、アプリの全てのコンポーネントが含まれるようにするため、  
Widget test や Integration test でのアプリルートからのウィジェットツリーを対象に、  
アプリコード中に、テスト時にインスタンスの差替が可能なファクトリを利用することで、  
ViewModelなどの任意コンポーネント・オブジェクトをテスト側から注入し参照可能にして、  
テスト中のコンポーネントの振る舞い（内部状態）を検証しています。
