import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/login/presentation/login_view_model.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../widgets/widgets.dart';

Widget loginTablet(BuildContext context) {
  double height = MediaQuery.sizeOf(context).height;
  double width = MediaQuery.sizeOf(context).width;
  return Consumer<LoginViewModel>(
    builder: (context, viewModel, w) {
      return Scaffold(
        body: SafeArea(
          child: LoginWidgets.bgWidget(
            LoginWidgets.loginCard(
              height / 2,
              width / 2,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 20,
                  children: [
                    Text(
                      "Login",
                      style: AppTextStyles.textTheme.headlineMedium,
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
                            MediaQuery.sizeOf(context).width / 70,
                          ),
                          LoginWidgets.verifyOtpBtn(viewModel),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
