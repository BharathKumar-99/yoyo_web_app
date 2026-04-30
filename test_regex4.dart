void main() {
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  print('test1: ' + emailRegex.hasMatch('sdlkfghsglh@yahool.com.mx').toString());
}
