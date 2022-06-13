import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterschool/Server/FireTool.dart';

import '../../DB/userProfile.dart';

abstract class Login {
  String? uid;

  Future<bool> login();

  Future<void> logout();

  Future<bool> deleteUser();

  Future<bool> reAuth();
}
