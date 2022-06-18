class Point {
  int x=1;
  int y=2;
}

class PointDetail extends Point {
  int z=3;
}

void main() {
  PointDetail p1 = PointDetail();
  p1.x = 4; // Use the setter method for x.
  p1.y = 5;
  p1.z = 6;

  Point p2 = p1;  //부모타입으로 캐스팅해서 막 사용하다가
  //...
  //...
  //...

  //다시 point detail의 z값에 접근하거나 사용해야할때.
  if (p2 is PointDetail) {
    PointDetail p3 = p2 as PointDetail; //다운 캐스팅 (is로 판단해서 한번 확인했기 때문에 as 생략가능)
    print(p3.z);
    print("ㅇㅇ");
  } else {
    print("ㄴㄴ");
  }
}