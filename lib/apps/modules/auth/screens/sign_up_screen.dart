import 'package:afs_test/apps/modules/auth/models/register_model.dart';
import 'package:afs_test/apps/modules/auth/providers/auth_provider.dart';
import 'package:afs_test/apps/modules/auth/screens/login_screen.dart';
import 'package:afs_test/apps/modules/module_components/buttons.dart';
import 'package:afs_test/apps/modules/module_components/textfield_components.dart';
import 'package:afs_test/utils/assets_paths.dart';
import 'package:afs_test/utils/constants.dart';
import 'package:afs_test/utils/logger.dart';
import 'package:afs_test/utils/navigators.dart';
import 'package:afs_test/utils/sized_boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
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
                "Create An Account",
                style: GoogleFonts.poppins(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              yBox(30),
              TextInputWidget(
                text: "First name",
                inputAction: TextInputAction.next,
                autoFillHints: const [
                  AutofillHints.givenName,
                  AutofillHints.name,
                ],
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  FilteringTextInputFormatter.deny(numberValues),
                ],
                autofocus: true,
                onEditingComplete: () {
                  switchFocus(lastNode);
                },
                validator: (val) {
                  return val == null || val.isEmpty
                      ? "Input valid first name"
                      : null;
                },
                onSaved: (val) => firstName = val?.trim(),
              ),
              yBox(20),
              TextInputWidget(
                text: "Middle name",
                inputAction: TextInputAction.next,
                autoFillHints: const [
                  AutofillHints.givenName,
                  AutofillHints.name,
                ],
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  FilteringTextInputFormatter.deny(numberValues),
                ],
                autofocus: true,
                onEditingComplete: () {
                  switchFocus(lastNode);
                },
                validator: (val) {
                  return val == null || val.isEmpty
                      ? "Input valid first name"
                      : null;
                },
                onSaved: (val) => middleName = val?.trim(),
              ),
              yBox(20),
              TextInputWidget(
                text: "Last name",
                inputAction: TextInputAction.next,
                autoFillHints: const [
                  AutofillHints.givenName,
                  AutofillHints.name,
                ],
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  FilteringTextInputFormatter.deny(numberValues),
                ],
                autofocus: true,
                onEditingComplete: () {
                  switchFocus(lastNode);
                },
                validator: (val) {
                  return val == null || val.isEmpty
                      ? "Input valid first name"
                      : null;
                },
                onSaved: (val) => lastName = val?.trim(),
              ),
              yBox(20),
              PhoneNumberInput(
                code: "+234",
                autoFillHints: const [AutofillHints.telephoneNumber],
                text: "Phone number",
                applyFilter: false,
                hintText: "Enter phone number",
                onEditingComplete: () {},
                onCodeChanged: (code) {},
                onChanged: (val) {
                  logPrint("0$val");
                },
                validator: (val) {
                  if (val == null || val.replaceAll("-", "").length < 10) {
                    return "Input a valid phone number";
                  }
                  return null;
                },
                onSaved: (val) {
                  String phoneRaw = val!.replaceAll("-", "");
                  if (phoneRaw.startsWith("0")) {
                    phone = phoneRaw;
                  } else {
                    phone = "0$phoneRaw";
                  }
                },
              ),
              yBox(20),
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
              TextInputWidget(
                text: "Confirm password",
                hintText: "Confirm password",
                focusNode: confirmNode,
                obscure: !showConfirm,
                inputAction: TextInputAction.done,
                enableSuggestions: false,
                textCapitalization: TextCapitalization.none,
                onEditingComplete: () {},
                allowPaste: false,
                validator: (val) =>
                    val != password ? "Passwords do not match" : null,
                icon: CInkWell(
                  onTap: () {
                    setState(() {
                      showConfirm = !showConfirm;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      showConfirm
                          ? CupertinoIcons.eye
                          : CupertinoIcons.eye_slash,
                      color: showConfirm ? kPrimaryColor : kGreyMedium,
                      size: 16,
                    ),
                  ),
                ),
              ),
              yBox(40),
              Consumer(builder: (_, ref, __) {
                return ref.watch(registerUserProvider).when(
                      loading: (val) => const LargeLoadingButton(),
                      done: (data) => LargeButton(
                        title: "Sign up",
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            final registerModel = RegisterModel(
                                firstName: firstName!,
                                otherNames: middleName!,
                                lastName: lastName!,
                                email: email!,
                                password: password!,
                                phoneNumber: phone!);
                            ref
                                .read(registerUserProvider.notifier)
                                .creaateRegister(registerModel, then: (val) {
                              pushTo(const LoginScreen());
                            });
                          } 
                        },
                      ),
                    );
              }),
              yBox(20),
              RichText(
                text: TextSpan(
                  text: "Already have an account.",
                  style: GoogleFonts.poppins(color: Colors.black),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          pushTo(const LoginScreen());
                        },
                      text: " Login",
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
              yBox(40)
            ]),
          ),
        ),
      ),
    );
  }
}
