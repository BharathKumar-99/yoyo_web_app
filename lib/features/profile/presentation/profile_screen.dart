import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/home/model/student_classes.dart';
import 'package:yoyo_web_app/features/home/model/user_model.dart';
import 'package:yoyo_web_app/features/profile/data/profile_repository.dart';
import 'package:yoyo_web_app/features/profile/presentation/profile_provider.dart';

import '../../../config/constants/constants.dart';
import '../../common/widgets.dart';
import '../../edit_user/presentation/widget/widget.dart';
import '../../home/model/classes_model.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.homeAppBar(),
      body: ChangeNotifierProvider<ProfileProvider>(
        create: (context) => ProfileProvider(ProfileRepository(), userId),
        child: Consumer<ProfileProvider>(
          builder: (context, provider, v) {
            List<int> scores = [];
            List<UserModel> users = [];

            for (Classes row in (provider.school?.classes ?? [])) {
              // phrases in class

              // participation per class

              for (StudentClassesModel student in row.studentClasses ?? []) {
                if (student.user != null && student.user?.isTester != true) {
                  users.add(student.user!);
                }
              }
            }

            for (UserModel element in users) {
              if (element.student?.score != null) {
                scores.add(element.student!.score!);
              }
            }

            if (scores.isNotEmpty) {}

            return provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Color(0xff9D5DE6), Color(0xffF78C59)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    spacing: 20,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 188,
                                            width: 188,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image:
                                                    const AssetImage(
                                                          ImageConstants
                                                              .loginBg,
                                                        )
                                                        as ImageProvider,
                                              ),
                                            ),

                                            child: Center(
                                              child: Text(
                                                provider.nameFromUser ?? "",
                                                style: TextStyle(
                                                  fontSize: 64,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xffffffff),
                                                ),
                                              ),
                                            ),
                                          ),
                                          
                                          SizedBox(
                                            width: 300,
                                            height: 56,
                                            child: OutlinedButton(
                                              onPressed: () => provider
                                                  .goToDesktopApp(context,),
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                  color: Color(0xff9D5DE6),
                                                  width: 2,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                              child: Text(
                                                'Go to YoYo Desktop App',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        spacing: 10,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            provider.user?.username ?? '',
                                            style: TextTheme.of(context)
                                                .displaySmall!
                                                .copyWith(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          getTitle(
                                            "Started: ",
                                            ' ${provider.user?.started?.toLocal() == null ? "N/A" : DateFormat("dd-mm-yyyy").format(provider.user!.started!.toLocal())}',
                                            context,
                                          ),
                                          getTitle(
                                            "Effort: ",
                                            '${provider.user?.effort}%',
                                            context,
                                          ),
                                          getTitle(
                                            "No. Attempt: ",
                                            ' ${provider.user?.attempts}',
                                            context,
                                          ),
                                          getTitle(
                                            "Phrases Learned: ",
                                            '${provider.user?.completedAttempts}',
                                            context,
                                          ),
                                          getTitle(
                                            "No. Vocab: ",
                                            '${provider.user?.vocab}',
                                            context,
                                          ),
                                          getTitle(
                                            "Average Score:  ",
                                            ' ${provider.user?.score}%',
                                            context,
                                          ),
                                        ],
                                      ),
                                      VerticalDivider(
                                        thickness: 2,
                                        width: 2,

                                        color: Color(0xff9D5DE6),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'School Rank:',
                                                style: TextTheme.of(context)
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              Text(
                                                '#${provider.user?.schoolRank}',
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff9D5DE6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Class Rank:',
                                                style: TextTheme.of(context)
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              Text(
                                                '#${provider.user?.classRank}',
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff9D5DE6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Homework Rank:',
                                                style: TextTheme.of(context)
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              Text(
                                                '#${provider.user?.homeWorkRank}',
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff9D5DE6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (provider.user?.badgeName != null)
                                        Column(
                                          children: [
                                            Image.network(
                                              provider.user?.badgeImage ?? "",
                                              height: 250,
                                            ),
                                            Text(
                                              '${provider.user?.badgeName}',
                                              style: TextTheme.of(context)
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: UserResultTable(
                              result: provider.results ?? [],
                            ),
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            width: 200,
                            height: 56,
                            child: OutlinedButton(
                              onPressed: () => provider.logout(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Color(0xff9D5DE6),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text('Sign Out'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

Row getTitle(String title, String body, BuildContext context) {
  return Row(
    children: [
      Text(
        title,
        style: TextTheme.of(
          context,
        ).titleLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      Text(
        body,
        style: TextTheme.of(
          context,
        ).titleLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.w400),
      ),
    ],
  );
}
