import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/add_user_name_view_model.dart';
import 'package:yoyo_web_app/features/add_user_name/presentation/widget/widgets.dart';

class UploadStudents extends StatefulWidget {
  final bool isTab;
  final bool isMobile;
  const UploadStudents({
    super.key,
    required this.isTab,
    required this.isMobile,
  });

  @override
  State<UploadStudents> createState() => _UploadStudentsState();
}

class _UploadStudentsState extends State<UploadStudents> {
  static addXl(AddUserNameViewModel viewModel) => InkWell(
    onTap: viewModel.pickFile,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          const Icon(Icons.upload, size: 40),
          if (viewModel.selectedFileName != null)
            Expanded(
              child: Text(
                viewModel.selectedFileName ?? " ",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          Spacer(),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddUserNameViewModel(),
      child: Consumer<AddUserNameViewModel>(
        builder: (context, value, w) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: widget.isMobile
                  ? MediaQuery.of(context).size.height * 0.6
                  : widget.isTab
                  ? value.list.isEmpty
                        ? MediaQuery.of(context).size.height * 0.7
                        : MediaQuery.of(context).size.height * 0.9
                  : value.list.isEmpty
                  ? MediaQuery.of(context).size.height * 0.6
                  : MediaQuery.of(context).size.height * 0.9,
              width: widget.isMobile
                  ? MediaQuery.of(context).size.width * 0.8
                  : widget.isTab
                  ? MediaQuery.of(context).size.width * 0.7
                  : MediaQuery.of(context).size.width * 0.6,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Text('Upload Students'),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: addXl(value)),
                      SizedBox(height: 20),
                      (value.list.isEmpty)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Example: 4 Columns (.xlsx)'),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'first_name',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'surname',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'username',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'activation_code',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Tess',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'J',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Gloss-Island-672',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'GHF-872',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Expanded(
                              child: ListView(
                                children: [
                                  AddUserNameWidget.userTable(value.list),
                                  SizedBox(height: 20),
                                  AddUserNameWidget.addUserNameBtn(value),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
