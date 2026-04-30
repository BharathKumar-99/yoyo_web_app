import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yoyo_web_app/features/common/common_view_model.dart';
import 'package:yoyo_web_app/features/notification/data/notification_repo.dart';

import '../../../config/utils/global_loader.dart';
import '../model/notification_model.dart';
import '../model/notification_settings_model.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepo _repo = NotificationRepo();
  NotificationSettingsModel? notificationSettingsModel;
  List<NotificationModel> activationModel = [];
  CommonViewModel commonViewModel;
  NotificationViewModel(this.commonViewModel) {
    commonViewModel.addListener(_onSchoolChange);
    getCodeModel();

    titleController.addListener(notifyListeners);
    bodyController.addListener(notifyListeners);
  }

  // --- Notification Settings State ---
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  bool hwSet = true;
  bool hwDue = false;
  bool reviseExam = false;
  bool hwChampion = false;
  bool topSchoolLeague = false;
  bool topClassLeague = false;

  String deliveryMode = 'Immediate';
  DateTime? selectedDeliveryDate;

  List<String> get deliveryOptions {
    if (topSchoolLeague || topClassLeague || hwChampion) {
      return ['Immediate'];
    } else if (hwSet) {
      return ['Immediate', 'On a date'];
    }
    return ['Immediate', '1 day before', '2 days before', 'On a date'];
  }

  void setDeliveryMode(String mode) {
    deliveryMode = mode;
    if (mode != 'On a date') {
      selectedDeliveryDate = null;
    }
    notifyListeners();
  }

  void setDeliveryDate(DateTime date) {
    selectedDeliveryDate = date;
    deliveryMode = 'On a date';
    notifyListeners();
  }

  void resetDelivery() {
    deliveryMode = 'Immediate';
    selectedDeliveryDate = null;
    notifyListeners();
  }

  void toggleTrigger(String trigger, bool value) {
    if (value) {
      hwSet = false;
      hwDue = false;
      reviseExam = false;
      hwChampion = false;
      topSchoolLeague = false;
      topClassLeague = false;
    }

    switch (trigger) {
      case 'hwSet':
        hwSet = value;
        break;
      case 'hwDue':
        hwDue = value;
        break;
      case 'reviseExam':
        reviseExam = value;
        break;
      case 'hwChampion':
        hwChampion = value;
        break;
      case 'topSchoolLeague':
        topSchoolLeague = value;
        break;
      case 'topClassLeague':
        topClassLeague = value;
        break;
    }

    if (value) {
      _loadTriggerData(trigger);
    }

    notifyListeners();
  }

  void _loadTriggerData(String trigger) {
    NotificationTriggerSetting? setting;
    switch (trigger) {
      case 'hwSet':
        setting = notificationSettingsModel?.settings?.homeWorkSet;
        break;
      case 'hwDue':
        setting = notificationSettingsModel?.settings?.homeWorkDue;
        break;
      case 'reviseExam':
        setting = notificationSettingsModel?.settings?.reviseExam;
        break;
      case 'hwChampion':
        setting = notificationSettingsModel?.settings?.hwChampion;
        break;
      case 'topSchoolLeague':
        setting = notificationSettingsModel?.settings?.topSchoolLeague;
        break;
      case 'topClassLeague':
        setting = notificationSettingsModel?.settings?.topClassLeague;
        break;
    }
    titleController.text = setting?.title ?? '';
    bodyController.text = setting?.body ?? '';
    deliveryMode = trigger == 'reviseExam' ? 'On a date' : 'Immediate';
    selectedDeliveryDate = null;
  }

  void toggleNotificationSettings(bool value) async {
    if (hwSet) {
      notificationSettingsModel?.settings?.homeWorkSet?.active = value;
    } else if (hwDue) {
      notificationSettingsModel?.settings?.homeWorkDue?.active = value;
    } else if (reviseExam) {
      notificationSettingsModel?.settings?.reviseExam?.active = value;
    } else if (hwChampion) {
      notificationSettingsModel?.settings?.hwChampion?.active = value;
    } else if (topSchoolLeague) {
      notificationSettingsModel?.settings?.topSchoolLeague?.active = value;
    } else if (topClassLeague) {
      notificationSettingsModel?.settings?.topClassLeague?.active = value;
    }
    await updateCmd();
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  // -----------------------------------
  _onSchoolChange() {
    titleController.clear();
    bodyController.clear();
    getCodeModel();
  }

  getCodeModel() async {
    activationModel = commonViewModel.selectedClass == null
        ? []
        : await _repo.getActivationModel(
            commonViewModel.selectedClass?.id ?? 0,
          );

    activationModel.sort((a, b) {
      DateTime getDate(NotificationModel item) {
        if (item.createdAt != null && item.createdAt!.isNotEmpty) {
          return DateTime.parse(item.createdAt!);
        } else if (item.requestedAt != null && item.requestedAt!.isNotEmpty) {
          return DateTime.parse(item.requestedAt!);
        } else {
          return DateTime(1970);
        }
      }

      final dateA = getDate(a);
      final dateB = getDate(b);

      return dateB.compareTo(dateA);
    });

    if (commonViewModel.selectedClass != null) {
      notificationSettingsModel = await _repo.getNotificationSettings(
        commonViewModel.selectedClass!.id ?? 0,
      );
    } else {
      notificationSettingsModel = null;
    }
    if (notificationSettingsModel != null) {
      updateNotificationSettingsAtBoot();
    }
    notifyListeners();
  }

  updateNotificationSettingsAtBoot() {
    if (hwSet) {
      titleController.text =
          notificationSettingsModel?.settings?.homeWorkSet?.title ?? '';
      bodyController.text =
          notificationSettingsModel?.settings?.homeWorkSet?.body ?? '';
    }
    if (hwDue) {
      titleController.text =
          notificationSettingsModel?.settings?.homeWorkDue?.title ?? '';
      bodyController.text =
          notificationSettingsModel?.settings?.homeWorkDue?.body ?? '';
    }
    if (reviseExam) {
      titleController.text =
          notificationSettingsModel?.settings?.reviseExam?.title ?? '';
      bodyController.text =
          notificationSettingsModel?.settings?.reviseExam?.body ?? '';
    }
    if (hwChampion) {
      titleController.text =
          notificationSettingsModel?.settings?.hwChampion?.title ?? '';
      bodyController.text =
          notificationSettingsModel?.settings?.hwChampion?.body ?? '';
    }
    if (topSchoolLeague) {
      titleController.text =
          notificationSettingsModel?.settings?.topSchoolLeague?.title ?? '';
      bodyController.text =
          notificationSettingsModel?.settings?.topSchoolLeague?.body ?? '';
    }
    if (topClassLeague) {
      titleController.text =
          notificationSettingsModel?.settings?.topClassLeague?.title ?? '';
      bodyController.text =
          notificationSettingsModel?.settings?.topClassLeague?.body ?? '';
    }
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

  void updateNotificationSettings() async {
    notificationSettingsModel ??= NotificationSettingsModel();
    notificationSettingsModel!.settings ??= NotificationSettingsData();
    notificationSettingsModel!.settings!.homeWorkSet ??=
        NotificationTriggerSetting();
    notificationSettingsModel!.settings!.homeWorkDue ??=
        NotificationTriggerSetting();
    notificationSettingsModel!.settings!.reviseExam ??=
        NotificationTriggerSetting();
    notificationSettingsModel!.settings!.hwChampion ??=
        NotificationTriggerSetting();
    notificationSettingsModel!.settings!.topSchoolLeague ??=
        NotificationTriggerSetting();
    notificationSettingsModel!.settings!.topClassLeague ??=
        NotificationTriggerSetting();

    if (hwSet) {
      notificationSettingsModel!.settings!.homeWorkSet!.title =
          titleController.text;
      notificationSettingsModel!.settings!.homeWorkSet!.body =
          bodyController.text;
      notificationSettingsModel!.settings!.homeWorkSet!.deliveryMode =
          deliveryMode;
      notificationSettingsModel!.settings!.homeWorkSet!.selectedDeliveryDate =
          deliveryMode == 'On a date'
          ? selectedDeliveryDate?.toIso8601String()
          : null;
      if (notificationSettingsModel!.settings!.homeWorkSet!.active == null &&
          titleController.text.isNotEmpty &&
          bodyController.text.isNotEmpty) {
        notificationSettingsModel!.settings!.homeWorkSet!.active = true;
      }
    }
    if (hwDue) {
      notificationSettingsModel!.settings!.homeWorkDue!.title =
          titleController.text;
      notificationSettingsModel!.settings!.homeWorkDue!.body =
          bodyController.text;
      notificationSettingsModel!.settings!.homeWorkDue!.deliveryMode =
          deliveryMode;
      notificationSettingsModel!.settings!.homeWorkDue!.selectedDeliveryDate =
          deliveryMode == 'On a date'
          ? selectedDeliveryDate?.toIso8601String()
          : null;
      if (notificationSettingsModel!.settings!.homeWorkDue!.active == null &&
          titleController.text.isNotEmpty &&
          bodyController.text.isNotEmpty) {
        notificationSettingsModel!.settings!.homeWorkDue!.active = true;
      }
    }
    if (reviseExam) {
      notificationSettingsModel!.settings!.reviseExam!.title =
          titleController.text;
      notificationSettingsModel!.settings!.reviseExam!.body =
          bodyController.text;
      notificationSettingsModel!.settings!.reviseExam!.deliveryMode =
          deliveryMode;
      notificationSettingsModel!.settings!.reviseExam!.selectedDeliveryDate =
          deliveryMode == 'On a date'
          ? selectedDeliveryDate?.toIso8601String()
          : null;
      if (notificationSettingsModel!.settings!.reviseExam!.active == null &&
          titleController.text.isNotEmpty &&
          bodyController.text.isNotEmpty) {
        notificationSettingsModel!.settings!.reviseExam!.active = true;
      }
    }
    if (hwChampion) {
      notificationSettingsModel!.settings!.hwChampion!.title =
          titleController.text;
      notificationSettingsModel!.settings!.hwChampion!.body =
          bodyController.text;
      notificationSettingsModel!.settings!.hwChampion!.deliveryMode =
          deliveryMode;
      notificationSettingsModel!.settings!.hwChampion!.selectedDeliveryDate =
          deliveryMode == 'On a date'
          ? selectedDeliveryDate?.toIso8601String()
          : null;
      if (notificationSettingsModel!.settings!.hwChampion!.active == null &&
          titleController.text.isNotEmpty &&
          bodyController.text.isNotEmpty) {
        notificationSettingsModel!.settings!.hwChampion!.active = true;
      }
    }
    if (topSchoolLeague) {
      notificationSettingsModel!.settings!.topSchoolLeague!.title =
          titleController.text;
      notificationSettingsModel!.settings!.topSchoolLeague!.body =
          bodyController.text;
      notificationSettingsModel!.settings!.topSchoolLeague!.deliveryMode =
          deliveryMode;
      notificationSettingsModel!
          .settings!
          .topSchoolLeague!
          .selectedDeliveryDate = deliveryMode == 'On a date'
          ? selectedDeliveryDate?.toIso8601String()
          : null;
      if (notificationSettingsModel!.settings!.topSchoolLeague!.active ==
              null &&
          titleController.text.isNotEmpty &&
          bodyController.text.isNotEmpty) {
        notificationSettingsModel!.settings!.topSchoolLeague!.active = true;
      }
    }
    if (topClassLeague) {
      notificationSettingsModel!.settings!.topClassLeague!.title =
          titleController.text;
      notificationSettingsModel!.settings!.topClassLeague!.body =
          bodyController.text;
      notificationSettingsModel!.settings!.topClassLeague!.deliveryMode =
          deliveryMode;
      notificationSettingsModel!
          .settings!
          .topClassLeague!
          .selectedDeliveryDate = deliveryMode == 'On a date'
          ? selectedDeliveryDate?.toIso8601String()
          : null;
      if (notificationSettingsModel!.settings!.topClassLeague!.active == null &&
          titleController.text.isNotEmpty &&
          bodyController.text.isNotEmpty) {
        notificationSettingsModel!.settings!.topClassLeague!.active = true;
      }
    }
    await updateCmd();
    notifyListeners();
  }

  updateCmd() async {
    GlobalLoader.show();
    await _repo.updateNotificationSettings(
      notificationSettingsModel!,
      commonViewModel.selectedClass!.id!,
    );
    GlobalLoader.hide();
  }

  // void update(int index) async {
  //   GlobalLoader.show();
  //   await _repo.updateActivationCode(activationModel[index]);
  //   await getCodeModel();
  //   GlobalLoader.hide();
  // }
}
