# extreme_test_sample

インスタンス差替可能なファクトリを利用して、  
アプリケーションのウィジェットツリー中の任意オブジェクトをテスト時に外部参照可能にする、  
エクストリーム（極端） Widget test ＆ Integration test のサンプルです。

サンプル中では、  
アプリケーションのウィジェットツリー中の ViewModel をテスト時に外部参照可能にすることで、  
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

## command of run widget test

see [An introduction to unit testing](https://flutter.dev/docs/cookbook/testing/unit/introduction)

```shell
# you run test program file of widget test on direct.
$ flutter test test/widget_test.dart

# you run test program file of extreme widget test on direct.
$ flutter test test/widget_extreme_test.dart
```

```shell
# you run all test program files of integration test.
$ flutter test test/
```

## command of run integration test

see [An introduction to integration testing](https://flutter.dev/docs/cookbook/testing/integration/introduction) .

```shell
# you run test program file of integration test on direct.
$ flutter test integration_test/app_test.dart

# you run test program file of extreme integration test on direct.
$ flutter test integration_test/app_extreme_test.dart
```

```shell
# you run all test program files of integration test.
$ flutter test integration_test/
```