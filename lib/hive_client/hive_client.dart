import 'package:hive/hive.dart';

void insertNewSession(Map<String, dynamic> sessionData) {
  var box = Hive.box('sessions');

}

String getSession() {
  var box = Hive.box('sessions');
  return box.get('session', defaultValue: "null");
}

void deleteSession() {
  var box = Hive.box('sessions');
  box.delete('session');
}
