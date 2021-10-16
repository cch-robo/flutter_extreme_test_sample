import 'package:extreme_test_sample/main.dart' as app;
import 'package:extreme_test_sample/swappable_instance_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// テスト中に差し替えて、外部から参照可能にする ViewModel
  late final app.CounterViewModel viewModel;

  setUp(() {
    // ViewModel をテスト中に外部参照可能にするため、
    // テスト中にインスタンス差替可能なファクトリに、CounterViewModel を設定。
    Factory.setTesting(true);
    viewModel = app.CounterViewModel();
    Factory.setSwapInstance<app.CounterViewModel>(viewModel,
        id: 'CounterViewModel');
  });

  tearDown(() {
    // テスト中にインスタンス差替可能なファクトリの設定をクリア。
    Factory.clear();
    Factory.setTesting(false);
  });

  // インスタンス差替可能ファクトリを利用して、ViewModel を外部参照可能にした検証
  testWidgets('Counter increments extreme smoke test',
      (WidgetTester tester) async {
    // riverpod ProviderScope 定義を含むよう、アプリ全体のウィジェットツリーを作成します。
    // Build our app and trigger a frame.
    await tester.pumpWidget(app.providerScope);

    // 画面初期表示時のカウンター値を ViewModel から直接確認する。
    // Verify that our counter starts at 0.
    expect(0, viewModel.counter);
    print('before increment - counter = ${viewModel.counter}');

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Increment FABクリック後の カウンター値を ViewModel から直接確認する。
    // Verify that our counter has incremented.
    expect(1, viewModel.counter);
    print('after increment - counter = ${viewModel.counter}');
  });
}
