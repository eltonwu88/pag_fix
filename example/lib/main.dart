import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pag/pag.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  GlobalKey<PAGViewState> _fansDanceKey = GlobalKey<PAGViewState>(debugLabel: _assetFans);
  GlobalKey<PAGViewState> _assetDanceKey = GlobalKey<PAGViewState>(debugLabel: _assetFans);
  GlobalKey<PAGViewState> get assetPagKey => _pagAsset == _assetFans ? _fansDanceKey : _assetDanceKey;

  final GlobalKey<PAGViewState> networkPagKey = GlobalKey<PAGViewState>();
  final GlobalKey<PAGViewState> bytesPagKey = GlobalKey<PAGViewState>();

  Uint8List? bytesData;

  // 本地加载资源
  static const String _assetFans = 'data/fans.pag';
  static const String _assetDance = 'data/dance.pag';
  static const String _assetError = 'data/error.pag';
  static const String _assetCar = 'data/car_pag_condition_bmp.pag';
  String _pagAsset = _assetCar;

  void changeAsset() {
    setState(() {
      // assetPagKey.currentState?.start();
      assetPagKey.currentState?.pause();
      assetPagKey.currentState?.setProgress(0.4);
    });
  }

  double pgs = 0.0;
  void changeAsset1() {
    setState(() {
      // assetPagKey.currentState?.start();
      assetPagKey.currentState?.pause();
      if(pgs >= 1.0){
        pgs = 0.0;
      }else{
        pgs += 0.1;
      }
      assetPagKey.currentState?.setProgress(pgs);
    });
  }

  @override
  void initState() {
    rootBundle.load("data/fans.pag").then((data) {
      setState(() {
        bytesData = Uint8List.view(data.buffer);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PAGView example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///TODO: PAGView加载本地资源
              Padding(
                padding: EdgeInsets.only(top: 20, left: 12, bottom: 20),
                child: Text(
                  "PAGEEEEView加载本地资源：",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: PAGView.asset(
                  _pagAsset,
                  repeatCount: PAGView.REPEAT_COUNT_LOOP,
                  initProgress: 0.25,
                  autoPlay: true,
                  key: assetPagKey,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12, top: 10),
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.pause_circle,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        // 暂停
                        assetPagKey.currentState?.stop();
                      },
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.play_circle,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        //播放
                        assetPagKey.currentState?.start();
                      },
                    ),
                    IconButton(
                        iconSize: 30,
                        icon: const Icon(
                          Icons.published_with_changes_sharp,
                          color: Colors.black54,
                        ),
                        onPressed: changeAsset),
                    Text(
                      "<= 请点击控制动画（可切换）",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                    IconButton(
                        iconSize: 30,
                        icon: const Icon(
                          Icons.published_with_changes_sharp,
                          color: Colors.black54,
                        ),
                        onPressed: changeAsset1),
                    Text(
                      "<= Setting progress",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              /// TODO: PAGView加载网络资源
              Padding(
                padding: EdgeInsets.only(top: 50, left: 12, bottom: 20),
                child: Text(
                  "PAGView加载网络资源：",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ),
              PAGView.network(
                "https://svipwebwx-30096.sz.gfp.tencent-cloud.com/file1647585475981.pag",
                repeatCount: PAGView.REPEAT_COUNT_LOOP,
                initProgress: 0.25,
                autoPlay: true,
                key: networkPagKey,
              ),
              Padding(
                padding: EdgeInsets.only(left: 12, top: 10),
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.pause_circle,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        // 暂停
                        networkPagKey.currentState?.pause();
                      },
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.play_circle,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        // 播放
                        networkPagKey.currentState?.start();
                      },
                    ),
                    Text(
                      "<= 请点击控制动画",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                  ],
                ),
              ),

              /// TODO: PAGView加载二进制资源
              Padding(
                padding: EdgeInsets.only(top: 50, left: 12, bottom: 20),
                child: Text(
                  "PAGView加载二进制资源：",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ),
              Visibility(
                  visible: bytesData?.isNotEmpty == true,
                  child: PAGView.bytes(
                    bytesData,
                    repeatCount: PAGView.REPEAT_COUNT_LOOP,
                    initProgress: 0.25,
                    autoPlay: true,
                    key: bytesPagKey,
                  )),
              Padding(
                padding: EdgeInsets.only(left: 12, top: 10),
                child: Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.pause_circle,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        // 暂停
                        bytesPagKey.currentState?.pause();
                      },
                    ),
                    IconButton(
                      iconSize: 30,
                      icon: const Icon(
                        Icons.play_circle,
                        color: Colors.black54,
                      ),
                      onPressed: () {
                        // 播放
                        bytesPagKey.currentState?.start();
                      },
                    ),
                    Text(
                      "<= 请点击控制动画",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                    ),
                  ],
                ),
              ),


              /// TODO: PAGView加载二进制资源
              Padding(
                padding: EdgeInsets.only(top: 20, left: 12, bottom: 20),
                child: Text(
                  "PAGView加载失败的默认占位图：",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                ),
              ),
              SizedBox(
                width: 100,
                height: 100,
                child: PAGView.asset(
                  _assetError,
                  repeatCount: PAGView.REPEAT_COUNT_LOOP,
                  initProgress: 0.25,
                  autoPlay: true,
                  defaultBuilder: (context){
                    return Container(
                      color: Colors.grey,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(16),
                      child: Text("load fail"),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
