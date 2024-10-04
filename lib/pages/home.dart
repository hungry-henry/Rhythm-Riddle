import 'package:flutter/material.dart';
import 'package:rhythm_riddle/pages/game.dart';
import '../generated/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const storage = FlutterSecureStorage();

class Home extends StatefulWidget{
  const Home({super.key});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;
  List<dynamic> playlists = [];
  String? uid = '';
  String? username = '';
  String? password = '';
  String? mail = '';
  bool isLogin = false;

  //need to get from ??
  List<String> _searchHistory = ['Flutter', 'Dart', 'SearchBar', 'Rounded corners'];
  List<String> _recommended = ['Recommended 1', 'Recommended 2', 'Recommended 3'];
  bool _isSearchActive = false;

  Future<void> getData() async {
    uid = await storage.read(key:'uid');
    username = await storage.read(key:'username');
    password = await storage.read(key:'password');
    mail = await storage.read(key:'mail');
    if(uid != null && username != null && password != null && mail != null){
      setState(() {
        isLogin = true;
      });
    }

    final response = await http.post(
      Uri.parse('http://hungryhenry.xyz/api/get_playlist.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      }
    );

    if (response.statusCode == 200) {
      setState((){
        playlists = jsonDecode(response.body)['data'];
      });
      for(int i = 0; i < playlists.length; i++){
        print(playlists[i]['title']);
      }
    }else {
      // 错误
      setState((){
        playlists = [{"id": 0, "title": "error"}];
      });
      print(response.body);
    }
  }
  
  Future<void> logout(BuildContext context) async {
    await storage.delete(key: 'username');
    await storage.delete(key: 'password');
    await storage.delete(key: 'mail');
    await storage.delete(key: 'uid');
    if(!context.mounted) return;
    Navigator.pushNamed(context, 'login');
  }
  
  //search bar
  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSearchActive = true;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text(
              'Search...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryAndRecommendedSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_searchHistory.isNotEmpty) _buildHistorySection(),
            SizedBox(height: 20),
            _buildRecommendedSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Search History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: _searchHistory
              .map((history) => Chip(
                    label: Text(history),
                    onDeleted: () {
                      setState(() {
                        _searchHistory.remove(history);
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: _recommended
              .map((recommend) => Chip(
                    label: Text(recommend),
                  ))
              .toList(),
        ),
      ],
    );
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
      ),

      //navbar
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: const Icon(Icons.sports_esports),
            icon: const Icon(Icons.sports_esports_outlined),
            label: S.current.home,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.workspace_premium),
            icon: const Icon(Icons.workspace_premium_outlined),
            label: S.current.rank,
          ),
          NavigationDestination(
            selectedIcon: const Icon(Icons.account_box),
            icon: const Icon(Icons.account_box_outlined),
            label: S.current.account,
          ),
        ]
      ),

      body: <Widget>[
        //主页
        Center(child:ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child:Padding(padding: EdgeInsets.all(16),
            child:Column(
              children: [
                // 推荐
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(),
                      // 根据是否激活搜索栏展示搜索历史和推荐
                      if (_isSearchActive) ...[
                        Text("hello!!!")
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.current.recm, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const Text('更多 =>', style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:List.generate(playlists.length, (index){
                          return SizedBox(width:80,
                            child:Column(
                              children: [
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Game(data: playlists[index]['id'].toString()),
                                      ),
                                    );
                                  },
                                  style:ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    fixedSize: Size(70, 70),
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  child:Container(
                                    width: 70,
                                    height: 70,
                                    child:Image.network(
                                      "http://hungryhenry.xyz/musiclab/playlist/${playlists[index]['id']}.jpg",
                                      // 占位图片
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                      // 加载错误时的图片
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return const Icon(Icons.image, color:Colors.grey);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(playlists[index]['title'], textAlign: TextAlign.center),
                              ],
                            )
                          );
                        })
                      ),
                    ],
                  ),
                ),

                //热门
                Expanded(child:
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.current.hot, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const Text('更多 =>', style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (index) {
                            return Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                ),
                                const SizedBox(height: 5),
                                const Text('blah'),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(child:
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.current.sort, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const Text('更多 =>', style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (index) {
                            return Column(
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                ),
                                const SizedBox(height: 5),
                                const Text('blah'),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              ],),
            ),
          ),
        ),
        /// Notifications page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        //Account
        Padding(padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage("http://hungryhenry.xyz/blog/usr/uploads/avatar/$uid.png"), // 使用网络图片作为头像
              ),
            ),
            SizedBox(height: 20),
            Center(
              child:Text(
                "uid:${uid!}"
              ),
            ),
            ListTile(
              title: Text(
                '用户名',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                username!,
                style: TextStyle(fontSize: 19),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            Divider(),
            ListTile(
              title: Text(
                '邮箱',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                mail!,
                style: TextStyle(fontSize: 19),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            Divider(),
            ListTile(
              title: Text(
                '性别',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                '男',
                style: TextStyle(fontSize: 19),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            Divider(),
            ListTile(
              title: Text(
                '喜好',
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Text(
                '音乐, 旅行, 阅读',
                style: TextStyle(fontSize: 18),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  logout(context);
                },
                child: Text('退出登录'),
              ),
            ),
          ],
        ),
      ),
      ][currentPageIndex],
    );
  }
  String _getAppBarTitle(){
    switch (currentPageIndex) {
    case 0:
      return S.current.home;
    case 1:
      return S.current.rank;
    case 2:
      return S.current.account;
    default:
      return S.current.home;
    }
  }
}