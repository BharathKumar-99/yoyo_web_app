import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/config/constants/constants.dart';
import 'package:yoyo_web_app/config/theme/app_text_styles.dart';
import 'package:yoyo_web_app/features/login/presentation/login_view_model.dart';
import 'package:yoyo_web_app/features/login/presentation/widgets/widgets.dart';

Widget loginWeb(BuildContext context) {
  return Consumer<LoginViewModel>(
    builder: (context, viewModel, w) {
      return Scaffold(
        body: SafeArea(
          child: LoginWidgets.bgWidget(
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Image.asset(IconConstants.logoLogin, height: 60, width: 60),
                  Text(
                    "Lets help students speak MFL with confidence",
                    style: AppTextStyles.textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Teacher login",
                    style: AppTextStyles.textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  LoginWidgets.emailTextField(viewModel),
                  LoginWidgets.sendOtpBtn(viewModel),
                  if (viewModel.sentOtp)
                    Column(
                      spacing: 20,
                      children: [
                        LoginWidgets.otpField(
                          context,
                          viewModel,
                          MediaQuery.sizeOf(context).width / 10,
                        ),
                        LoginWidgets.verifyOtpBtn(viewModel),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
