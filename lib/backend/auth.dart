import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

Client client = Client().setProject('678a72290036051ffd0a');

Account account = Account(client);

Future<String> createUser(String email, String password) async {
  try {
    User user = await account.create(
        userId: ID.unique(), email: email, password: password);
    print(user.$id);
  } on AppwriteException catch (e) {
    return e.message.toString();
  }
  return 'success';
}

Future<String> loginUser(String email, String password) async {
  try {
    Session session = await account.createEmailPasswordSession(
        email: email, password: password);
    print(session.$id);

    // insertNewSession(session.$id);
  } on AppwriteException catch (e) {
    return e.message.toString();
  }
  return 'success';
}

void checkUserSession(BuildContext context) async {
  try {
    final user = await account.get().timeout(Duration(seconds: 10));
    print('User is logged in ${user.email}');
    Navigator.pushReplacementNamed(context, 'home');
  } catch (e) {
    if (e is TimeoutException) {
      print('Network timeout, please try again later.');
      Navigator.pushReplacementNamed(context, 'login');
      // Handle timeout, e.g., show a dialog or retry option
    } else {
      print('User is not logged in');
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
