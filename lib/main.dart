import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final counterProvider = ChangeNotifierProvider((ref) =>
      Factory.create<CounterViewModel>(CounterViewModel(),
          id: "CounterViewModel"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Consumer(builder: (context, watch, _) {
              final _counter = watch(counterProvider).counter;
              return Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read(counterProvider).incrementCounter(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class CounterViewModel extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }
}

/// テスト時にインスタンス差し替え可能なファクトリです。
class Factory {
  Factory._();

  /// テスト時に差し替え可能なインスタンスを生成します。
  ///
  /// テスト時でない場合は、引数指定された [instance] を生成インスタンスとして返します。
  ///
  /// テスト時に、[id] に合致する差替インスタンスが設定されていれば、差し替えて返します。
  ///
  /// 注意）差替インスタンスが、差替元と同じ型でない場合は、テスト時にクラッシュします。
  static T create<T>(T instance, {String id = ""}) {
    // テスト中でなければ、指定インスタンスをそのまま返す。
    if (!_SwappableFWT.instance._isTesting) return instance;

    // テスト中かつ、差替設定があれば差し替えて返す。
    T? swapInstance = id.isNotEmpty
        ? _SwappableFWT.instance.get(id)
        : _SwappableFWT.instance
            .get(instance != null ? instance.runtimeType.toString() : "");
    return (swapInstance == null) ? instance : swapInstance;
  }

  /// テスト時に差し替えるインスタンスを登録します。
  ///
  /// [swapInstance] を [id] をキーにした差替インスタンスとして登録します。
  ///
  /// テスト時でない場合は、無視されます。
  ///
  /// 注意）差替インスタンスが、差替元と同じ型でない場合は、テスト時にクラッシュします。
  static void setSwapInstance<T>(T? swapInstance, {String id = ""}) {
    // テスト中でない場合は、何もしない。
    if (!_SwappableFWT.instance._isTesting) return;

    _SwappableFWT.instance.add(id, swapInstance);
  }

  /// テスト時に差し替えるインスタンスを全クリアします。
  ///
  /// テスト時でない場合は、無視されます。
  static void clear() {
    // テスト中でない場合は、何もしない。
    if (!_SwappableFWT.instance._isTesting) return;

    _SwappableFWT.instance.clear();
  }

  /// テスト中か否かを設定する。
  ///
  /// テスト時の setUp() で true を、tearDown() で false を指定してください。
  static void setTesting(bool isTesting) {
    // リリースモード時は、設定要求を無視します。
    if (foundation.kReleaseMode) return;

    _SwappableFWT.instance._isTesting = isTesting;
  }
}

/// Swappable dependencies object Factory When in Testing only.
///
/// テスト時のみ差替可能なインスタンスファクトリの処理実態です。
class _SwappableFWT {
  _SwappableFWT._();
  static late final _SwappableFWT _singleton;
  static bool _isCreated = false;

  /// テスト中か否かを指定するフラグ
  bool _isTesting = false;

  /// シングルトン・インスタンスを返す。
  static _SwappableFWT get instance {
    if (!_isCreated) {
      _singleton = _SwappableFWT._();
      _singleton.clear();
      _isCreated = true;
    }
    return _singleton;
  }

  Map<String, dynamic> _map = {};

  /// 設定済みの差替インスタンスをクリアします。
  void clear() {
    _map.clear();
    _map[""] = null;
  }

  /// 差替インスタンスを設定します。
  void add(String id, dynamic state) {
    // テスト中でない場合は、何もしない。
    if (!_isTesting) return;

    // すでに Key 登録済みの場合は、更新しない。
    if (_map.containsKey(id)) return;

    _map[id] = state;
  }

  /// 設定済みの差替インスタンスを返します。
  dynamic get(String id) {
    // テスト中でない場合は、何もしない。
    if (!_isTesting) return null;

    return _map[id];
  }
}

/// デバッグモードでの実行時にのみ、デバッグログを出力します。
void debugLog(String message) {
  if (!foundation.kReleaseMode) {
    foundation.debugPrint(message);
  }
}

/// non-null 変数オブジェクト・ホルダー
///
/// プロパティ [value] に、デフォルト値および non-null の値を設定可能にします。
///
/// コンストラクタ引数 [_defaultValue] の値で、変数をデフォルト値に初期化します。
class VariableHolder<T> {
  VariableHolder(this._defaultValue) : value = _defaultValue;
  final T _defaultValue;

  /// 変数
  T value;

  /// 変数がデフォルト値のままかチェックする。
  bool isDefaultValue() {
    return _defaultValue == value;
  }
}
