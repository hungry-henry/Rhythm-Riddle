import 'dart:io';

import 'package:flutter/material.dart';
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
  bool isLoading = true;

  void showDialogFunction(String title) async {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
          content: Text(title),
          actions: [
              TextButton(onPressed: () {Navigator.of(context).pop(false);}, child: Text(S.current.ok)),
          ],
      );
    });
  }

  Future<void> getData() async {
    uid = await storage.read(key:'uid');
    username = await storage.read(key:'username');
    password = await storage.read(key:'password');
    mail = await storage.read(key:'mail');
    if(uid != null && username != null && password != null && mail != null && mounted){
      setState(() {
        isLogin = true;
      });
    }

    try{
      final response = await http.post(
        Uri.parse('http://hungryhenry.xyz/api/get_playlist.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        }
      ).timeout(const Duration(seconds: 7));

      if (response.statusCode == 200 && mounted) {
        setState((){
          playlists = jsonDecode(response.body)['data'];
          isLoading = false;
        });
      }else {
        // 错误
        if(mounted){
          setState((){
            playlists = [{"id": 0, "title": "error"}];
          });
          print(response.body);
        }
      }
    }catch (e){
      showDialogFunction(S.current.connectError);
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
  
  Widget _buildHome(){
    return 
    RefreshIndicator(
      onRefresh: getData,
      color: const Color(0xFF009688),
      backgroundColor: const Color(0xFFE0F2F1),
      child: ListView(children:[
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SafeArea(
                    child: GestureDetector(
                      onTap: () {Navigator.of(context).pushNamed('search');},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 10),
                            Text(
                              S.current.search,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) ...[
                              const Spacer(),
                              IconButton(icon: const Icon(Icons.refresh), color: Colors.grey, onPressed: (){getData();},)
                            ]
                          ],
                        ),
                      ),
                    )
                  ),
                  const SizedBox(height: 30),
      
                  // 推荐
                  SizedBox(
                    height: 170, // 固定推荐部分的高度
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.current.recm,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const Text('更多 =>', style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if(isLoading) ...[
                          const Center(child: CircularProgressIndicator()),
                        ]else...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(playlists.length, (index) {
                              return SizedBox(
                                width: 80,
                                height: 120,
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          'PlaylistInfo',
                                          arguments: playlists[index]['id']
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                        fixedSize: const Size(70, 70),
                                        padding: const EdgeInsets.all(0),
                                      ),
                                      child: SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: Image.network(
                                          "http://hungryhenry.xyz/musiclab/playlist/${playlists[index]['id']}.jpg",
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null ? 
                                                  loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1) : null,
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object exception, StackTrace? stackTrace) {
                                            return const Icon(Icons.image,
                                                color: Colors.grey);
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Expanded(
                                      child: Text(playlists[index]['title'],
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    )
                                  ],
                                ),
                              );
                            }),  
                          ),
                        ]
                      ],
                    ),
                  ),
      
                  const SizedBox(height: 20),
      
                  // 热门
                  SizedBox(
                    height: 150, // 固定热门部分的高度
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.current.hot,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
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
      
                  const SizedBox(height: 20),
      
                  // 分类
                  SizedBox(
                    height: 150, // 固定分类部分的高度
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.current.sort,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
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
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildAccount() {
    if(isLogin){
      return SingleChildScrollView(
        child: Center(
          child:Container(
            padding: const EdgeInsets.all(16.0),
            width:700,
            child:Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage("http://hungryhenry.xyz/blog/usr/uploads/avatar/$uid.png")             
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child:Text(
                    "uid:${uid!}"
                  ),
                ),
                ListTile(
                  title: const Text(
                    '用户名',
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    username!,
                    style: const TextStyle(fontSize: 19),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const Divider(),
                ListTile(
                  title: const Text(
                    '邮箱',
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    mail!,
                    style: const TextStyle(fontSize: 19),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                const Divider(),
                const ListTile(
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
                const Divider(),
                const ListTile(
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
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      logout(context);
                    },
                    child: const Text('退出登录'),
                  ),
                ),
              ],
            )
          )
        ) 
      );
    }else{
      return Center(
        child: ElevatedButton(
          child: const Text('登录'),
          onPressed: () => Navigator.of(context).pushNamed('login')
        )
      );
    }
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
      bottomNavigationBar:NavigationBar(
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
        _buildHome(),
        /// Rank Page
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
        _buildAccount()
      ][currentPageIndex]
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