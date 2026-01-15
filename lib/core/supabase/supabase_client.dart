import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';

class SupabaseClientService {
  SupabaseClientService._();
  static final SupabaseClientService instance = SupabaseClientService._();

  late final SupabaseClient client;

  Future<void> init({required bool dev}) async {
    await Supabase.initialize(
      authOptions: FlutterAuthClientOptions(autoRefreshToken: true),
      url: dev ? UrlConstants.devSupabaseUrl : UrlConstants.prodSupabaseUrl,
      anonKey: dev ? UrlConstants.devSupabaseKey : UrlConstants.prodSupabaseKey,
    );
    client = Supabase.instance.client;
  }
}
