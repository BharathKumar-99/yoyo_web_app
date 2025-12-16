import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/utils/get_user_details.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';

class CommonRepo extends ApiRepo {
  getLoggedInUserInfo() async {
    String? userId = GetUserDetails.getCurrentUserId();
    final data = await client
        .from(DbTable.users)
        .select('*')
        .eq('user_id', userId!)
        .maybeSingle();
    return UserModel.fromJson(data!);
  }

  getLoggedInTeacherInfo() async {
    String? userId = GetUserDetails.getCurrentUserId();
    final data = await client
        .from(DbTable.users)
        .select(
          '''*,${DbTable.teacher}(*),${DbTable.school}(*,${DbTable.schoolLanguage}(*,${DbTable.language}(*)))''',
        )
        .eq('user_id', userId!)
        .maybeSingle();
    return UserModel.fromJson(data!);
  }
}
