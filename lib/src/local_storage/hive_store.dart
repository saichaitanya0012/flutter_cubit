
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


class Keys {
  static const String token = 'token';
  static const String userId = 'userId';
  static const String userName = 'userName';
  static const String isManager = 'isManager';
  static const String isUser = 'isUser';
  static const String fcmUserId = 'fcmUserId';
  static const String imageUrl = "imageUrl";
}

class HiveStore {
  //Singleton Class
  static final HiveStore _default = HiveStore._internal();
  static late Box defBox;
  static late Box recentStocks;

  factory HiveStore() {
    return _default;
  }

  HiveStore._internal();

  static getInstance() {
    return _default;
  }

  initBox() async {
     await (openBox()).then((value)async {
       defBox =value;
       // await Hive.openBox('recentStocks');
    });
  }

  //Object Storage
  put(String key, Object value) async {
    defBox.put(key, value);
    debugPrint("HiveStored : Key:$key, Value:$value");
  }

  //Object Recent Storage
  // recentStocksPut(String key, RecentStocks value) async {
  //
  //   List<RecentStocks> stocks=[];
  //   stocks=get("recentStocks")??stocks;
  //   if(!stocks.contains(value)){
  //     if(stocks.length<5){
  //       stocks.add(value);
  //       put("recentStocks", stocks);
  //     }else{
  //       stocks.removeAt(4);
  //       stocks.insert(0,value);
  //       put("recentStocks", stocks);
  //     }
  //   }
  //   debugPrint("HiveStored : Key:$key, Value:$value");
  // }

  get(String key) {
    // print("Box is Open? ${defBox.isOpen}");
    debugPrint("Hive Retrieve : Key:$key, Value:${defBox.get(key)}");
    return defBox.get(key);
  }

  //String Storage
  setString(String key, String value) async {
    defBox.put(key, value);
    debugPrint("HiveStored : Key:$key, Value:$value");
  }

  getString(String key) {
    debugPrint("Hive Retrieve : Key:$key, Value:${defBox.get(key)}");
    return defBox.get(key);
  }

  //Bool Storage
  setBool(String key, bool value) async {
    defBox.put(key, value);
    debugPrint("HiveStored : Key:$key, Value:$value");
  }

  getBool(String key) {
    debugPrint("Hive Retrieve : Key:$key, Value:${defBox.get(key)}");
    return defBox.get(key);
  }

  clear() {
    defBox.clear();
  }

  remove(String key) async {
    defBox.delete(key);
  }

  Future openBox() async {
    if (!kIsWeb) {
      var dir = await getApplicationDocumentsDirectory();
      Hive.init(dir
          .path) /*..registerAdapter(ScheduleReminderAdapter(),override: true,internal: true)*/;
    }
    // Hive.registerAdapter(RecentStocksAdapter());
    return await Hive.openBox('Store');
  }
}
