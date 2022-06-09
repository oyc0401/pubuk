import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterschool/DB/userProfile.dart';
import 'package:ntp/ntp.dart';

class FireUser {
  String uid;
  DocumentReference<Map<String, dynamic>> userDoc;

  FireUser({required this.uid})
      : userDoc = FirebaseFirestore.instance.collection('user').doc(uid);

  Future<UserProfile?> getUserProfile() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userDoc.get();
    print(snapshot.data());

    Map<String, dynamic>? map = snapshot.data();
    print(map);
    if (map != null) {
      return UserProfile.FirebaseUser(map);
    } else {
      return null;
    }
  }

  Future<void> setGrade({required int grade, required int Class}) async {
    await userDoc.update({
      'grade': grade,
      'class': Class,
    }).then((value) async {
      print('grade Update');
    }).catchError((error) => print("Failed to change grade: $error"));
  }

  Future<void> checkRegister(
      {required Function onExist, // 유저 데이터가 존재할 때
      required Function onNotExist // 유저 데이터가 없을 때
      }) async {
    // 회원가입을 했는지 판단하는 함수
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userDoc.get();
    Map? map = snapshot.data();

    if (snapshot.exists) {
      print("유저 정보가 있습니다. user: ${map}");
      onExist();
    } else {
      print("유저 정보가 없습니다.");
      onNotExist();
    }
  }
}

class FireTool {
  String collectionName = '';
  String docName = '';

  FireTool({
    required this.docName,
  });

  static Future<Map> readFirstMap() async {
    Map map = {};
    await FirebaseFirestore.instance
        .collection('pubuk')
        .orderBy('date', descending: true)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      map = jsonConversion.text(querySnapshot.docs[0].data() as Map);
    });
    return map;
  }

  static Future<List<Map>> readTexts(String date) async {
    List<Map> list = [];
    await FirebaseFirestore.instance
        .collection('pubuk')
        .orderBy('date', descending: true)
        .startAfter([date])
        .limit(10)
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((map) {
            list.add(jsonConversion.text(map.data() as Map));
          });
        });
    return list;
  }

  static Future<List<Map>> readComments(String textID) async {
    List<Map> list = [];
    await FirebaseFirestore.instance
        .collection('pubuk')
        .doc(textID)
        .collection('comment')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((map) {
        list.add(jsonConversion.text(map.data() as Map));
      });
    });
    return list;
  }

  static Future<List<Map>> readReplies(String textID, String commentID) async {
    List<Map> list = [];
    await FirebaseFirestore.instance
        .collection('pubuk')
        .doc(textID)
        .collection('comment')
        .doc(commentID)
        .collection('reply')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((map) {
        list.add(jsonConversion.text(map.data() as Map));
      });
    });
    return list;
  }

  Future<String> LocalTime() async {
    DateTime startDate = DateTime.now().toLocal();
    int offset = await NTP.getNtpOffset(localTime: startDate);
    print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
    String date = "${startDate.add(Duration(milliseconds: offset))}";
    return date;
  }
}

class jsonConversion {
  /// 나중에 db에 새로운 필드가 추가될 것을 대비해서 만든 클래스

  static Map text(Map json) {
    // 인수 9개
    String ID = json['ID'] ?? 'oo';
    String text = json['text'] ?? '내용이 없습니다.';
    String userid = json['userid'] ?? '알수없는 사용자';
    String nickname = json['nickname'] ?? '닉네임이 없습니다';
    String date = json['date'] ?? '';
    String image = json['image'] ?? '';

    String title = json['title'] ?? '제목';
    int heart = json['heart'] ?? 0;
    int comment = json['comment'] ?? 0;
    String auth = json['auth'] ?? 'student';

    final Json = {
      "ID": ID,
      "userid": userid,
      "nickname": nickname,
      "date": date,
      "text": text,
      "image": image,
      'title': title,
      'heart': heart,
      'comment': comment,
      'auth': auth,
    };

    return Json;
  }
}
