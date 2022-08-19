import 'package:cloud_firestore/cloud_firestore.dart';
import '../DB/userProfile.dart';

abstract class MapContainer {
  Map<String, dynamic> toMap();
}

/// firebase store의 user 문서를 다루는 객체
/// user 문서는 사용자의 정보를 담고있다.
class FirebaseAirPort {
  FirebaseAirPort({required String uid}) : plain = FirebasePlain(uid: uid);

  final FirebasePlain plain;

  /// 얻어오기
  Future<UserSchool?> get() async {
    Map<String, dynamic>? map = await plain.get();

    // map이 null이 아니면 리턴
    return map == null ? null : UserSchool.fromMap(map);
  }

  /// 저장하기
  Future<void> set(MapContainer mapContainer) async {
    await plain.set(mapContainer.toMap());
  }

  /// 업데이트
  Future<void> update(MapContainer mapContainer) async {
    await plain.update(mapContainer.toMap());
  }

  /// 삭제
  Future<void> delete() async {
    await plain.delete();
  }
}

class FirebasePlain {
  FirebasePlain({required String uid})
      : userDoc = FirebaseFirestore.instance.collection('user').doc(uid);

  final DocumentReference<Map<String, dynamic>> userDoc;

  /// 얻어오기
  Future<Map<String, dynamic>?> get() async {
    // 정보 얻어오기
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userDoc
        .get()
        .catchError((error) => print("Failed to get document: $error"));

    Map<String, dynamic>? map = snapshot.data();

    return map;
  }

  /// 저장하기
  Future<void> set(Map<String, dynamic> map) async {
    await userDoc
        .set(map)
        .then((value) => print('firebase store에 정보 설정하기 성공!'))
        .catchError(
            (error) => print("Firebase.set: Failed to Sign in: $error"));
  }

  /// 업데이트
  Future<void> update(Map<String, dynamic> map) async {
    await userDoc
        .update(map)
        .then((value) => print('유저 정보 업데이트 완료!'))
        .catchError((error) => print("Failed to change grade: $error"));
  }

  /// 삭제
  Future<void> delete() async {
    userDoc
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
}
