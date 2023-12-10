import 'package:afs_test/apps/modules/auth/providers/auth_provider.dart';
import 'package:afs_test/apps/modules/home/home_screen.dart';
import 'package:afs_test/apps/modules/module_components/buttons.dart';
import 'package:afs_test/apps/modules/module_components/textfield_components.dart';
import 'package:afs_test/helper/local_storage.dart';
import 'package:afs_test/utils/assets_paths.dart';
import 'package:afs_test/utils/constants.dart';
import 'package:afs_test/utils/navigators.dart';
import 'package:afs_test/utils/sized_boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  AutovalidateMode validate = AutovalidateMode.disabled;
  late FocusNode lastNode, emailNode, passNode, confirmNode;
  String? phone, firstName, middleName, lastName, email, password, referralCode;

  @override
  void initState() {
    lastNode = FocusNode();
    emailNode = FocusNode();
    passNode = FocusNode();
    confirmNode = FocusNode();
    super.initState();
  }

  bool showPass = false, showConfirm = false;

  void switchFocus(FocusNode node) {
    FocusScope.of(context).requestFocus(node);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: kPrimaryWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(children: [
              Center(child: Image.asset(AssetPaths.signUpImage)),
              yBox(10),
              Text(
                "Login",
                style: GoogleFonts.poppins(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              yBox(30),
              TextInputWidget(
                text: "Email address",
                hintText: "Enter email address",
                focusNode: emailNode,
                inputType: TextInputType.emailAddress,
                inputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.none,
                autoFillHints: const [AutofillHints.email],
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                onEditingComplete: () {
                  switchFocus(passNode);
                },
                validator: (val) {
                  return isEmail(val) ? null : "Input a valid email";
                },
                onSaved: (val) => email = val?.trim(),
              ),
              yBox(20),
              TextInputWidget(
                text: "Password",
                hintText: "Enter password",
                focusNode: passNode,
                obscure: !showPass,
                inputAction: TextInputAction.next,
                enableSuggestions: false,
                onEditingComplete: () {
                  switchFocus(confirmNode);
                },
                textCapitalization: TextCapitalization.none,
                allowPaste: false,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
                validator: (val) => isPasswordValid(val),
                icon: CInkWell(
                  onTap: () {
                    setState(() {
                      showPass = !showPass;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      showPass ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                      color: showPass ? kPrimaryColor : kGreyMedium,
                      size: 16,
                    ),
                  ),
                ),
              ),
              yBox(20),
              Consumer(builder: (_, ref, __) {
                return ref.watch(loginUserProvider).when(
                      loading: (val) => const LargeLoadingButton(),
                      done: (data) => LargeButton(
                        title: "Sign in",
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            ref.read(loginUserProvider.notifier).loginUser(
                                email!, password!, then: (val) async {
                              SharedPreferences pref =
                                  await SharedPreferences.getInstance();
                              pref.setString(
                                LocalStorageKeys.accessToken,
                                val!.accessToken!,
                              );
                              pref.setString(
                                LocalStorageKeys.refreshToken,
                                val.refreshToken!,
                              );
                              LocalStorage().saveUserDetails(userModel: val);
                              pushTo(const HomeScreen());
                            });
                          } else {
                            // setState(() {
                            //   validate = AutovalidateMode.onUserInteraction;
                            // });
                          }
                        },
                      ),
                    );
              }),
              yBox(40)
            ]),
          ),
        ),
      ),
    );
  }
}
