void main() {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  print('test1: ' + emailRegex.hasMatch('sdlkfghsglh@yahool.com.mx').toString());
}
