import 'package:extreme_test_sample/main_2.dart' as app;
import 'package:extreme_test_sample/swappable_instance_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// テスト中に差し替えて、外部から参照可能にする Logic
  late app.UserListPageLogic userListPageLogic;
  late app.UserDetailPageLogic userDetailPageLogic;

  setUp(() {
    Factory.setTesting(true);

    // 画面ロジックをテスト中に外部参照可能にするため、
    // テスト中にインスタンス差替可能なファクトリに、ビジネスロジックを設定。
    userListPageLogic = app.UserListPageLogic();
    Factory.setSwapInstance<app.UserListPageLogic>(userListPageLogic,
        id: 'UserListPageLogic');

    userDetailPageLogic = app.UserDetailPageLogic();
    Factory.setSwapInstance<app.UserDetailPageLogic>(userDetailPageLogic,
        id: 'UserDetailPageLogic');
  });

  tearDown(() {
    // テスト中にインスタンス差替可能なファクトリの設定をクリア。
    Factory.clear();
    Factory.setTesting(false);
  });

  /// インスタンス差替可能ファクトリを利用して、ビジネスロジックを外部参照可能にした検証
  testWidgets('一覧画面から選択ユーザの詳細画面への画面遷移検証 extreme smoke test',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(app.MyApp());

    // リポジトリから全ユーザ情報を取得できたか、ユーザ一覧画面の logic から直接確認する。
    expect(30, userListPageLogic.users.length);
    debugPrint('before transition - users = ${userListPageLogic.users.length}');

    // ユーザ一覧から apple をタッチ
    // （この時点では、画面遷移していない）
    final Finder item = find.text('apple');
    await tester.tap(item);

    await tester.pump();

    // ユーザ詳細画面のユーザを logic から直接確認する。
    expect('apple', userDetailPageLogic.user.name);
    expect('アップル', userDetailPageLogic.user.profile);
    debugPrint('after transition - user(name:${userDetailPageLogic.user.name}, '
        'assetUrl:${userDetailPageLogic.user.assetUrl}, '
        'profile:${userDetailPageLogic.user.profile})');
    debugPrint('test end');
  });
}
