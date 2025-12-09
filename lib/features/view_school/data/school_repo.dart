import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/core/api/repo.dart';
import 'package:yoyo_web_app/features/home/model/school.dart';

class SchoolRepo extends ApiRepo {
  getSchoolData(int id) async {
    final data = await client
        .from(DbTable.school)
        .select(
          '''*,${DbTable.schoolLanguage}(*,${DbTable.language}(*, ${DbTable.phrase}(*))),${DbTable.classes}(*,${DbTable.student}(*,${DbTable.users}(*,${DbTable.userResult}(*))))''',
        )
        .eq('id', id)
        .maybeSingle();

    return School.fromJson(data!);
  }
}
