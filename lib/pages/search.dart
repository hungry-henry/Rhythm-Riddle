import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: Container(
          padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width > 600 ? 35 : 15,
            left: 13,
          ),
          height: 38,
          alignment: Alignment.center,
          child: TextField(
            controller: _controller, // 关联控制器
            decoration: InputDecoration(
              hintText: S.current.search,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: TextButton(
                onPressed: () {
                  String searchQuery = _controller.text; // 获取输入内容
                  search(searchQuery);
                },
                child: const Icon(Icons.search),
              ),
            ),
            onSubmitted: (value) {
              search(value);
            },
          ),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(searchResults[index]),
            );
          },
        ),
      ),
    );
  }

  Future<void> search(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        searchResults.add(query); // 将搜索查询添加到数组中
      });
    }
  }
}
