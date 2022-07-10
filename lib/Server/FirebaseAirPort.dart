import 'package:cloud_firestore/cloud_firestore.dart';
import '../DB/userProfile.dart';

abstract class MapContainer {
  Map<String, dynamic> toMap();
}

class FirebaseAirPort {
  FirebaseAirPort({required String uid})
      : userDoc = FirebaseFirestore.instance.collection('user').doc(uid);

  final DocumentReference<Map<String, dynamic>> userDoc;

  /// 얻어오기
  Future<UserProfile?> get() async {


    // 정보 얻어오기
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userDoc
        .get()
        .catchError((error) => print("Failed to get document: $error"));

    Map<String, dynamic>? map = snapshot.data();

    // map이 null이 아니면 리턴
    if (map != null) {
      return UserProfile.fromMap(map);
    } else {
      return null;
    }
  }

  /// 저장하기
  Future<void> set(MapContainer mapContainer) async {
    await userDoc
        .set(mapContainer.toMap())
        .then((value) => print('firebase store에 정보 설정하기 성공!'))
        .catchError(
            (error) => print("Firebase.set: Failed to Sign in: $error"));
  }

  /// 업데이트
  Future<void> update(MapContainer mapContainer) async {
    await userDoc
        .update(mapContainer.toMap())
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

