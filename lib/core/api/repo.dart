import 'package:supabase_flutter/supabase_flutter.dart';

import '../supabase/supabase_client.dart';

class ApiRepo {
  final SupabaseClient client = SupabaseClientService.instance.client;
}
