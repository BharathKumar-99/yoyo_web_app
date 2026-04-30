void main() {
  final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
  print('test1: ' + emailRegex.hasMatch('sdlkfghsglh@yahool.com.mx').toString());
  print('test2: ' + emailRegex.hasMatch('foo_bar@yahoo.com.mx').toString());
  print('test3: ' + emailRegex.hasMatch('first.last@yahoo.com.mx').toString());
  print('test4: ' + emailRegex.hasMatch('first-last@yahoo.com.mx').toString());
  print('test5: ' + emailRegex.hasMatch('sdlkfghsglh@yahool.com.mx ').toString());
}
