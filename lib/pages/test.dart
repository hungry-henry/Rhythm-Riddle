import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String _data = "permission check";

  Future<bool> _checkPermission(Permission permission) async {
    if (Platform.isAndroid) {
      var status = await permission.status;
      if (!status.isGranted) {
        // 申请权限
        await permission.request();
        // 重新获取权限状态
        var newStatus = await permission.status;
        if (newStatus.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
  }


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  child: Text("check notification perm"),
                  onPressed: () async {
                    bool permission = await _checkPermission(Permission.notification);
                    if(permission){
                      setState(() {
                        _data = "notification permission granted";
                      });
                    }else{
                      setState(() {
                        _data = "notification permission denied";
                      });
                    }
                  },
                ),
              ),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  child: Text("check install perm"),
                  onPressed: () async {
                    bool permission = await _checkPermission(Permission.requestInstallPackages);
                    if(permission){
                      setState(() {
                        _data = "install permission granted";
                      });
                    }else{
                      setState(() {
                        _data = "install permission denied";
                      });
                    }
                  },
                ),
              )
            ],
          ),
          Text(_data, textAlign: TextAlign.center)
        ]
      ),
    );
  }
}