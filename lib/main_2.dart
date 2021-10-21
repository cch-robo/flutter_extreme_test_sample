import 'package:extreme_test_sample/swappable_instance_factory.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  /// アプリ全体共有の画面遷移引数オブジェクト
  final PageTransitionUserArgument argument = PageTransitionUserArgument();

  /// アプリ全体共有の UserRepository
  final UserRepository repository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserListPage(title: 'UserList Page'),
    );
  }
}

/// ユーザ一覧画面
class UserListPage extends StatefulWidget {
  const UserListPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  // テスト時にインスタンスを差替可能にした UserListPageLogic 設定
  final UserListPageLogic logic =
      Factory.create(UserListPageLogic(), id: 'UserListPageLogic');

  void onNavigatorPush(BuildContext context, UserModel user) {
    debugPrint('UserListPage onNavigatorPush(name:${user.name}, '
        'assetUrl: ${user.assetUrl}, '
        'profile:${user.profile})');
    logic.setArgument(user: user);

    // 画面遷移
    Navigator.of(context).push<UserDetailPage>(MaterialPageRoute(
      builder: (context) {
        return const UserDetailPage(
          title: 'UserDetail Page',
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    // ロジックにアプリ全体共有 UserRepository をセットアップ
    logic.setup(
        (context.findAncestorWidgetOfExactType<MyApp>() as MyApp).argument,
        (context.findAncestorWidgetOfExactType<MyApp>() as MyApp).repository);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          UserModel user = logic.getUser(index);
          debugPrint('UserListPage user(name:${user.name}, '
              'assetUrl: ${user.assetUrl}, '
              'profile:${user.profile})');

          return GestureDetector(
            onTap: () => onNavigatorPush(context, user),
            // 画像は縦横同じサイズとする。
            child: Container(
              height: 100.0,
              padding: const EdgeInsets.all(8.0),
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  // 画像
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // 楕円/円 を使った画像切り抜き
                      child: ClipOval(
                        child: Image.asset(user.assetUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      user.name,
                      textAlign: TextAlign.start,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: logic.users.length,
      ),
    );
  }
}

/// ユーザ詳細画面
class UserDetailPage extends StatefulWidget {
  const UserDetailPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  // テスト時にインスタンスを差替可能にした UserDetailPageLogic 設定
  final UserDetailPageLogic logic =
      Factory.create(UserDetailPageLogic(), id: 'UserDetailPageLogic');

  @override
  Widget build(BuildContext context) {
    // ロジックにアプリ全体共有画面遷移引数設定 PageTransitionUserArgument から
    // User をセットアップ
    logic.setup(
        (context.findAncestorWidgetOfExactType<MyApp>() as MyApp).argument);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            // 画像＋タイトル
            Row(
              children: <Widget>[
                // 画像：縦横同じサイズとする。
                SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // 楕円/円 を使った画像切り抜き
                      child: ClipOval(
                        child:
                            Image.asset(logic.user.assetUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                // ユーザ名
                Container(
                  // width: 100.0,
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    logic.user.name,
                    textAlign: TextAlign.start,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ],
            ),
            // プロフィール
            Container(
              // width: 100.0,
              color: Colors.transparent,
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Text(
                  logic.user.profile,
                  textAlign: TextAlign.start,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 100,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.normal,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ユーザ一覧画面ロジック
class UserListPageLogic {
  UserListPageLogic();

  late final PageTransitionUserArgument _argument;
  void setArgument({required UserModel user}) {
    _argument.setUser(user.name, user.assetUrl, user.profile);
  }

  late final UserRepository _repository;
  List<UserModel> get users => _repository.users;

  UserModel getUser(int index) {
    return _repository.users[index];
  }

  bool _isAlreadySetup = false;
  void setup(PageTransitionUserArgument argument, UserRepository repository) {
    if (_isAlreadySetup) return;
    _argument = argument;
    _repository = repository;
    _isAlreadySetup = true;
  }
}

/// ユーザ詳細画面ロジック
class UserDetailPageLogic {
  UserDetailPageLogic();

  late final UserModel _user;
  UserModel get user => _user;

  bool _isAlreadySetup = false;
  void setup(PageTransitionUserArgument argument) {
    if (_isAlreadySetup) return;
    _user = argument.getUser();
    _isAlreadySetup = true;
  }
}

/// アプリ全体共有の画面遷移引数
class PageTransitionUserArgument {
  final VariableHolder<UserModel> _user = VariableHolder(const UserModel());

  void setUser(String name, String assetUrl, String profile) {
    _user.value = UserModel(name: name, assetUrl: assetUrl, profile: profile);
  }

  UserModel getUser() => _user.value;
}

/// ユーザ情報
class UserModel {
  const UserModel({
    this.name = 'John Doe',
    this.assetUrl = 'assets/no-image.jpg',
    this.profile = "",
  });

  final String name;
  final String assetUrl;
  final String profile;
}

/// ユーザ情報リポジトリ
class UserRepository {
  UserRepository() {
    _init();
  }

  final List<UserModel> _users = [];
  List<UserModel> get users => _users;

  void _init() {
    _users
      ..add(const UserModel(
        name: 'apple',
        assetUrl: 'assets/images/apple.jpg',
        profile: 'アップル',
      ))
      ..add(const UserModel(
        name: 'cauliflower',
        assetUrl: 'assets/images/cauliflower.jpg',
        profile: 'カリフラワー',
      ))
      ..add(const UserModel(
        name: 'kale',
        assetUrl: 'assets/images/kale.jpg',
        profile: 'ケール',
      ))
      ..add(const UserModel(
        name: 'nectarine',
        assetUrl: 'assets/images/nectarine.jpg',
        profile: 'ネクタリン',
      ))
      ..add(const UserModel(
        name: 'radish',
        assetUrl: 'assets/images/radish.jpg',
        profile: '大根',
      ))
      ..add(const UserModel(
        name: 'artichoke',
        assetUrl: 'assets/images/artichoke.jpg',
        profile: 'アーティチョーク',
      ))
      ..add(const UserModel(
        name: 'endive',
        assetUrl: 'assets/images/endive.jpg',
        profile: '菊チシャ',
      ))
      ..add(const UserModel(
        name: 'kiwi',
        assetUrl: 'assets/images/kiwi.jpg',
        profile: 'キゥイ',
      ))
      ..add(const UserModel(
        name: 'orange bell pepper',
        assetUrl: 'assets/images/orange_bell_pepper.jpg',
        profile: 'オレンジ ピーマン',
      ))
      ..add(const UserModel(
        name: 'squash',
        assetUrl: 'assets/images/squash.jpg',
        profile: '南瓜',
      ))
      ..add(const UserModel(
        name: 'asparagus',
        assetUrl: 'assets/images/asparagus.jpg',
        profile: 'アスパラガス',
      ))
      ..add(const UserModel(
        name: 'fig',
        assetUrl: 'assets/images/fig.jpg',
        profile: '無花果',
      ))
      ..add(const UserModel(
        name: 'lemon',
        assetUrl: 'assets/images/lemon.jpg',
        profile: 'レモン',
      ))
      ..add(const UserModel(
        name: 'persimmon',
        assetUrl: 'assets/images/persimmon.jpg',
        profile: '柿',
      ))
      ..add(const UserModel(
        name: 'strawberry',
        assetUrl: 'assets/images/strawberry.jpg',
        profile: 'イチゴ',
      ))
      ..add(const UserModel(
        name: 'avocado',
        assetUrl: 'assets/images/avocado.jpg',
        profile: 'アボカド',
      ))
      ..add(const UserModel(
        name: 'grape',
        assetUrl: 'assets/images/grape.jpg',
        profile: 'ブドウ',
      ))
      ..add(const UserModel(
        name: 'lime',
        assetUrl: 'assets/images/lime.jpg',
        profile: 'ライム',
      ))
      ..add(const UserModel(
        name: 'plum',
        assetUrl: 'assets/images/plum.jpg',
        profile: '梅',
      ))
      ..add(const UserModel(
        name: 'tangelo',
        assetUrl: 'assets/images/tangelo.jpg',
        profile: 'タンジェロ',
      ))
      ..add(
        const UserModel(
            name: 'blackberry',
            assetUrl: 'assets/images/blackberry.jpg',
            profile: 'ブラックベリー'),
      )
      ..add(const UserModel(
        name: 'green bell pepper',
        assetUrl: 'assets/images/green_bell_pepper.jpg',
        profile: 'グリーン ピーマン',
      ))
      ..add(const UserModel(
        name: 'mango',
        assetUrl: 'assets/images/mango.jpg',
        profile: 'マンゴー',
      ))
      ..add(const UserModel(
        name: 'potato',
        assetUrl: 'assets/images/potato.jpg',
        profile: 'ジャガイモ',
      ))
      ..add(const UserModel(
        name: 'tomato',
        assetUrl: 'assets/images/tomato.jpg',
        profile: 'トマト',
      ))
      ..add(const UserModel(
        name: 'cantaloupe',
        assetUrl: 'assets/images/cantaloupe.jpg',
        profile: 'マスクメロン',
      ))
      ..add(const UserModel(
        name: 'habanero',
        assetUrl: 'assets/images/habanero.jpg',
        profile: 'ハバネロ',
      ))
      ..add(const UserModel(
        name: 'mushroom',
        assetUrl: 'assets/images/mushroom.jpg',
        profile: 'マッシュルーム',
      ))
      ..add(const UserModel(
        name: 'radicchio',
        assetUrl: 'assets/images/radicchio.jpg',
        profile: 'チコリー',
      ))
      ..add(const UserModel(
        name: 'watermelon',
        assetUrl: 'assets/images/watermelon.jpg',
        profile: '西瓜',
      ));
  }
}
