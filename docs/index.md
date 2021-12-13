# [Flutter Advent Calendar 2021](https://qiita.com/advent-calendar/2021/flutter) | Calendar2 day15

## はじめに
このドキュメントは、[Flutter Advent Calendar 2021](https://qiita.com/advent-calendar/2021/flutter) のカレンダー2の day15
です。

[DevFest Kyoto 2021 - Flutterテスト講座](https://gdgkyoto.connpass.com/event/226491/) の
セッション [**テスト設計できるようになろう**](https://drive.google.com/file/d/1OznsKYxa_VSkrAwuH2cqpf1ZHxBNsLEg/view?usp=sharing) の  
*Widget testで状態プロパティを参照する - エクストリームテスト* の [**サンプルプロジェクト**](https://github.com/cch-robo/flutter_extreme_test_sample) をベースに、  
[GitHub Actions](https://docs.github.com/en/actions) を使い、Pull requestイベントでテスト実行できるようにしたレポートです。  
セッション内容については、スライド資料を御参照ください。

* セッション発表スライド  
  [テスト設計できるようになろう](https://drive.google.com/file/d/1OznsKYxa_VSkrAwuH2cqpf1ZHxBNsLEg/view?usp=sharing)

Flutterプロジェクト-リポジトリの [GitHub Actions](https://docs.github.com/en/actions) 対応については、  
[*flutter github actions*](https://www.google.com/search?q=flutter+github+actions&oq=flutter+github+actions&ie=UTF-8) でググれば、既に多くの方々が資料を公開されていますので、  
レポートでは、主に [**nektos/act**](https://github.com/nektos/act) を使ったローカルでの GitHub Actions 対応について紹介します。

## GitHub Actions 設定

[Quickstart for GitHub Actions - GitHub Docs](https://docs.github.com/en/actions/quickstart) に従い、GitHub Actions ワークフローを作ります。

1. GitHubのリポジトリに `.github/workflows` ディレクトリを作成します。

2. [yaml](https://ja.wikipedia.org/wiki/YAML) 形式でタスクを記述する任意名の`ワークフローファイル`を追加します。  
*Widget testを実行させるので `extreme_widget_test.yml` としました。*

3. ワークフローファイルに CI/CD ⇒ 継続的インテグレーション/継続的デリバリーのタスクを記述します。  
*Pull Requestイベントで、flutter環境を構築して`flutter test test/`を実行するタスクを記述しました。*

4. その他、GitHub Actionsの詳細については、[Learn GitHub Actions - GitHub Docs](https://docs.github.com/en/actions/learn-github-actions) を参照下さい。


- 作成したワークフロー  
*<プロジェクト>* / [.github](https://github.com/cch-robo/flutter_extreme_test_sample/tree/main/.github) / [workflows](https://github.com/cch-robo/flutter_extreme_test_sample/tree/main/.github/workflows) /
[extreme_widget_test.yaml](https://github.com/cch-robo/flutter_extreme_test_sample/blob/main/.github/workflows/extreme_widget_test.yml)  
Pull Requestイベントが発生すれば、`flutter test test/` を実行します。
  - `steps:`の設定は、[subosito/flutter-action](https://github.com/subosito/flutter-action) の [README.md](https://github.com/subosito/flutter-action/blob/master/README.md) にある [Usage](https://github.com/subosito/flutter-action/blob/master/README.md#usage) サンプルを参考にしました。

```yaml
name: extreme widget test

on:
  pull_request:
    types: [opened, synchronize]
jobs:
  extreme_widget_test:
    name: flutter extreme widget test
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - name: set up repository
        uses: actions/checkout@v2
      - name: set up java
        uses: actions/setup-java@v2
        with:
          distribution: 'zulu'
          java-version: '11'
      - name: set up flutter
        uses: subosito/flutter-action@v1
        with:
          channel: 'stable'
          flutter-version: '2.8.0'
      - name: flutter pub get
        run: flutter pub get

      # 全てのエクストリームWidgetテストを実行
      - name: flutter exstreme widget test
        run: flutter test test/
```


## pull request で `flutter test test/` が実行されるかチェック

### GitHub (GitHub Actions)

- Pull Request イベントともにテストが実行されるようになり
![on pull request do test start](./images/on_pull_request_test_start.png)


- テスト成功で Merge 可能になりました。
![on pull request with test success](./images/on_pull_request_test_success.png)


## GitHub Actions ローカル実行

[nektos/act](https://github.com/nektos/act)

- act コマンドでのオプションについて ⇒ [https://github.com/nektos/act#example-commands](https://github.com/nektos/act#example-commands)   
act コマンドは、`act [<event>] [options]` のフォーマットを取り、  
event には、yml ファイル(ワークフロー)の on: で定義した、`push:`や `pull_request:`などの GitHub イベント名を与えます。  
options には、`act ｰl` ⇒ デフォルトアクション一覧や、`act -j test` ⇒ test jobを実行などがあります。  
*イベントやオプションがない場合、デフォルト値として push イベントが割り当てられます。*


- act 実行時には、以下のような WARN警告や 選択を促されることがあります。  
![act runtime warm](images/warm.png)


- WARNと選択要求の概要
  - ⚠ You are using Apple M1 chip and you have not specified container architecture, you might encounter issues while running act.  
    If so, try running it with '--container-architecture linux/amd64'. ⚠  
    M1 macで問題がある場合は、下記例のように linux/amd64 コンテナアーキテクチャを強制指定してみてください。  
    `$ act pull_request --container-architecture linux/amd64`

  - Please choose the default image you want to use with act:  
  デフォルトのイメージサイズの選択します。  
    - Large size image: ⇒ +20GB Docker image (全部入り)  
    - Medium size image: ⇒ 500MB以下 (こちらを選択)  
    - Micro size image: ⇒ 200MB未満  
    - Default image and other options can be changed manually in ~/.actrc  
    *デフォルト設定は、`~/.actrc`に保管されます。*  


- act の設定ファイル  
  `~/.actrc` に選択したイメージサイズが設定されます。  
  *このファイルを削除すると、再度イメージサイズ選択が行われるようになります。*

`~/.actrc`ファイルの設定例
```text
-P ubuntu-latest=ghcr.io/catthehacker/ubuntu:act-latest
-P ubuntu-20.04=ghcr.io/catthehacker/ubuntu:act-20.04
-P ubuntu-18.04=ghcr.io/catthehacker/ubuntu:act-18.04
```

- act がダウンロードしている、Ubuntu のイメージ保管先  
  [catthehacker/docker_images](https://github.com/catthehacker/docker_images) ⇒ [https://github.com/catthehacker/docker_images](https://github.com/catthehacker/docker_images)





## エクストリームテストについて

- エクストリームテストとは、[**テスト設計できるようになろう**](https://drive.google.com/file/d/1OznsKYxa_VSkrAwuH2cqpf1ZHxBNsLEg/view?usp=sharing) での独自用語です。  
アプリコード内に「テスト中にコンポーネントツリー内の任意オブジェクトを  
外部参照可能なオブジェクトに差し替えられる」[**独自Factory**](https://github.com/cch-robo/flutter_extreme_test_sample/blob/main/lib/swappable_instance_factory.dart) を導入することで、  
Widget test や Integration test の中で、テストダブルの注入やコンポーネント状態の  
確認ができるようにした Extreme ⇒ 極端なテストを表します。  
　  
*Riverpodを使っているのでしたら、*  
*当該テスト用のウィジェットツリーとして、ProviderScope()の overrides: オプション引数で*  
*クロージャ内の必要なproviderオブジェクトを上書きしたルートウィジェットを作るでしょう。*  
See [Overriding the behavior of a provider during tests.](https://riverpod.dev/docs/cookbooks/testing/#overriding-the-behavior-of-a-provider-during-tests)


- `flutter test integration_test/app_extreme2_test.dart` ⇒ エミュレータでの integration test 実行状況。  
integration test 起動画面から一覧画面が表示され、リスト上端の appleを選択して、詳細画面に遷移するかを確認しています。
![extreme2 integration_test](./images/extreme2_integration_test.png)


## 謝辞

- 参考先一覧
  - [GitHubの新機能「GitHub Actions」で試すCI/CD](https://knowledge.sakura.ad.jp/23478/)
  - [Flutterの自動ビルドをGithub ActionsとFirebaseで行う](https://zenn.dev/qst/articles/39e893b94d26f3eba855)
  - [GitHub ActionsによるFlutterテスト](https://zenn.dev/okuzawats/books/say-hello-to-fluter-ci-cd-with-github-actions/viewer/1-test)
  - [【Flutter】3種類のテストをGithub Actionsで自動化する](https://hondakenya.work/flutter-test-github-actions/)
  - [【Flutter】GitHubActionsでテストと静的解析を自動化する](https://qiita.com/tokkun5552/items/2eb6793501c152dabf33)
  - [FlutterアプリをGitHub Actionsを使用してFirebase App Distributionにデプロイしてみよう！](https://qiita.com/oke331/items/52e4bf32dc10a7054cca)
  - [【Flutter】GitHub Actions で iOS 向けに自動デプロイする](https://zenn.dev/pressedkonbu/articles/254ca2fc3cd1ab)
  - [GitHub ActionsでiOSのプロジェクトをビルドしたい！](https://ulog.sugiy.com/github-actions-ios-build/)
  - [GitHub ActionsでiOSアプリのCI環境を構築する方法](https://qiita.com/uhooi/items/29664ecf0254eb637951)
  - [GitHub Actions で Xcode プロジェクトをビルドしてみる](https://zenn.dev/koogawa/articles/54ff450a6dc5fd)
  - [GitHub Actionsのローカル実行ツール「act」を使う事でCI/CDコンフィグとローカルでのタスクランナーを1つにする](https://dev.classmethod.jp/articles/act-for-github-actions-local-execution-tool/)
  - [【ACT】GitHub Actions のローカル実行ツール使ってみた](https://qiita.com/wwalpha/items/6c303dcf04e236238315)
  - [GitHub Actions を act でローカルテストする](https://vlike-vlife.netlify.app/posts/testtool_act)
  