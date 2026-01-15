class UrlConstants {
  static const String superSpeachApi = "api.speechsuper.com";
  static const String devSupabaseUrl =
      "https://zhomsvnayqwfovpvkqzj.supabase.co";
  static const String prodSupabaseUrl =
      'https://xijaobuybkpfmyxcrobo.supabase.co';
  static const String devSupabaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpob21zdm5heXF3Zm92cHZrcXpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc2NjQ2ODgsImV4cCI6MjA4MzI0MDY4OH0.6-cCsDP1TjxHmbL_B1dT0WZiUHrIXt17Vz26pxzQFZE";
  static const String prodSupabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhpamFvYnV5YmtwZm15eGNyb2JvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1OTE5MzA5MSwiZXhwIjoyMDc0NzY5MDkxfQ.O6wV2umI_9-OxIwuGS7O62Y_FsGBHelWOBgXE38aKnk';
}

class ImageConstants {
  static const String assetsLoc = "assets/images/";
  static const String loginBg = "${assetsLoc}login_bg.png";
  static const String appLogo = "${assetsLoc}logo.png";
  static const String schoolLogo = "${assetsLoc}school_logo.png";
  static const String logoHome = "${assetsLoc}logo_home.png";
  static const String logoBW = "${assetsLoc}logoBW.png";
  static const String french = "${assetsLoc}french.png";
  static const String spanish = "${assetsLoc}spanish.png";
  static const String german = "${assetsLoc}german.png";
  static const String buddha = "${assetsLoc}buddha.png";
  static const String wave = "${assetsLoc}wave.png";
}

class IconConstants {
  static const String iconLoc = "assets/icons/";
  static const String emailIcon = "${iconLoc}mail.png";
  static const String vertIcon = "${iconLoc}vert-more.png";
  static const String logOutIcon = "${iconLoc}Logout.png";
  static const String logopre = "${iconLoc}logopre.png";
  static const String logoLogin = "${iconLoc}YoYo_withbackground.png";
}

class DbTable {
  static const String classLevel = 'class_level';
  static const String classes = 'classes';
  static const String language = 'language';
  static const String level = 'level';
  static const String phrase = 'phrase';
  static const String phraseCategories = 'phrase_categories';
  static const String school = 'school';
  static const String schoolLanguage = 'school_language';
  static const String student = 'student';
  static const String teacher = 'teacher';
  static const String users = 'users';
  static const String attemptedPhrases = 'attempted_phrases';
  static const String remoteConfig = 'remote_config';
  static const String userResult = 'user_results';
  static const String streakTable = 'streak_table';
  static const String activationRequests = 'activation_requests';
  static const String phraseDisabledSchools = 'phrase_disabled_schools';
}

class Stroage {
  static const String userBucket = 'user';
  static const String phrases = 'phrases';
  static const String school = 'school';
}

class Constants {
  static const int minimumWordScoreleft = 45;
  static const int minimumWordScoreright = 65;
  static const int minimumSubmitScore = 80;
  static const String learned = 'Learned';
  static const String mastered = 'Mastered';
}
