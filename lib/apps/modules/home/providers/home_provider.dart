import 'package:afs_test/apps/modules/home/models/gpt_response_model.dart';
import 'package:afs_test/apps/modules/home/service/home_service.dart';
import 'package:afs_test/utils/notifier_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postChatHistoryProvider =
    StateNotifierProvider<PostChatHistoryNotifier, NotifierState<dynamic>>(
        (ref) => PostChatHistoryNotifier());

class PostChatHistoryNotifier extends StateNotifier<NotifierState<dynamic>> {
  PostChatHistoryNotifier() : super(notifyIdle());

  void postChatHistory(String question, String answer,
      {required Function(dynamic) then}) async {
    state = notifyLoading();
    state = await HomeService.addHistory(question, answer);

    ProcessProvider.run<dynamic>(
      state,
      showSuccessBar: false,
      showErrorPop: false,
      showErrorBar: true,
      doneCB: then,
    );
  }
}

final getSingleHistoryProvider = StateNotifierProvider<GetSingleHistoryNotifier,
    NotifierState<GetHistoryModel?>>((ref) => GetSingleHistoryNotifier());

class GetSingleHistoryNotifier
    extends StateNotifier<NotifierState<GetHistoryModel>> {
  GetSingleHistoryNotifier() : super(notifyIdle());

  void getSingleHistory(String id) async {
    state = notifyLoading();
    state = await HomeService.getSingleHistory(id);

    ProcessProvider.run<GetHistoryModel>(
      state,
      showSuccessBar: false,
      showErrorPop: false,
      showErrorBar: true,
    );
  }

  void clearHistory() {
    state = notifyIdle();
  }
}

final getChatHistoryProvider = StateNotifierProvider<GetChatHistoryNotifier,
    NotifierState<List<GetHistoryModel>>>((ref) => GetChatHistoryNotifier());

class GetChatHistoryNotifier
    extends StateNotifier<NotifierState<List<GetHistoryModel>>> {
  GetChatHistoryNotifier() : super(notifyIdle());

  void getChatHistory() async {
    state = notifyLoading();
    state = await HomeService.getHistory();

    ProcessProvider.run<List<GetHistoryModel>>(
      state,
      showSuccessBar: false,
      showErrorPop: false,
      showErrorBar: true,
    );
  }
}
