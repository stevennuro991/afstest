import 'package:afs_test/apps/modules/home/models/gpt_response_model.dart';

import 'package:afs_test/helper/service_response.dart';
import 'package:afs_test/utils/logger.dart';
import 'package:afs_test/utils/notifier_state.dart';

class HomeService {
  static Future<NotifierState<dynamic>> addHistory(
      String question, String answer) async {
    return (await ApiService<dynamic>().postCall(
            "/api/search-history/create-search-history",
            body: {"searchQuery": question, "searchResult": answer},
            onLog: (res) => logResponse(res),
            getDataFromResponse: (data) => data))
        .toNotifierState();
  }

  static Future<NotifierState<List<GetHistoryModel>>> getHistory() async {
    return (await ApiService<List<GetHistoryModel>>().postCall(
      "/api/search-history/paged",
      body: {
        "searchString": "",
        "pageNum": 1,
        "pageSize": 10,
      },
      onLog: (res) => logResponse(res),
      getDataFromResponse: (data) {
        var enquiries = data['entities'] as List;
        return enquiries.map((json) => GetHistoryModel.fromJson(json)).toList();
      },
    ))
        .toNotifierState();
  }

  static Future<NotifierState<GetHistoryModel>> getSingleHistory(
      String historyId) async {
    return (await ApiService<GetHistoryModel>().getCall(
            "/api/search-history/single/$historyId",
            onLog: (res) => logResponse(res),
            getDataFromResponse: (data) => GetHistoryModel.fromJson(data)))
        .toNotifierState();
  }
}
