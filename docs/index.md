# [Flutter Advent Calendar 2021](https://qiita.com/advent-calendar/2021/flutter) | Calendar2 day15

## はじめに
このドキュメントは、[Flutter Advent Calendar 2021](https://qiita.com/advent-calendar/2021/flutter) のカレンダー2の day15
です。

[DevFest Kyoto 2021 - Flutterテスト講座](https://gdgkyoto.connpass.com/event/226491/) の
セッション [**テスト設計できるようになろう**](https://drive.google.com/file/d/1OznsKYxa_VSkrAwuH2cqpf1ZHxBNsLEg/view?usp=sharing) の  
*Widget testで状態プロパティを参照する - エクストリームテスト* の [**サンプルプロジェクト**](https://github.com/cch-robo/flutter_extreme_test_sample) をベースに、  
[GitHub Actions](https://docs.github.com/en/actions) を使い、Pull requestイベントなどでテスト実行できるようにしたレポートです。  
セッション内容については、スライド資料を御参照ください。

* セッション発表スライド  
  [テスト設計できるようになろう](https://drive.google.com/file/d/1OznsKYxa_VSkrAwuH2cqpf1ZHxBNsLEg/view?usp=sharing)

Flutterプロジェクト-リポジトリの [GitHub Actions](https://docs.github.com/en/actions) 対応については、  
[*flutter github actions*](https://www.google.com/search?q=flutter+github+actions&oq=flutter+github+actions&ie=UTF-8) でググれば、既に多くの方々が資料を公開されていますので、  
レポートでは、主に [**nektos/act**](https://github.com/nektos/act) を使ったローカルでの GitHub Actions 対応について紹介します。
