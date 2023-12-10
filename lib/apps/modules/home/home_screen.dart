import 'dart:convert';
import 'package:afs_test/apps/modules/auth/providers/auth_provider.dart';
import 'package:afs_test/apps/modules/auth/screens/sign_up_screen.dart';
import 'package:afs_test/apps/modules/home/components/card_shimmer.dart';
import 'package:afs_test/apps/modules/home/components/text_form_field.dart';
import 'package:afs_test/apps/modules/home/models/gpt_response_model.dart';
import 'package:afs_test/apps/modules/home/providers/home_provider.dart';
import 'package:afs_test/helper/local_storage.dart';
import 'package:afs_test/utils/constants.dart';
import 'package:afs_test/utils/navigators.dart';
import 'package:afs_test/utils/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController chatController;
  String responseText = '';
  late GptResponseModel responseModel;
  List<Map<String, dynamic>> messages = [];
  LocalStorage localStorage = LocalStorage();

  void updateUser() {
    ref
        .read(userDetailsProvider.notifier)
        .updateUserDetails(localStorage.readUserDetails());
  }

  @override
  void initState() {
    chatController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateUser();
      ref.read(getChatHistoryProvider.notifier).getChatHistory();
    });
    super.initState();
  }

  @override
  void dispose() {
    chatController.dispose();
    super.dispose();
  }

  Future<void> completeFun() async {
    setState(() {
      messages.clear();
      messages.add({'text': chatController.text, 'isUserMessage': true});
      responseText = 'Loading...';
    });

    final response =
        await http.post(Uri.parse('https://api.openai.com/v1/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${dotenv.env['token']}'
            },
            body: jsonEncode({
              "model": "text-davinci-003",
              "prompt": chatController.text,
              "max_tokens": 250,
              "top_p": 1
            }));

    setState(() {
      responseModel = GptResponseModel.fromJson(json.decode(response.body));
      responseText = responseModel.choices![0].text!;
      messages.add({'text': responseText, 'isUserMessage': false});
      chatController.clear();
    });

    final userMessage = messages[messages.length - 2]['text'];
    final aiResponse = responseText;
    ref
        .read(postChatHistoryProvider.notifier)
        .postChatHistory(userMessage, aiResponse, then: (val) {
      ref.read(getChatHistoryProvider.notifier).getChatHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = ref.watch(getSingleHistoryProvider).data;
    if (selectedItem != null) {
      setState(() {
        messages.clear();
        messages
            .add({'text': selectedItem.searchResult, 'isUserMessage': false});
      });
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: kPrimaryColor.withOpacity(0.8),
        title: Text(
          "AFS CHATGPT",
          style: GoogleFonts.poppins(color: kPrimaryWhite),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                yBox(80),
                Text(
                    'Welcome, ${ref.read(loginUserProvider).data?.currentUser?.firstName ?? ref.read(userDetailsProvider).currentUser?.firstName} ${ref.read(loginUserProvider).data?.currentUser?.lastName ?? ref.read(userDetailsProvider).currentUser?.lastName}',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                yBox(20),
                InkWell(
                  onTap: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();

                    await localStorage.logout();

                    pushToAndClearStack(const SignUpScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: kPrimaryColor, borderRadius: kBoxRadius(4)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Logout",
                          style: GoogleFonts.poppins(color: kPrimaryWhite),
                        ),
                        xBox(20),
                        const Icon(
                          Icons.logout,
                          color: kPrimaryWhite,
                        )
                      ],
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 4.0),
                  child: Text(
                    'Recent Searches',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Consumer(builder: (_, ref, __) {
                  return ref.watch(getChatHistoryProvider).when(
                        loading: (val) => const ShimmerBar(),
                        done: (data) {
                          if (data!.isEmpty) {
                            return const Center(
                              child: Text("No history available"),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              var item = data[index];
                              return ListTile(
                                title: Text(item.searchQuery),
                                onTap: () {
                                  ref
                                      .read(getSingleHistoryProvider.notifier)
                                      .getSingleHistory(item.searchHistoryId);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                      );
                }),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: kGreyLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isUserMessage = messages[index]['isUserMessage'];
                  return Align(
                    alignment: isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: isUserMessage
                          ? Text(
                              messages[index]['text'],
                              style: GoogleFonts.poppins(color: Colors.white),
                            )
                          : TypewriterText(text: messages[index]['text']),
                    ),
                  );
                },
              ),
            ),
            TextFormFieldChat(
              chatController: chatController,
              btnFun: () {
                ref.watch(getSingleHistoryProvider.notifier).clearHistory();
                completeFun();
                chatController.clear();
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
