// init() async {
//   for (String code in UnivName.univCodeList) {
//     String name = UnivName.getUnivName(code);
//     int where = name.indexOf("대학교");
//     String message = name.substring(0, where+3);
//     // print("code: $code, name: $name, massage: $message");
//
//
//     bool isMain=!name.contains("[");
//
//     //print("$name");
//     UnivData univdata = await down(message,isMain);
//     //
//     univdata.code = code;
//     univdata.name = UnivName.getUnivName(code);
//     returnMap["\"$code\""] = univdata.toPrint();
//   }
//   print(returnMap);
//   text = returnMap.toString();
//   setState(() {});
// }
//
// Future<UnivData> down(String message,isMain) async {
//   UnivType univType=UnivType.main;
//   if(isMain==false){
//     univType=UnivType.branch;
//   }
//
//   // print("$message, $univType");
//
//   UnivDownloader univDownloader =
//   UnivDownloader(univName: message, univType: univType);
//   await univDownloader.downLoad();
//   UnivData univData = univDownloader.getData();
//   //print(univDownloader.Json);
//   //print(univData);
//   return univData;
//
//   // return UnivData(code: "code", name: "name", link: "link", location: "location");
// }
//
// class UnivDownloader {
//   String univName;
//   UnivType univType;
//
//   UnivDownloader({
//     required this.univName,
//     required this.univType,
//   });
//
//   late Map<String, dynamic> Json;
//
//   Future<void> downLoad() async => Json = await _getJson();
//
//   UnivData getData() => univDataFromJson(Json);
//
//   Uri _MyUri() {
//     Uri uri = Uri.parse(
//         "https://www.career.go.kr/cnet/openapi/getOpenApi?apiKey=42a1daf5ceb9674aa3e23b4f44b83335"
//             "&svcType=api&svcCode=SCHOOL&contentType=json&gubun=univ_list&sch1=100323&sch2=100329"
//             "&searchSchulNm=$univName");
//     return uri;
//   }
//
//   Future<Map<String, dynamic>> _getJson() async {
//     // uri값 얻고
//     Uri uri = _MyUri();
//
//     // 요청하기
//     final Response response = await http.get(uri);
//
//     // 요청 성공하면 리턴
//     if (response.statusCode == 200) {
//       //print("대학정보 url: $uri");
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to load post');
//     }
//   }
//
//   UnivData univDataFromJson(Map<String, dynamic> json) {
//     String link = "error";
//     String location = "error";
//     String name = "error";
//
//     List? list = json['dataSearch']?['content'];
//
//     if (list == null) {
//       print("불러오지 못했습니다.");
//     } else {
//       int lenght = list.length;
//
//
//       //assert(lenght<3, "대학 이름을 더 정확히 적어야합니다.");
//       if (lenght == 1) {
//         for (Map map in list) {
//           name = map['schoolName'];
//           link = map['link'];
//           location = map['adres'];
//           break;
//         }
//       } else if (lenght == 0) {
//         print("$univName, 감지된 대학 수: $lenght");
//         name = "찾을 수 없습니다.";
//         print("\n");
//       } else {
//         print("$univName, 감지된 대학 수: $lenght");
//         for (Map map in list) {
//           switch(univType){
//             case UnivType.main:
//               if(map['campusName']=="본교"){
//                 name = map['schoolName'];
//                 link = map['link'];
//                 location = map['adres'];
//               }else{
//                 name = map['schoolName'];
//                 link = '링크 알 수 없습니다.';
//                 location = '알 수 없습니다.';
//                 print(map);
//               }
//               break;
//             case UnivType.branch:
//               name = map['schoolName'];
//               link = '링크 알 수 없습니다.';
//               location = '알 수 없습니다.';
//               print(map);
//               break;
//           }
//         }
//         print("\n");
//       }
//
//       // switch (univType) {
//       //   case UnivType.main:
//       //     for (Map map in list) {
//       //       if (map['campusName'] == "본교") {
//       //         univName = map['schoolName'];
//       //         link = map['link'];
//       //         location = map['adres'];
//       //         break;
//       //       }
//       //     }
//       //     break;
//       //   case UnivType.branch:
//       //     for (Map map in list) {
//       //       if (map['campusName'] != "본교") {
//       //         univName = map['schoolName'];
//       //         link = map['link'];
//       //         location = map['adres'];
//       //         break;
//       //       }
//       //     }
//       //     break;
//       // }
//
//     }
//
//     return UnivData(
//       code: "",
//       name: name,
//       link: link,
//       location: location,
//     );
//   }
// }
//
// enum UnivType { main, branch }