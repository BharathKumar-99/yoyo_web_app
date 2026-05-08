import 'package:supabase_flutter/supabase_flutter.dart';
void main() {
  final builder = SupabaseClient('https://a.b', 'c').from('d').select();
  builder.filter('categories', 'in', [1, 2]);
}
