import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientService {
  SupabaseClientService._();
  static final SupabaseClientService instance = SupabaseClientService._();

  late final SupabaseClient client;

  Future<void> init() async {
    await Supabase.initialize(
      authOptions: FlutterAuthClientOptions(autoRefreshToken: true),
      url: 'https://xijaobuybkpfmyxcrobo.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhpamFvYnV5YmtwZm15eGNyb2JvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTE5MzA5MSwiZXhwIjoyMDc0NzY5MDkxfQ.O6wV2umI_9-OxIwuGS7O62Y_FsGBHelWOBgXE38aKnk',
    );
    client = Supabase.instance.client;
  }
}
