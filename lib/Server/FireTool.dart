// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ntp/ntp.dart';
//
//
// class FireTool {
//   String collectionName = '';
//   String docName = '';
//
//   FireTool({
//     required this.docName,
//   });
//
//   static Future<Map> readFirstMap() async {
//     Map map = {};
//     await FirebaseFirestore.instance
//         .collection('pubuk')
//         .orderBy('date', descending: true)
//         .limit(1)
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       map = jsonConversion.text(querySnapshot.docs[0].data() as Map);
//     });
//     return map;
//   }
//
//   static Future<List<Map>> readTexts(String date) async {
//     List<Map> list = [];
//     await FirebaseFirestore.instance
//         .collection('pubuk')
//         .orderBy('date', descending: true)
//         .startAfter([date])
//         .limit(10)
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//           querySnapshot.docs.forEach((map) {
//             list.add(jsonConversion.text(map.data() as Map));
//           });
//         });
//     return list;
//   }
//
//   static Future<List<Map>> readComments(String textID) async {
//     List<Map> list = [];
//     await FirebaseFirestore.instance
//         .collection('pubuk')
//         .doc(textID)
//         .collection('comment')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((map) {
//         list.add(jsonConversion.text(map.data() as Map));
//       });
//     });
//     return list;
//   }
//
//   static Future<List<Map>> readReplies(String textID, String commentID) async {
//     List<Map> list = [];
//     await FirebaseFirestore.instance
//         .collection('pubuk')
//         .doc(textID)
//         .collection('comment')
//         .doc(commentID)
//         .collection('reply')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((map) {
//         list.add(jsonConversion.text(map.data() as Map));
//       });
//     });
//     return list;
//   }
//
//   Future<String> LocalTime() async {
//     DateTime startDate = DateTime.now().toLocal();
//     int offset = await NTP.getNtpOffset(localTime: startDate);
//     print('네트워크 시간: ${startDate.add(Duration(milliseconds: offset))}');
//     String date = "${startDate.add(Duration(milliseconds: offset))}";
//     return date;
//   }
// }
//
// class jsonConversion {
//   /// 나중에 db에 새로운 필드가 추가될 것을 대비해서 만든 클래스
//
//   static Map text(Map json) {
//     // 인수 9개
//     String ID = json['ID'] ?? 'oo';
//     String text = json['text'] ?? '내용이 없습니다.';
//     String userid = json['userid'] ?? '알수없는 사용자';
//     String nickname = json['nickname'] ?? '닉네임이 없습니다';
//     String date = json['date'] ?? '';
//     String image = json['image'] ?? '';
//
//     String title = json['title'] ?? '제목';
//     int heart = json['heart'] ?? 0;
//     int comment = json['comment'] ?? 0;
//     String auth = json['auth'] ?? 'student';
//
//     final Json = {
//       "ID": ID,
//       "userid": userid,
//       "nickname": nickname,
//       "date": date,
//       "text": text,
//       "image": image,
//       'title': title,
//       'heart': heart,
//       'comment': comment,
//       'auth': auth,
//     };
//
//     return Json;
//   }
// }
