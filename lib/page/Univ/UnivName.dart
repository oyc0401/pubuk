import 'package:geolocator/geolocator.dart';

/// static 으로 함수를 모아놓은 클래스
class UnivName {

  /// 거리가 포함된 대학 객체들을 얻습니다.
  static List<UnivData> univDatas(
      {required double longitude, required double latitude}) {
    // 반환할 리스트를 선언한다.
    List<UnivData> datas = [];

    // 거리 측정 하는 GeolocatorPlatform 도 선언한다.
    GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;

    // map을 한바퀴 돌면서 UnivData 모델로 만들고 리스트에 추가한다.
    univInformations.forEach((key, map) {
      UnivData univData = UnivData.fromMap(map);

      // 거리 구하기
      univData.distance = geolocatorPlatform.distanceBetween(
          latitude, longitude, univData.latitude, univData.longitude);
      datas.add(univData);
    });
    return datas;
  }

  /// 한가지 대학의 UnivData를 얻을 때 사용하는 함수
  static UnivData getUnivData(
      {required String univCode,
      required double longitude,
      required double latitude}) {
    Map map = univInformations[univCode]!;
    UnivData univData = UnivData.fromMap(map);

    GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
    univData.distance = geolocatorPlatform.distanceBetween(
        latitude, longitude, univData.latitude, univData.longitude);

    return univData;
  }

  /// UnivCode를 입력하면 대학 이름을 주는 함수
  static String getUnivName(String univCode) {
    Map? map = univInformations[univCode];
    return map?["name"] ?? "이름을 찾을 수 없습니다.";
  }
}

class UnivData {
  UnivData({
    required this.code,
    required this.name,
    required this.link,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.distance = 0,
  });

  String code;
  String name;
  String link;
  String location;
  double latitude;
  double longitude;
  double distance;

  /// distance를 km 단위로 만들어준다.
  String getKm() {
    return (distance / 1000).toStringAsFixed(2);
  }

  String getAddress() {
    String address = location;
    if (address.contains("(")) {
      int where = address.indexOf(" (");
      address = address.substring(0, where);
    }
    return address;
  }

  Map toMap() {
    return {
      "code": code,
      "name": name,
      "link": link,
      "location": location,
      "distance": distance,
    };
  }

  static UnivData fromMap(Map map) {
    return UnivData(
      code: map['code'],
      name: map['name'],
      link: map['link'],
      location: map['location'],
      longitude: map['longitude'],
      latitude: map['latitude'],
    );
  }

  Map toPrint() {
    return {
      "\"code\"": "\"$code\"",
      "\"name\"": "\"$name\"",
      "\"link\"": "\"$link\"",
      "\"location\"": "\"$location\"",
      "\"longitude\"": "$longitude",
      "\"latitude\"": "$latitude",
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

// 2022.6.16 대학들
// 분교가 3개 이상인 대학은 없다.
final Map<String, Map<String, dynamic>> univInformations = {
  "0002748": {
    "code": "0002748",
    "name": "가야대학교(김해)",
    "link": "http://www.kaya.ac.kr",
    "location": "경상남도 김해시 삼계로 208 (삼계동)",
    "longitude": 128.8725421,
    "latitude": 35.269369
  },
  "0000063": {
    "code": "0000063",
    "name": "가천대학교",
    "link": "http://www.gachon.ac.kr",
    "location": "경기도 성남시 수정구 성남대로 1342 (복정동, 가천대학교)",
    "longitude": 127.1307015,
    "latitude": 37.4523915
  },
  "0000072": {
    "code": "0000072",
    "name": "가톨릭관동대학교",
    "link": "http://www.cku.ac.kr",
    "location": "강원도 강릉시 범일로579번길 24 (내곡동, 가톨릭관동대학교)",
    "longitude": 128.8739922,
    "latitude": 37.7358498
  },
  "0000215": {
    "code": "0000215",
    "name": "가톨릭꽃동네대학교",
    "link": "https://www.kkot.ac.kr",
    "location": "충청북도 청주시 서원구 현도면 상삼길 133",
    "longitude": 127.4011946,
    "latitude": 36.5221196
  },
  "0000046": {
    "code": "0000046",
    "name": "가톨릭대학교",
    "link": "https://www.catholic.ac.kr/",
    "location": "경기도 부천시 지봉로 43",
    "longitude": 126.8016995,
    "latitude": 37.4862534
  },
  "0000050": {
    "code": "0000050",
    "name": "감리교신학대학교",
    "link": "http://www.mtu.ac.kr",
    "location": "서울특별시 서대문구 독립문로 56 (냉천동, 감리교신학대학)",
    "longitude": 126.9621585,
    "latitude": 37.5675717
  },
  "0000051": {
    "code": "0000051",
    "name": "강남대학교",
    "link": "http://www.kangnam.ac.kr",
    "location": "경기도 용인시 기흥구 강남로 40 (구갈동, 강남대학교)",
    "longitude": 127.1327214,
    "latitude": 37.2747616
  },
  "0000001": {
    "code": "0000001",
    "name": "강릉원주대학교",
    "link": "http://www.gwnu.ac.kr",
    "location": "강원도 강릉시 죽헌길 7",
    "longitude": 128.8701111,
    "latitude": 37.7706676
  },
  "0000079": {
    "code": "0000079",
    "name": "강서대학교",
    "link": "https://gangseo.ac.kr/",
    "location": "서울특별시 강서구 까치산로24길 47",
    "longitude": 126.8548772,
    "latitude": 37.5486261
  },
  "0000003": {
    "code": "0000003",
    "name": "강원대학교",
    "link": "http://www.kangwon.ac.kr",
    "location": "강원도 춘천시 강원대학길 1 (효자동, 강원대학교)",
    "longitude": 127.7438324,
    "latitude": 37.8684418
  },
  "0000004": {
    "code": "0000004",
    "name": "강원대학교[제2캠퍼스]",
    "link": "http://www.kangwon.ac.kr",
    "location": "강원도 삼척시 중앙로 346 (교동, 강원대학교삼척캠퍼스)",
    "longitude": 129.161989,
    "latitude": 37.4534416
  },
  "0000052": {
    "code": "0000052",
    "name": "건국대학교",
    "link": "http://www.konkuk.ac.kr",
    "location": "서울특별시 광진구 능동로 120 (화양동, 건국대학교)",
    "longitude": 127.0759546,
    "latitude": 37.5438883
  },
  "0000053": {
    "code": "0000053",
    "name": "건국대학교(글로컬)[분교]",
    "link": "http://www.kku.ac.kr",
    "location": "충청북도 충주시 충원대로 268 (단월동, 건국대학교GLOCAL캠퍼스)",
    "longitude": 127.907532,
    "latitude": 36.9494179
  },
  "0000054": {
    "code": "0000054",
    "name": "건양대학교",
    "link": "http://www.konyang.ac.kr",
    "location": "충청남도 논산시 대학로 121 (내동, 건양대학교)",
    "longitude": 127.1114387,
    "latitude": 36.1827999
  },
  "0000056": {
    "code": "0000056",
    "name": "경기대학교",
    "link": "http://www.kyonggi.ac.kr",
    "location": "경기도 수원시 영통구 광교산로 154-42 (이의동, 경기대학교)",
    "longitude": 127.0347399,
    "latitude": 37.3005585
  },
  "0000059": {
    "code": "0000059",
    "name": "경남대학교",
    "link": "http://www.kyungnam.ac.kr",
    "location": "경상남도 창원시 마산합포구 경남대학로 7 (월영동, 경남대학교)",
    "longitude": 128.5532458,
    "latitude": 35.1801979
  },
  "0000060": {
    "code": "0000060",
    "name": "경동대학교",
    "link": "http://www.kduniv.ac.kr",
    "location": "경기도 양주시 경동대학로 27 (고암동)",
    "longitude": 127.071429,
    "latitude": 37.809463
  },
  "0000005": {
    "code": "0000005",
    "name": "경북대학교",
    "link": "http://www.knu.ac.kr",
    "location": "대구광역시 북구 대학로 80 (산격동, 경북대학교)",
    "longitude": 128.6121117,
    "latitude": 35.8905477
  },
  "0003118": {
    "code": "0003118",
    "name": "경상국립대학교",
    "link": "http://www.gnu.ac.kr",
    "location": "경상남도 진주시 진주대로 501",
    "longitude": 128.0985941,
    "latitude": 35.1538877
  },
  "0000062": {
    "code": "0000062",
    "name": "경성대학교",
    "link": "http://ks.ac.kr",
    "location": "부산광역시 남구 수영로 309 (대연동, 경성대학교)",
    "longitude": 129.0969338,
    "latitude": 35.1422457
  },
  "0000244": {
    "code": "0000244",
    "name": "경운대학교",
    "link": "http://www.ikw.ac.kr",
    "location": "경상북도 구미시 산동면 강동로 730 (인덕리, 경운대학교)",
    "longitude": 128.4680712,
    "latitude": 36.1716993
  },
  "0000256": {
    "code": "0000256",
    "name": "경인교육대학교",
    "link": "https://www.ginue.ac.kr",
    "location": "인천광역시 계양구 계산로 62",
    "longitude": 126.7170352,
    "latitude": 37.538251
  },
  "0000064": {
    "code": "0000064",
    "name": "경일대학교",
    "link": "http://www.kiu.ac.kr",
    "location": "경상북도 경산시 하양읍 가마실길 50 (부호리, 경일대학교)",
    "longitude": 128.801112,
    "latitude": 35.90729
  },
  "0000065": {
    "code": "0000065",
    "name": "경주대학교",
    "link": "http://www.gu.ac.kr",
    "location": "경상북도 경주시 태종로 188 (효현동, 경주대학교)",
    "longitude": 129.16305,
    "latitude": 35.8294
  },
  "0000066": {
    "code": "0000066",
    "name": "경희대학교",
    "link": "http://www.khu.ac.kr",
    "location": "서울특별시 동대문구 경희대로 26 (회기동, 경희대학교)",
    "longitude": 127.0525009,
    "latitude": 37.5964494
  },
  "0000068": {
    "code": "0000068",
    "name": "계명대학교",
    "link": "http://www.kmu.ac.kr",
    "location": "대구광역시 달서구 달구벌대로 1095 (신당동, 계명대학교성서캠퍼스)",
    "longitude": 128.4836385,
    "latitude": 35.8590028
  },
  "0000069": {
    "code": "0000069",
    "name": "고려대학교",
    "link": "http://www.korea.ac.kr",
    "location": "서울특별시 성북구 안암로 145 (안암동5가, 고려대학교안암캠퍼스(인문사회계))",
    "longitude": 127.0318122,
    "latitude": 37.5899103
  },
  "0000070": {
    "code": "0000070",
    "name": "고려대학교(세종)[분교]",
    "link": "http://sejong.korea.ac.kr",
    "location": "세종특별자치시 조치원읍 세종로 2511 (서창리, 고려대학교세종캠퍼스)",
    "longitude": 127.2857059,
    "latitude": 36.6101822
  },
  "0000071": {
    "code": "0000071",
    "name": "고신대학교",
    "link": "http://www.kosin.ac.kr",
    "location": "부산광역시 영도구 와치로 194 (동삼동, 고신대학교)",
    "longitude": 129.06313,
    "latitude": 35.0789636
  },
  "0000251": {
    "code": "0000251",
    "name": "공주교육대학교",
    "link": "http://www.gjue.ac.kr",
    "location": "충청남도 공주시 웅진로 27 (봉황동, 공주교육대학교)",
    "longitude": 127.119253,
    "latitude": 36.4448772
  },
  "0000008": {
    "code": "0000008",
    "name": "공주대학교",
    "link": "http://www.kongju.ac.kr",
    "location": "충청남도 공주시 공주대학로 56 (신관동, 공주대학교)",
    "longitude": 127.141,
    "latitude": 36.4702096
  },
  "0000073": {
    "code": "0000073",
    "name": "광신대학교",
    "link": "http://www.kwangshin.ac.kr",
    "location": "광주광역시 북구 양산택지소로 36 (본촌동, 광신대학교)",
    "longitude": 126.885071,
    "latitude": 35.2157286
  },
  "0000074": {
    "code": "0000074",
    "name": "광운대학교",
    "link": "http://www.kw.ac.kr",
    "location": "서울특별시 노원구 광운로 20 (월계동, 광운대학교)",
    "longitude": 127.0584363,
    "latitude": 37.6197992
  },
  "0000075": {
    "code": "0000075",
    "name": "광주가톨릭대학교",
    "link": "http://www.gjcatholic.ac.kr",
    "location": "전라남도 나주시 남평읍 중남길 12-25 (남석리, 광주가톨릭대학교)",
    "longitude": 126.8650625,
    "latitude": 35.01545
  },
  "0000252": {
    "code": "0000252",
    "name": "광주교육대학교",
    "link": "http://www.gnue.ac.kr",
    "location": "광주광역시 북구 필문대로 55 (풍향동, 광주교육대학교)",
    "longitude": 126.9269527,
    "latitude": 35.1647158
  },
  "0000231": {
    "code": "0000231",
    "name": "광주대학교",
    "link": "http://www.gwangju.ac.kr",
    "location": "광주광역시 남구 효덕로 277 (진월동, 광주대학교)",
    "longitude": 126.8960122,
    "latitude": 35.1072019
  },
  "0000076": {
    "code": "0000076",
    "name": "광주여자대학교",
    "link": "http://www.kwu.ac.kr",
    "location": "광주광역시 광산구 광주여대길 45",
    "longitude": 126.7953702,
    "latitude": 35.1626515
  },
  "0000078": {
    "code": "0000078",
    "name": "국민대학교",
    "link": "http://www.kookmin.ac.kr",
    "location": "서울특별시 성북구 정릉로 77 (정릉동, 국민대학교)",
    "longitude": 126.9969024,
    "latitude": 37.6108107
  },
  "0000009": {
    "code": "0000009",
    "name": "군산대학교",
    "link": "http://www.kunsan.ac.kr",
    "location": "전라북도 군산시 대학로 558 (미룡동, 군산대학교)",
    "longitude": 126.6814342,
    "latitude": 35.9470944
  },
  "0000080": {
    "code": "0000080",
    "name": "극동대학교",
    "link": "http://www.kdu.ac.kr",
    "location": "충청북도 음성군 감곡면 대학길 76-32 (왕장리, 극동대학교)",
    "longitude": 127.6430234,
    "latitude": 37.1275842
  },
  "0000224": {
    "code": "0000224",
    "name": "금강대학교",
    "link": "http://www.ggu.ac.kr",
    "location": "충청남도 논산시 상월면 상월로 522 (대명리, 금강대학교)",
    "longitude": 127.195511,
    "latitude": 36.3058031
  },
  "0000010": {
    "code": "0000010",
    "name": "금오공과대학교",
    "link": "http://www.kumoh.ac.kr",
    "location": "경상북도 구미시 대학로 61 (양호동, 금오공과대학교)",
    "longitude": 128.3934519,
    "latitude": 36.1463163
  },
  "0000241": {
    "code": "0000241",
    "name": "김천대학교",
    "link": "http://www.gimcheon.ac.kr",
    "location": "경상북도 김천시 대학로 214 (삼락동, 김천대학교)",
    "longitude": 128.0805228,
    "latitude": 36.1395578
  },
  "0000081": {
    "code": "0000081",
    "name": "나사렛대학교",
    "link": "http://www.kornu.ac.kr",
    "location": "충청남도 천안시 서북구 월봉로 48 (쌍용동, 나사렛대학교)",
    "longitude": 127.119583,
    "latitude": 36.7962396
  },
  "0000216": {
    "code": "0000216",
    "name": "남부대학교",
    "link": "http://www.nambu.ac.kr",
    "location": "광주광역시 광산구 남부대길 11",
    "longitude": 126.8415722,
    "latitude": 35.2063368
  },
  "0000245": {
    "code": "0000245",
    "name": "남서울대학교",
    "link": "http://www.nsu.ac.kr",
    "location": "충청남도 천안시 서북구 성환읍 대학로 91 (매주리, 남서울대학교)",
    "longitude": 127.1447235,
    "latitude": 36.9095318
  },
  "0000082": {
    "code": "0000082",
    "name": "단국대학교",
    "link": "http://www.dankook.ac.kr",
    "location": "경기도 용인시 수지구 죽전로 152 (죽전동, 단국대학교죽전캠퍼스)",
    "longitude": 127.1276811,
    "latitude": 37.3207278
  },
  "0002726": {
    "code": "0002726",
    "name": "단국대학교[제2캠퍼스]",
    "link": "http://www.dankook.ac.kr",
    "location": "충청남도 천안시 동남구 단대로 119 (안서동, 단국대학교천안캠퍼스)",
    "longitude": 127.1685007,
    "latitude": 36.8373833
  },
  "0000088": {
    "code": "0000088",
    "name": "대구가톨릭대학교",
    "link": "http://www.cu.ac.kr",
    "location": "경상북도 경산시 하양읍 하양로 13-13 (금락리, 대구가톨릭대학교)",
    "longitude": 128.807588,
    "latitude": 35.912174
  },
  "0000253": {
    "code": "0000253",
    "name": "대구교육대학교",
    "link": "http://www.dnue.ac.kr",
    "location": "대구광역시 남구 중앙대로 219 (대명동, 대구교육대학교)",
    "longitude": 128.5889174,
    "latitude": 35.8530252
  },
  "0000084": {
    "code": "0000084",
    "name": "대구대학교",
    "link": "http://www.daegu.ac.kr",
    "location": "경상북도 경산시 진량읍 대구대로 201 (내리리, 대구대학교경산캠퍼스)",
    "longitude": 128.8491,
    "latitude": 35.901049
  },
  "0000087": {
    "code": "0000087",
    "name": "대구예술대학교",
    "link": "http://www.dgau.ac.kr",
    "location": "경상북도 칠곡군 가산면 다부거문1길 202 (다부리, 대구예술대학교)",
    "longitude": 128.5104925,
    "latitude": 36.0333405
  },
  "0000061": {
    "code": "0000061",
    "name": "대구한의대학교",
    "link": "http://www.dhu.ac.kr",
    "location": "경상북도 경산시 한의대로 1 (유곡동, 대구한의대학교)",
    "longitude": 128.7754765,
    "latitude": 35.7950097
  },
  "0000093": {
    "code": "0000093",
    "name": "대신대학교",
    "link": "http://www.daeshin.ac.kr",
    "location": "경상북도 경산시 경청로222길 33 (백천동, 대신대학교)",
    "longitude": 128.7441875,
    "latitude": 35.8038667
  },
  "0000094": {
    "code": "0000094",
    "name": "대전가톨릭대학교",
    "link": "http://dcatholic.ac.kr",
    "location": "세종특별자치시 전의면 가톨릭대학로 30 (신방리, 대전가톨릭대학교)",
    "longitude": 127.1967813,
    "latitude": 36.654991
  },
  "0000095": {
    "code": "0000095",
    "name": "대전대학교",
    "link": "http://www.dju.ac.kr",
    "location": "대전광역시 동구 대학로 62 (용운동, 대전대학교)",
    "longitude": 127.4606466,
    "latitude": 36.3343597
  },
  "0000238": {
    "code": "0000238",
    "name": "대전신학대학교",
    "link": "http://www.daejeon.ac.kr",
    "location": "대전광역시 대덕구 한남로 41 (오정동, 대전신학대학교)",
    "longitude": 127.4237649,
    "latitude": 36.3499843
  },
  "0000097": {
    "code": "0000097",
    "name": "대진대학교",
    "link": "http://www.daejin.ac.kr",
    "location": "경기도 포천시 호국로 1007 (선단동, 대진대학교)",
    "longitude": 127.1573986,
    "latitude": 37.8734346
  },
  "0000099": {
    "code": "0000099",
    "name": "덕성여자대학교",
    "link": "http://www.duksung.ac.kr",
    "location": "서울특별시 도봉구 삼양로144길 33 (쌍문동, 덕성여자대학교)",
    "longitude": 127.0166028,
    "latitude": 37.6515354
  },
  "0000100": {
    "code": "0000100",
    "name": "동국대학교",
    "link": "http://www.dongguk.edu",
    "location": "서울특별시 중구 필동로1길 30 (장충동2가, 동국대학교)",
    "longitude": 127.0001869,
    "latitude": 37.5582582
  },
  "0000101": {
    "code": "0000101",
    "name": "동국대학교(WISE)[분교]",
    "link": "http://web.dongguk.ac.kr",
    "location": "경상북도 경주시 동대로 123 (석장동, 동국대학교경주캠퍼스)",
    "longitude": 129.1946221,
    "latitude": 35.8636659
  },
  "0000102": {
    "code": "0000102",
    "name": "동덕여자대학교",
    "link": "http://www.dongduk.ac.kr",
    "location": "서울특별시 성북구 화랑로13길 60 (하월곡동, 동덕여자대학교)",
    "longitude": 127.0419803,
    "latitude": 37.6068369
  },
  "0000235": {
    "code": "0000235",
    "name": "동명대학교",
    "link": "http://www.tu.ac.kr",
    "location": "부산광역시 남구 신선로 428 (용당동, 동명대학교)",
    "longitude": 129.1016625,
    "latitude": 35.1220654
  },
  "0000103": {
    "code": "0000103",
    "name": "동서대학교",
    "link": "http://www.dongseo.ac.kr",
    "location": "부산광역시 사상구 주례로 47 (주례동, 동서대학교)",
    "longitude": 129.00845,
    "latitude": 35.1449821
  },
  "0000104": {
    "code": "0000104",
    "name": "동신대학교",
    "link": "http://www.dsu.ac.kr",
    "location": "전라남도 나주시 동신대길 67 (대호동, 동신대학교중앙도서관동)",
    "longitude": 126.7179925,
    "latitude": 35.0496249
  },
  "0000105": {
    "code": "0000105",
    "name": "동아대학교",
    "link": "http://www.donga.ac.kr",
    "location": "부산광역시 사하구 낙동대로550번길 37 (하단동, 동아대학교)",
    "longitude": 128.9675077,
    "latitude": 35.1161349
  },
  "0000106": {
    "code": "0000106",
    "name": "동양대학교",
    "link": "http://www.dyu.ac.kr",
    "location": "경상북도 영주시 풍기읍 동양대로 145 (산법리, 동양대학교)",
    "longitude": 128.5335281,
    "latitude": 36.8818808
  },
  "0000107": {
    "code": "0000107",
    "name": "동의대학교",
    "link": "http://www.deu.ac.kr",
    "location": "부산광역시 부산진구 엄광로 176 (가야동, 동의대학교)",
    "longitude": 129.034615,
    "latitude": 35.1418304
  },
  "0000108": {
    "code": "0000108",
    "name": "루터대학교",
    "link": "http://www.ltu.ac.kr",
    "location": "경기도 용인시 기흥구 금화로82번길 20 (상갈동, 루터대학교)",
    "longitude": 127.1128925,
    "latitude": 37.2647653
  },
  "0000109": {
    "code": "0000109",
    "name": "명지대학교",
    "link": "http://www.mju.ac.kr",
    "location": "서울특별시 서대문구 거북골로 34 (남가좌동, 명지대학교)",
    "longitude": 126.9230255,
    "latitude": 37.580597
  },
  "0000112": {
    "code": "0000112",
    "name": "목원대학교",
    "link": "http://www.mokwon.ac.kr",
    "location": "대전광역시 서구 도안북로 88 (도안동, 목원대학교)",
    "longitude": 127.3386258,
    "latitude": 36.3261041
  },
  "0000221": {
    "code": "0000221",
    "name": "목포가톨릭대학교",
    "link": "http://www.mcu.ac.kr",
    "location": "전라남도 목포시 영산로 697 (석현동, 목포가톨릭대학교)",
    "longitude": 126.4195875,
    "latitude": 34.8268917
  },
  "0000011": {
    "code": "0000011",
    "name": "목포대학교",
    "link": "http://www.mokpo.ac.kr",
    "location": "전라남도 무안군 청계면 영산로 1666 (도림리, 목포대학교)",
    "longitude": 126.4350194,
    "latitude": 34.9083883
  },
  "0000012": {
    "code": "0000012",
    "name": "목포해양대학교",
    "link": "http://www.mmu.ac.kr",
    "location": "전라남도 목포시 해양대학로 91 (죽교동, 목포해양대학교)",
    "longitude": 126.365053,
    "latitude": 34.7917765
  },
  "0000113": {
    "code": "0000113",
    "name": "배재대학교",
    "link": "http://www.pcu.ac.kr",
    "location": "대전광역시 서구 배재로 155-40 (도마동, 배재대학교)",
    "longitude": 127.3652283,
    "latitude": 36.320202
  },
  "0000178": {
    "code": "0000178",
    "name": "백석대학교",
    "link": "http://www.bu.ac.kr",
    "location": "충청남도 천안시 동남구 문암로 76 (안서동, 백석대학교)",
    "longitude": 127.181294,
    "latitude": 36.8416629
  },
  "0000013": {
    "code": "0000013",
    "name": "부경대학교",
    "link": "http://www.pknu.ac.kr",
    "location": "부산광역시 남구 용소로 45 (대연동, 부경대학교대연캠퍼스)",
    "longitude": 129.1059875,
    "latitude": 35.1335487
  },
  "0000114": {
    "code": "0000114",
    "name": "부산가톨릭대학교",
    "link": "http://www.cup.ac.kr",
    "location": "부산광역시 금정구 오륜대로 57 (부곡동, 부산가톨릭대학교)",
    "longitude": 129.0975492,
    "latitude": 35.244704
  },
  "0000254": {
    "code": "0000254",
    "name": "부산교육대학교",
    "link": "http://www.bnue.ac.kr",
    "location": "부산광역시 연제구 교대로 24 (거제동, 부산교육대학교)",
    "longitude": 129.0741436,
    "latitude": 35.1964877
  },
  "0000014": {
    "code": "0000014",
    "name": "부산대학교",
    "link": "http://www.pusan.ac.kr",
    "location": "부산광역시 금정구 부산대학로63번길 2 (장전동, 부산대학교)",
    "longitude": 129.0798453,
    "latitude": 35.2333798
  },
  "0000115": {
    "code": "0000115",
    "name": "부산외국어대학교",
    "link": "http://www.bufs.ac.kr",
    "location": "부산광역시 금정구 금샘로485번길 65 (남산동, 부산외국어대학교)",
    "longitude": 129.07905,
    "latitude": 35.26705
  },
  "0000222": {
    "code": "0000222",
    "name": "부산장신대학교",
    "link": "http://www.bpu.ac.kr",
    "location": "경상남도 김해시 김해대로 1894-68 (구산동)",
    "longitude": 128.8615246,
    "latitude": 35.2577406
  },
  "0000116": {
    "code": "0000116",
    "name": "삼육대학교",
    "link": "http://www.syu.ac.kr",
    "location": "서울특별시 노원구 화랑로 815 (공릉동, 삼육대학교)",
    "longitude": 127.1042695,
    "latitude": 37.6429794
  },
  "0000117": {
    "code": "0000117",
    "name": "상명대학교",
    "link": "http://www.smu.ac.kr",
    "location": "서울특별시 종로구 홍지문2길 20 (홍지동, 상명대학교)",
    "longitude": 126.9551533,
    "latitude": 37.6027666
  },
  "0002959": {
    "code": "0002959",
    "name": "상명대학교[제2캠퍼스]",
    "link": "http://www.smuc.ac.kr",
    "location": "충청남도 천안시 동남구 상명대길 31 (안서동, 상명대학교천안캠퍼스)",
    "longitude": 127.1791304,
    "latitude": 36.8334726
  },
  "0000119": {
    "code": "0000119",
    "name": "상지대학교",
    "link": "http://www.sangji.ac.kr",
    "location": "강원도 원주시 상지대길 83 (우산동, 상지대학교)",
    "longitude": 127.9300762,
    "latitude": 37.3697534
  },
  "0000120": {
    "code": "0000120",
    "name": "서강대학교",
    "link": "http://www.sogang.ac.kr",
    "location": "서울특별시 마포구 백범로 35 (신수동, 서강대학교)",
    "longitude": 126.9410634,
    "latitude": 37.5517132
  },
  "0000121": {
    "code": "0000121",
    "name": "서경대학교",
    "link": "http://www.skuniv.ac.kr",
    "location": "서울특별시 성북구 서경로 124 (정릉동, 서경대학)",
    "longitude": 127.0133575,
    "latitude": 37.6150457
  },
  "0000036": {
    "code": "0000036",
    "name": "서울과학기술대학교",
    "link": "http://www.seoultech.ac.kr",
    "location": "서울특별시 노원구 공릉로 232 (공릉동, 서울과학기술대학교)",
    "longitude": 127.0783723,
    "latitude": 37.6316217
  },
  "0000255": {
    "code": "0000255",
    "name": "서울교육대학교",
    "link": "http://www.snue.ac.kr",
    "location": "서울특별시 서초구 서초중앙로 96 (서초동, 서울교육대학교,서울교대초등학교)",
    "longitude": 127.0168607,
    "latitude": 37.4903779
  },
  "0000098": {
    "code": "0000098",
    "name": "서울기독대학교",
    "link": "http://www.scu.ac.kr",
    "location": "서울특별시 은평구 갈현로4길 26-2 (신사동, 서울기독대학교)",
    "longitude": 126.9125713,
    "latitude": 37.6008716
  },
  "0000019": {
    "code": "0000019",
    "name": "서울대학교",
    "link": "http://www.snu.ac.kr",
    "location": "서울특별시 관악구 관악로 1 (신림동, 서울대학교)",
    "longitude": 126.9522394,
    "latitude": 37.464007
  },
  "0000040": {
    "code": "0000040",
    "name": "서울시립대학교",
    "link": "http://www.uos.ac.kr",
    "location": "서울특별시 동대문구 서울시립대로 163 (전농동, 서울시립대학교)",
    "longitude": 127.0600071,
    "latitude": 37.5825812
  },
  "0000125": {
    "code": "0000125",
    "name": "서울신학대학교",
    "link": "http://www.stu.ac.kr",
    "location": "경기도 부천시 호현로489번길 52 (소사본동, 서울신학대학교)",
    "longitude": 126.7889548,
    "latitude": 37.479502
  },
  "0000126": {
    "code": "0000126",
    "name": "서울여자대학교",
    "link": "http://www.swu.ac.kr",
    "location": "서울특별시 노원구 화랑로 621 (공릉동, 서울여자대학교)",
    "longitude": 127.0904235,
    "latitude": 37.6280329
  },
  "0000127": {
    "code": "0000127",
    "name": "서울장신대학교",
    "link": "http://www.sjs.ac.kr",
    "location": "경기도 광주시 경안로 145 (경안동, 서울장신대학교)",
    "longitude": 127.2462171,
    "latitude": 37.4100211
  },
  "0000205": {
    "code": "0000205",
    "name": "서울한영대학교",
    "link": "http://www.hytu.ac.kr",
    "location": "서울특별시 구로구 경인로 290-42 (개봉동, 한영신학대학교)",
    "longitude": 126.8515463,
    "latitude": 37.4964113
  },
  "0000128": {
    "code": "0000128",
    "name": "서원대학교",
    "link": "http://www.seowon.ac.kr",
    "location": "충청북도 청주시 서원구 무심서로 377-3 (모충동, 서원대학교)",
    "longitude": 127.4810766,
    "latitude": 36.6245008
  },
  "0000129": {
    "code": "0000129",
    "name": "선문대학교",
    "link": "http://www.sunmoon.ac.kr",
    "location": "충청남도 아산시 탕정면 선문로221번길 70 (갈산리, 선문대학교)",
    "longitude": 127.0749055,
    "latitude": 36.799147
  },
  "0000131": {
    "code": "0000131",
    "name": "성결대학교",
    "link": "http://www.sungkyul.edu",
    "location": "경기도 안양시 만안구 성결대학로 53 (안양동, 성결대학교)",
    "longitude": 126.9266623,
    "latitude": 37.3799
  },
  "0000132": {
    "code": "0000132",
    "name": "성공회대학교",
    "link": "http://www.skhu.ac.kr",
    "location": "서울특별시 구로구 연동로 320 (항동, 성공회대학교)",
    "longitude": 126.8255598,
    "latitude": 37.4877974
  },
  "0000133": {
    "code": "0000133",
    "name": "성균관대학교",
    "link": "http://www.skku.edu",
    "location": "서울특별시 종로구 성균관로 25-2 (명륜3가, 성균관대학교)",
    "longitude": 126.9921594,
    "latitude": 37.5879535
  },
  "0000136": {
    "code": "0000136",
    "name": "성신여자대학교",
    "link": "http://www.sungshin.ac.kr",
    "location": "서울특별시 성북구 보문로34다길 2 (돈암동, 성신여자대학교)",
    "longitude": 127.0228833,
    "latitude": 37.5915171
  },
  "0000137": {
    "code": "0000137",
    "name": "세명대학교",
    "link": "http://www.semyung.ac.kr",
    "location": "충청북도 제천시 세명로 65 (신월동, 세명대학교)",
    "longitude": 128.196837,
    "latitude": 37.181051
  },
  "0000138": {
    "code": "0000138",
    "name": "세종대학교",
    "link": "http://www.sejong.ac.kr",
    "location": "서울특별시 광진구 능동로 209 (군자동, 세종대학교)",
    "longitude": 127.073884,
    "latitude": 37.5514706
  },
  "0000092": {
    "code": "0000092",
    "name": "세한대학교",
    "link": "http://www.sehan.ac.kr",
    "location": "전라남도 영암군 삼호읍 녹색로 1113 (산호리, 세한대학교)",
    "longitude": 126.4863441,
    "latitude": 34.7509384
  },
  "0000243": {
    "code": "0000243",
    "name": "송원대학교",
    "link": "http://www.songwon.ac.kr",
    "location": "광주광역시 남구 송암로 73 (송하동, 송원대학)",
    "longitude": 126.8740705,
    "latitude": 35.1091923
  },
  "0000139": {
    "code": "0000139",
    "name": "수원가톨릭대학교",
    "link": "http://www.suwoncatholic.ac.kr",
    "location": "경기도 화성시 봉담읍 왕림1길 67 (왕림리, 수원가톨릭대학교)",
    "longitude": 126.9341701,
    "latitude": 37.1946126
  },
  "0000140": {
    "code": "0000140",
    "name": "수원대학교",
    "link": "http://suwon.ac.kr",
    "location": "경기도 화성시 봉담읍 와우안길 17 (와우리, 수원대학교)",
    "longitude": 126.9765717,
    "latitude": 37.2087424
  },
  "0000141": {
    "code": "0000141",
    "name": "숙명여자대학교",
    "link": "http://www.sookmyung.ac.kr",
    "location": "서울특별시 용산구 청파로47길 100 (청파동2가, 숙명여자대학교)",
    "longitude": 126.9645778,
    "latitude": 37.5459469
  },
  "0000020": {
    "code": "0000020",
    "name": "순천대학교",
    "link": "http://www.sunchon.ac.kr",
    "location": "전라남도 순천시 중앙로 255 (석현동, 순천대학교)",
    "longitude": 127.4809015,
    "latitude": 34.9689184
  },
  "0000142": {
    "code": "0000142",
    "name": "순천향대학교",
    "link": "http://www.sch.ac.kr",
    "location": "충청남도 아산시 신창면 순천향로 22 (읍내리, 순천향대학교)",
    "longitude": 126.932338,
    "latitude": 36.7700865
  },
  "0000143": {
    "code": "0000143",
    "name": "숭실대학교",
    "link": "http://www.ssu.ac.kr",
    "location": "서울특별시 동작구 상도로 369 (상도동, 숭실대학교)",
    "longitude": 126.9575041,
    "latitude": 37.4966895
  },
  "0000233": {
    "code": "0000233",
    "name": "신경대학교",
    "link": "http://www.sgu.ac.kr",
    "location": "경기도 화성시 남양읍 남양중앙로 400-5 (남양리, 신경대학교)",
    "longitude": 126.8395132,
    "latitude": 37.2027514
  },
  "0000144": {
    "code": "0000144",
    "name": "신라대학교",
    "link": "http://www.silla.ac.kr",
    "location": "부산광역시 사상구 백양대로700번길 140 (괘법동, 신라대학교)",
    "longitude": 128.9977086,
    "latitude": 35.1682792
  },
  "0002712": {
    "code": "0002712",
    "name": "신한대학교",
    "link": "http://www.shinhan.ac.kr",
    "location": "경기도 의정부시 호암로 95 (호원동, 신한대학교)",
    "longitude": 127.0449589,
    "latitude": 37.7100953
  },
  "0002800": {
    "code": "0002800",
    "name": "신한대학교[제2캠퍼스]",
    "link": "http://www.shinhan.ac.kr",
    "location": "경기도 동두천시 벌마들로40번길 30 (상패동, 신한대학교)",
    "longitude": 127.0361651,
    "latitude": 37.904154
  },
  "0000145": {
    "code": "0000145",
    "name": "아신대학교",
    "link": "https://www.acts.ac.kr/",
    "location": "경기도 양평군 옥천면 경강로 1276 KR",
    "longitude": 127.4282043,
    "latitude": 37.5111175
  },
  "0000146": {
    "code": "0000146",
    "name": "아주대학교",
    "link": "http://www.ajou.ac.kr",
    "location": "경기도 수원시 영통구 월드컵로 206 (원천동, 아주대학교)",
    "longitude": 127.0453396,
    "latitude": 37.2823216
  },
  "0000021": {
    "code": "0000021",
    "name": "안동대학교",
    "link": "http://www.andong.ac.kr",
    "location": "경상북도 안동시 경동로 1375 (송천동, 안동대학교)",
    "longitude": 128.7971386,
    "latitude": 36.5422432
  },
  "0000147": {
    "code": "0000147",
    "name": "안양대학교",
    "link": "http://www.anyang.ac.kr",
    "location": "경기도 안양시 만안구 삼덕로37번길 22 (안양동, 안양대학교)",
    "longitude": 126.9197909,
    "latitude": 37.3912403
  },
  "0000149": {
    "code": "0000149",
    "name": "연세대학교",
    "link": "http://www.yonsei.ac.kr",
    "location": "서울특별시 서대문구 연세로 50 (신촌동, 연세대학교)",
    "longitude": 126.9390292,
    "latitude": 37.5671131
  },
  "0000150": {
    "code": "0000150",
    "name": "연세대학교(미래)[분교]",
    "link": "http://www.yonsei.ac.kr",
    "location": "강원도 원주시 흥업면 연세대길 1 (매지리, 연세대학교)",
    "longitude": 127.901,
    "latitude": 37.280875
  },
  "0000151": {
    "code": "0000151",
    "name": "영남대학교",
    "link": "http://www.yu.ac.kr",
    "location": "경상북도 경산시 대학로 280 (대동, 영남대학교)",
    "longitude": 128.7575093,
    "latitude": 35.8325351
  },
  "0000153": {
    "code": "0000153",
    "name": "영남신학대학교",
    "link": "http://www.ytus.ac.kr",
    "location": "경상북도 경산시 진량읍 봉회1길 26 (봉회리, 영남신학대학교)",
    "longitude": 128.8164971,
    "latitude": 35.880636
  },
  "0000236": {
    "code": "0000236",
    "name": "영산대학교",
    "link": "http://www.ysu.ac.kr",
    "location": "경상남도 양산시 주남로 288 (주남동, 영산대학교양산캠퍼스)",
    "longitude": 129.146125,
    "latitude": 35.4286096
  },
  "0000155": {
    "code": "0000155",
    "name": "영산선학대학교",
    "link": "http://www.youngsan.ac.kr",
    "location": "전라남도 영광군 백수읍 성지로 1357 (길용리)",
    "longitude": 126.4421021,
    "latitude": 35.3271143
  },
  "0000228": {
    "code": "0000228",
    "name": "예수대학교",
    "link": "http://www.jesus.ac.kr",
    "location": "전라북도 전주시 완산구 서원로 383 (중화산동1가, 예수대학교)",
    "longitude": 127.1351375,
    "latitude": 35.815575
  },
  "0000218": {
    "code": "0000218",
    "name": "예원예술대학교",
    "link": "http://www.yewon.ac.kr",
    "location": "전라북도 임실군 신평면 창인로 117 (창인리, 예원예술학교)",
    "longitude": 127.2703758,
    "latitude": 35.6467719
  },
  "0000156": {
    "code": "0000156",
    "name": "용인대학교",
    "link": "http://www.yongin.ac.kr",
    "location": "경기도 용인시 처인구 용인대학로 134 (삼가동, 용인대학교)",
    "longitude": 127.1678561,
    "latitude": 37.2270152
  },
  "0000157": {
    "code": "0000157",
    "name": "우석대학교",
    "link": "http://www.woosuk.ac.kr",
    "location": "전라북도 완주군 삼례읍 삼례로 443 (후정리, 우석대학교)",
    "longitude": 127.0659877,
    "latitude": 35.9127996
  },
  "0000240": {
    "code": "0000240",
    "name": "우송대학교",
    "link": "http://www.wsu.ac.kr",
    "location": "대전광역시 동구 동대전로 171 (자양동, 우송정보대학,우송대서캠퍼스)",
    "longitude": 127.4457331,
    "latitude": 36.3356936
  },
  "0000158": {
    "code": "0000158",
    "name": "울산대학교",
    "link": "http://www.ulsan.ac.kr",
    "location": "울산광역시 남구 대학로 93 (무거동, 울산대학교)",
    "longitude": 129.2561333,
    "latitude": 35.5437482
  },
  "0000159": {
    "code": "0000159",
    "name": "원광대학교",
    "link": "http://www.wonkwang.ac.kr",
    "location": "전라북도 익산시 익산대로 460 (신동, 원광대학교)",
    "longitude": 126.9557171,
    "latitude": 35.96783
  },
  "0000160": {
    "code": "0000160",
    "name": "위덕대학교",
    "link": "http://www.uu.ac.kr",
    "location": "경상북도 경주시 강동면 동해대로 261 (유금리, 위덕대학교)",
    "longitude": 129.2837978,
    "latitude": 36.0126541
  },
  "0000154": {
    "code": "0000154",
    "name": "유원대학교",
    "link": "http://www.u1.ac.kr",
    "location": "충청북도 영동군 영동읍 대학로 310 (설계리, U1대학교)",
    "longitude": 127.7979886,
    "latitude": 36.1954376
  },
  "0000161": {
    "code": "0000161",
    "name": "을지대학교",
    "link": "http://www.eulji.ac.kr",
    "location": "경기도 성남시 수정구 산성대로 553 (양지동, 을지대학교)",
    "longitude": 127.1653979,
    "latitude": 37.4611948
  },
  "0000163": {
    "code": "0000163",
    "name": "이화여자대학교",
    "link": "http://www.ewha.ac.kr",
    "location": "서울특별시 서대문구 이화여대길 52 (대현동, 이화여자대학교)",
    "longitude": 126.9472448,
    "latitude": 37.5617396
  },
  "0000164": {
    "code": "0000164",
    "name": "인제대학교",
    "link": "http://www.inje.ac.kr",
    "location": "경상남도 김해시 인제로 197 (어방동, 인제대학교)",
    "longitude": 128.9026673,
    "latitude": 35.2487277
  },
  "0000168": {
    "code": "0000168",
    "name": "인천가톨릭대학교",
    "link": "http://www.iccu.ac.kr",
    "location": "인천광역시 강화군 양도면 고려왕릉로 53-1 (도장리)",
    "longitude": 126.4477375,
    "latitude": 37.6575487
  },
  "0000167": {
    "code": "0000167",
    "name": "인천가톨릭대학교[제2캠퍼스]",
    "link": "http://www.iccu.ac.kr",
    "location": "인천광역시 연수구 해송로 12 (송도동, 인천가톨릭대학교)",
    "longitude": 126.6446512,
    "latitude": 37.3831407
  },
  "0002660": {
    "code": "0002660",
    "name": "인천대학교",
    "link": "http://www.inu.ac.kr",
    "location": "인천광역시 연수구 아카데미로 119 (송도동, 인천대학교)",
    "longitude": 126.6332532,
    "latitude": 37.3754977
  },
  "0000169": {
    "code": "0000169",
    "name": "인하대학교",
    "link": "http://www.inha.ac.kr",
    "location": "인천광역시 남구 인하로 100 (용현동, 인하대학교)",
    "longitude": 126.6538126,
    "latitude": 37.4507292
  },
  "0000170": {
    "code": "0000170",
    "name": "장로회신학대학교",
    "link": "http://www.puts.ac.kr",
    "location": "서울특별시 광진구 광장로5길 25-1 (광장동, 장로회신학대학교)",
    "longitude": 127.1040572,
    "latitude": 37.5503345
  },
  "0000023": {
    "code": "0000023",
    "name": "전남대학교",
    "link": "http://www.jnu.ac.kr",
    "location": "광주광역시 북구 용봉로 77 (용봉동, 전남대학교)",
    "longitude": 126.9080453,
    "latitude": 35.1778193
  },
  "0000025": {
    "code": "0000025",
    "name": "전북대학교",
    "link": "http://www.jbnu.ac.kr",
    "location": "전라북도 전주시 덕진구 백제대로 567 (금암동, 전북대학교)",
    "longitude": 127.1320049,
    "latitude": 35.8462574
  },
  "0000258": {
    "code": "0000258",
    "name": "전주교육대학교",
    "link": "http://WWW.JNUE.KR",
    "location": "전라북도 전주시 완산구 서학로 50 (동서학동, 전주교육대학교)",
    "longitude": 127.1551917,
    "latitude": 35.8087125
  },
  "0000171": {
    "code": "0000171",
    "name": "전주대학교",
    "link": "http://www.jj.ac.kr",
    "location": "전라북도 전주시 완산구 천잠로 303 (효자동2가, 전주대학교)",
    "longitude": 127.0901464,
    "latitude": 35.8141581
  },
  "0000248": {
    "code": "0000248",
    "name": "제주국제대학교",
    "link": "http://www.jeju.ac.kr",
    "location": "제주특별자치도 제주시 516로 2870 (영평동)",
    "longitude": 126.5703877,
    "latitude": 33.4404296
  },
  "0000027": {
    "code": "0000027",
    "name": "제주대학교",
    "link": "http://www.jejunu.ac.kr",
    "location": "제주특별자치도 제주시 제주대학로 102 (아라일동, 제주대학교)",
    "longitude": 126.5623921,
    "latitude": 33.455902
  },
  "0000172": {
    "code": "0000172",
    "name": "조선대학교",
    "link": "http://www.chosun.ac.kr",
    "location": "광주광역시 동구 필문대로 309 (서석동, 조선대학교)",
    "longitude": 126.934625,
    "latitude": 35.142882
  },
  "0000173": {
    "code": "0000173",
    "name": "중부대학교",
    "link": "http://www.joongbu.ac.kr",
    "location": "충청남도 금산군 추부면 대학로 201 (마전리, 중부대학교)",
    "longitude": 127.4501711,
    "latitude": 36.1929411
  },
  "0000175": {
    "code": "0000175",
    "name": "중앙대학교",
    "link": "http://www.cau.ac.kr",
    "location": "서울특별시 동작구 흑석로 84 (흑석동, 중앙대학교)",
    "longitude": 126.9573779,
    "latitude": 37.5048875
  },
  "0000177": {
    "code": "0000177",
    "name": "중앙승가대학교",
    "link": "http://admission.sangha.ac.kr",
    "location": "경기도 김포시 승가로 123 (풍무동)",
    "longitude": 126.7065093,
    "latitude": 37.6047675
  },
  "0000239": {
    "code": "0000239",
    "name": "중원대학교",
    "link": "http://www.jwu.ac.kr",
    "location": "충청북도 괴산군 괴산읍 문무로 85 (동부리, 중원대학교)",
    "longitude": 127.7991125,
    "latitude": 36.8195441
  },
  "0000260": {
    "code": "0000260",
    "name": "진주교육대학교",
    "link": "http://www.cue.ac.kr",
    "location": "경상남도 진주시 진양호로369번길 3 (신안동, 진주교육대학교)",
    "longitude": 128.0670038,
    "latitude": 35.1863618
  },
  "0000187": {
    "code": "0000187",
    "name": "차의과학대학교",
    "link": "http://www.cha.ac.kr",
    "location": "경기도 포천시 해룡로 120 (동교동, 포천중문의과대학)",
    "longitude": 127.1377673,
    "latitude": 37.8579006
  },
  "0000249": {
    "code": "0000249",
    "name": "창신대학교",
    "link": "http://www.cs.ac.kr",
    "location": "경상남도 창원시 마산회원구 팔용로 262 (합성동, 창신대학)",
    "longitude": 128.599675,
    "latitude": 35.2442062
  },
  "0000028": {
    "code": "0000028",
    "name": "창원대학교",
    "link": "http://www.changwon.ac.kr",
    "location": "경상남도 창원시 의창구 창원대학로 20 (사림동, 창원대학교)",
    "longitude": 128.6948168,
    "latitude": 35.2459596
  },
  "0000284": {
    "code": "0000284",
    "name": "청운대학교",
    "link": "https://home.chungwoon.ac.kr/",
    "location": "충청남도 홍성군 홍성읍 대학길 25",
    "longitude": 126.662625,
    "latitude": 36.582225
  },
  "0000261": {
    "code": "0000261",
    "name": "청주교육대학교",
    "link": "http://www.cje.ac.kr",
    "location": "충청북도 청주시 서원구 청남로 2065 (수곡동, 청주교육대학교)",
    "longitude": 127.4850572,
    "latitude": 36.6164054
  },
  "0000179": {
    "code": "0000179",
    "name": "청주대학교",
    "link": "http://www.cju.ac.kr",
    "location": "충청북도 청주시 청원구 대성로 298 (내덕동, 청주대학교)",
    "longitude": 127.4957084,
    "latitude": 36.6531853
  },
  "0000246": {
    "code": "0000246",
    "name": "초당대학교",
    "link": "https://www.cdu.ac.kr/",
    "location": "전라남도 무안군 무안읍 무안로 380",
    "longitude": 126.4735349,
    "latitude": 34.9776261
  },
  "0000180": {
    "code": "0000180",
    "name": "총신대학교",
    "link": "http://www.chongshin.ac.kr",
    "location": "서울특별시 동작구 사당로 143 (사당동, 총신대학교)",
    "longitude": 126.9669811,
    "latitude": 37.4892845
  },
  "0000181": {
    "code": "0000181",
    "name": "추계예술대학교",
    "link": "http://www.chugye.ac.kr",
    "location": "서울특별시 서대문구 북아현로11가길 7 (북아현동, 추계예술대학교)",
    "longitude": 126.9536152,
    "latitude": 37.5630397
  },
  "0000262": {
    "code": "0000262",
    "name": "춘천교육대학교",
    "link": "http://www.cnue.ac.kr",
    "location": "강원도 춘천시 공지로 126 (석사동, 춘천교육대학교)",
    "longitude": 127.7475533,
    "latitude": 37.8592511
  },
  "0000029": {
    "code": "0000029",
    "name": "충남대학교",
    "link": "http://www.cnu.ac.kr",
    "location": "대전광역시 유성구 대학로 99 (궁동, 충남대학교)",
    "longitude": 127.3457442,
    "latitude": 36.366638
  },
  "0000030": {
    "code": "0000030",
    "name": "충북대학교",
    "link": "http://www.chungbuk.ac.kr",
    "location": "충청북도 청주시 서원구 충대로 1 (개신동, 충북대학교)",
    "longitude": 127.456014,
    "latitude": 36.6295503
  },
  "0000186": {
    "code": "0000186",
    "name": "평택대학교",
    "link": "http://www.ptu.ac.kr",
    "location": "경기도 평택시 서동대로 3825 (용이동, 평택대학교)",
    "longitude": 127.1334625,
    "latitude": 36.9952846
  },
  "0000188": {
    "code": "0000188",
    "name": "포항공과대학교",
    "link": "http://www.postech.ac.kr",
    "location": "경상북도 포항시 남구 청암로 77 (지곡동, 포항공과대학교)",
    "longitude": 129.3213012,
    "latitude": 36.0105883
  },
  "0000037": {
    "code": "0000037",
    "name": "한경대학교",
    "link": "http://www.hknu.ac.kr",
    "location": "경기도 안성시 중앙로 327 (석정동)",
    "longitude": 127.2640718,
    "latitude": 37.011667
  },
  "0000247": {
    "code": "0000247",
    "name": "한국공학대학교",
    "link": "https://www.tukorea.ac.kr/",
    "location": "경기도 시흥시 산기대학로 237",
    "longitude": 126.7335061,
    "latitude": 37.3400342
  },
  "0000031": {
    "code": "0000031",
    "name": "한국교원대학교",
    "link": "http://www.knue.ac.kr",
    "location": "충청북도 청주시 흥덕구 강내면 태성탑연로 250 (다락리, 한국교원대학교)",
    "longitude": 127.3588709,
    "latitude": 36.6109885
  },
  "0000034": {
    "code": "0000034",
    "name": "한국교통대학교",
    "link": "http://www.ut.ac.kr",
    "location": "충청북도 충주시 대소원면 대학로 50 (검단리, 한국교통대학교)",
    "longitude": 127.872252,
    "latitude": 36.9696921
  },
  "0000189": {
    "code": "0000189",
    "name": "한국기술교육대학교",
    "link": "http://www.koreatech.ac.kr",
    "location": "충청남도 천안시 동남구 병천면 충절로 1600 (가전리, 한국기술교육대학교)",
    "longitude": 127.2819829,
    "latitude": 36.7637515
  },
  "0000191": {
    "code": "0000191",
    "name": "한국성서대학교",
    "link": "http://www.bible.ac.kr",
    "location": "서울특별시 노원구 동일로214길 32 (상계동, 한국성서대학교)",
    "longitude": 127.0643529,
    "latitude": 37.648778
  },
  "0000192": {
    "code": "0000192",
    "name": "한국외국어대학교",
    "link": "http://www.hufs.ac.kr",
    "location": "서울특별시 동대문구 이문로 107 (이문동, 한국외국어대학교)",
    "longitude": 127.0582878,
    "latitude": 37.5973078
  },
  "0000032": {
    "code": "0000032",
    "name": "한국체육대학교",
    "link": "http://www.knsu.ac.kr",
    "location": "서울특별시 송파구 양재대로 1239 (방이동, 한국체육대학교)",
    "longitude": 127.1308626,
    "latitude": 37.5198884
  },
  "0000182": {
    "code": "0000182",
    "name": "한국침례신학대학교",
    "link": "https://www.kbtus.ac.kr/",
    "location": "대전광역시 유성구 북유성대로 190",
    "longitude": 127.3262805,
    "latitude": 36.3857325
  },
  "0000194": {
    "code": "0000194",
    "name": "한국항공대학교",
    "link": "http://www.kau.ac.kr",
    "location": "경기도 고양시 덕양구 항공대학로 76 (화전동, 한국항공대학교)",
    "longitude": 126.8644887,
    "latitude": 37.5997399
  },
  "0000033": {
    "code": "0000033",
    "name": "한국해양대학교",
    "link": "http://www.kmou.ac.kr",
    "location": "부산광역시 영도구 태종로 727 (동삼동, 한국해양대학교)",
    "longitude": 129.0892004,
    "latitude": 35.076358
  },
  "0000195": {
    "code": "0000195",
    "name": "한남대학교",
    "link": "http://www.hannam.ac.kr",
    "location": "대전광역시 대덕구 한남로 70 (오정동, 한남대학교)",
    "longitude": 127.4217991,
    "latitude": 36.3541173
  },
  "0000196": {
    "code": "0000196",
    "name": "한동대학교",
    "link": "http://www.handong.edu",
    "location": "경상북도 포항시 북구 흥해읍 한동로 558 (남송리, 한동대학교)",
    "longitude": 129.3881109,
    "latitude": 36.1036575
  },
  "0000197": {
    "code": "0000197",
    "name": "한라대학교",
    "link": "http://www.halla.ac.kr",
    "location": "강원도 원주시 흥업면 한라대길 28 (흥업리, 한라대학교)",
    "longitude": 127.907488,
    "latitude": 37.302992
  },
  "0000198": {
    "code": "0000198",
    "name": "한림대학교",
    "link": "강원도 춘천시 한림대학길 1",
    "location": "강원도 춘천시 한림대학길 1 (옥천동, 한림대학교)",
    "longitude": 127.7382499,
    "latitude": 37.8872151
  },
  "0000039": {
    "code": "0000039",
    "name": "한밭대학교",
    "link": "http://www.hanbat.ac.kr",
    "location": "대전광역시 유성구 동서대로 125 (덕명동, 한밭대학교)",
    "longitude": 127.3014114,
    "latitude": 36.3520635
  },
  "0000199": {
    "code": "0000199",
    "name": "한서대학교",
    "link": "http://www.hanseo.ac.kr",
    "location": "충청남도 서산시 해미면 한서1로 46 (대곡리, 한서대학교)",
    "longitude": 126.5835864,
    "latitude": 36.6906314
  },
  "0000200": {
    "code": "0000200",
    "name": "한성대학교",
    "link": "http://www.hansung.ac.kr",
    "location": "서울특별시 성북구 삼선교로16길 116 (삼선동2가, 한성대학교)",
    "longitude": 127.0102929,
    "latitude": 37.5825084
  },
  "0000201": {
    "code": "0000201",
    "name": "한세대학교",
    "link": "http://www.hansei.ac.kr",
    "location": "경기도 군포시 한세로 30 (당정동, 한세대학교)",
    "longitude": 126.9528801,
    "latitude": 37.3465782
  },
  "0000202": {
    "code": "0000202",
    "name": "한신대학교",
    "link": "http://www.hs.ac.kr",
    "location": "경기도 오산시 한신대길 137 (양산동, 한신대학교)",
    "longitude": 127.0234105,
    "latitude": 37.1939449
  },
  "0000203": {
    "code": "0000203",
    "name": "한양대학교",
    "link": "http://www.hanyang.ac.kr",
    "location": "서울특별시 성동구 왕십리로 222 (사근동, 한양대학교)",
    "longitude": 127.0466112,
    "latitude": 37.5545036
  },
  "0000204": {
    "code": "0000204",
    "name": "한양대학교(ERICA)[분교]",
    "link": "http://www.hanyang.ac.kr",
    "location": "경기도 안산시 상록구 한양대학로 55 (사동, 한양대학교)",
    "longitude": 126.8353162,
    "latitude": 37.2954261
  },
  "0000206": {
    "code": "0000206",
    "name": "한일장신대학교",
    "link": "http://www.hanil.ac.kr",
    "location": "전라북도 완주군 상관면 왜목로 726-15 (신리, 한일장신대학교)",
    "longitude": 127.206375,
    "latitude": 35.76375
  },
  "0000207": {
    "code": "0000207",
    "name": "협성대학교",
    "link": "http://www.uhs.ac.kr",
    "location": "경기도 화성시 봉담읍 최루백로 72 (상리, 협성대학교)",
    "longitude": 126.9526872,
    "latitude": 37.2132877
  },
  "0000208": {
    "code": "0000208",
    "name": "호남대학교",
    "link": "http://www.honam.ac.kr",
    "location": "광주광역시 광산구 호남대길 100 (서봉동, 호남대학교광산캠퍼스)",
    "longitude": 126.7667707,
    "latitude": 35.1501328
  },
  "0000209": {
    "code": "0000209",
    "name": "호남신학대학교",
    "link": "http://www.htus.ac.kr",
    "location": "광주광역시 남구 제중로 77 (양림동, 호남신학대학교)",
    "longitude": 126.9114762,
    "latitude": 35.1404125
  },
  "0000211": {
    "code": "0000211",
    "name": "호서대학교",
    "link": "http://www.hoseo.ac.kr",
    "location": "충청남도 아산시 배방읍 호서로79번길 20 (세출리, 호서대학교)",
    "longitude": 127.0750254,
    "latitude": 36.7363588
  },
  "0000282": {
    "code": "0000282",
    "name": "호원대학교",
    "link": "https://www.howon.ac.kr/",
    "location": "전라북도 군산시 임피면 호원대3길 64",
    "longitude": 126.8648162,
    "latitude": 35.9667427
  },
  "0000212": {
    "code": "0000212",
    "name": "홍익대학교",
    "link": "http://www.hongik.ac.kr",
    "location": "서울특별시 마포구 와우산로 94 (상수동, 홍익대학교)",
    "longitude": 126.9255396,
    "latitude": 37.5512242
  }
};
