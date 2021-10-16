import 'package:extreme_test_sample/main.dart' as app;
import 'package:extreme_test_sample/swappable_instance_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// テスト中に差し替えて、外部から参照可能にする ViewModel
  late final app.CounterViewModel viewModel;

  setUp(() {
    // ViewModel をテスト中に外部参照可能にするため、
    // テスト中にインスタンス差替可能なファクトリに、CounterViewModel を設定。
    Factory.setTesting(true);
    viewModel = app.CounterViewModel();
    Factory.setSwapInstance<app.CounterViewModel>(viewModel,
        id: "CounterViewModel");
  });

  tearDown(() {
    // テスト中にインスタンス差替可能なファクトリの設定をクリア。
    Factory.clear();
    Factory.setTesting(false);
  });

  group('end-to-end test', () {
    // インスタンス差替可能ファクトリを利用して、ViewModel を外部参照可能にした検証
    testWidgets('tap on the floating action button, extreme verify counter',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 画面初期表示時のカウンター値を ViewModel から直接確認する。
      // Verify the counter starts at 0.
      expect(0, viewModel.counter);
      print("before increment - counter = ${viewModel.counter}");

      // Finds the floating action button to tap on.
      final Finder fab = find.byTooltip('Increment');

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Increment FABクリック後の カウンター値を ViewModel から直接確認する。
      // Verify the counter increments by 1.
      expect(1, viewModel.counter);
      print("after increment - counter = ${viewModel.counter}");
    });
  });
}
