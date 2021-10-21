import 'package:extreme_test_sample/main_2.dart' as app;
import 'package:extreme_test_sample/swappable_instance_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end extreme test', () {
    /// テスト中に差し替えて、外部から参照可能にする Logic
    late app.UserListPageLogic userListPageLogic;
    late app.UserDetailPageLogic userDetailPageLogic;

    setUp(() {
      Factory.setTesting(true);

      // ViewModel をテスト中に外部参照可能にするため、
      // テスト中にインスタンス差替可能なファクトリに、ロジック を設定。
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

    // インスタンス差替可能ファクトリを利用して、ViewModel を外部参照可能にした検証
    testWidgets('tap on the floating action button, extreme verify counter',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // ユーザ一覧画面のユーザ数を logic から直接確認する。
      expect(30, userListPageLogic.users.length);
      debugPrint(
          'before transition - users = ${userListPageLogic.users.length}');

      final Finder item = find.text('apple');

      // Emulate a tap on the floating action button.
      // この時点では、画面遷移していない。
      await tester.tap(item);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // ユーザ詳細画面のユーザを logic から直接確認する。
      expect('apple', userDetailPageLogic.user.name);
      expect('アップル', userDetailPageLogic.user.profile);
      debugPrint(
          'after transition - user(name:${userDetailPageLogic.user.name}, '
          'assetUrl:${userDetailPageLogic.user.assetUrl}, '
          'profile:${userDetailPageLogic.user.profile}');
      debugPrint('test end');
    });
  });
}
