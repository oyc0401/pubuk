import 'dart:io';

void main() async {
  final filename = 'file.txt';
  var file = await File(filename).writeAsString('some content');
  // Do something with the file.
}