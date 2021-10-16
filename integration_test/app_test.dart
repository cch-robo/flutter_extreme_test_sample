import 'package:extreme_test_sample/main.dart' as app;
import 'package:extreme_test_sample/swappable_instance_factory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
    testWidgets('tap on the floating action button, verify counter',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify the counter starts at 0.
      expect(find.text('0'), findsOneWidget);
      print("before increment - counter = ${viewModel.counter}");

      // Finds the floating action button to tap on.
      final Finder fab = find.byTooltip('Increment');

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      expect(find.text('1'), findsOneWidget);
      print("after increment - counter = ${viewModel.counter}");
    });
  });
}
