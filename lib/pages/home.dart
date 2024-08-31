import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class Home extends StatefulWidget{
  const Home({super.key});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  Future<void> getData() async {
    print(await storage.read(key: 'username'));
    print(await storage.read(key: 'password'));
  }
  
  Future<void> logout(BuildContext context) async {
    await storage.delete(key: 'username');
    await storage.delete(key: 'password');
    if(!context.mounted) return;
    Navigator.pushNamed(context, 'login');
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
        Padding(padding: const EdgeInsets.only(left:30, right:30, top:30),
          child:
          Column(
            children: [

            // 推荐
            Expanded(child:
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(S.current.recm, style: const TextStyle(fontSize: 20, fontFamily: "MPlusRounded1c")),
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

        /// Messages page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    'Hello',
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  'Hi!',
                ),
              ),
            );
          },
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