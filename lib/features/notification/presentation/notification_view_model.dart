import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/router/navigation_helper.dart';
import 'package:yoyo_web_app/config/utils/global_loader.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/notification/data/notification_repo.dart';
import 'package:yoyo_web_app/features/notification/model/activation_model.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepo _repo = NotificationRepo();
  List<ActivationRequestModel> activationModel = [];
  CommonViewModel? commonViewModel;
  NotificationViewModel() {
    commonViewModel = Provider.of<CommonViewModel>(ctx!);
    getCodeModel();
  }

  getCodeModel() async {
    activationModel = await _repo.getActivationModel(
      commonViewModel?.teacher?.teacher?.first.classes ?? 0,
    );
    List<String> sampleList = [];
    List<ActivationRequestModel> newsampleList = [];

    for (ActivationRequestModel data in activationModel) {
      if (!sampleList.contains(data.username)) {
        newsampleList.add(data);
      }
      sampleList.add(data.username ?? '');
    }
    activationModel = newsampleList;
    notifyListeners();
  }

  void generateCode(int index) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final rand = Random();

    final letterPart = List.generate(
      3,
      (_) => letters[rand.nextInt(letters.length)],
    ).join();

    final numberPart = rand.nextInt(900) + 100;

    final code = '$letterPart-$numberPart';
    activationModel[index].code = code;
    notifyListeners();
  }

  void update(int index) async {
    GlobalLoader.show();
    await _repo.updateActivationCode(activationModel[index]);
    await getCodeModel();
    GlobalLoader.hide();
  }
}
