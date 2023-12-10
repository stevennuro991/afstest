class GptResponseModel {
  String? warning;
  String? id;
  String? object;
  int? created;
  String? model;
  List<Choice>? choices;
  Usage? usage;

  GptResponseModel({
    this.warning,
    this.id,
    this.object,
    this.created,
    this.model,
    this.choices,
    this.usage,
  });

  factory GptResponseModel.fromJson(Map<String, dynamic> json) =>
      GptResponseModel(
        warning: json["warning"],
        id: json["id"],
        object: json["object"],
        created: json["created"],
        model: json["model"],
        choices:
            List<Choice>.from(json["choices"].map((x) => Choice.fromJson(x))),
        usage: Usage.fromJson(json["usage"]),
      );

  Map<String, dynamic> toJson() => {
        "warning": warning,
        "id": id,
        "object": object,
        "created": created,
        "model": model,
        "choices": List<dynamic>.from(choices!.map((x) => x.toJson())),
        "usage": usage?.toJson(),
      };
}

class Choice {
  String? text;
  int? index;
  dynamic logprobs;
  String? finishReason;

  Choice({
    this.text,
    this.index,
    this.logprobs,
    this.finishReason,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        text: json["text"],
        index: json["index"],
        logprobs: json["logprobs"],
        finishReason: json["finish_reason"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "index": index,
        "logprobs": logprobs,
        "finish_reason": finishReason,
      };
}

class Usage {
  int? promptTokens;
  int? completionTokens;
  int? totalTokens;

  Usage({
    this.promptTokens,
    this.completionTokens,
    this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
        promptTokens: json["prompt_tokens"],
        completionTokens: json["completion_tokens"],
        totalTokens: json["total_tokens"],
      );

  Map<String, dynamic> toJson() => {
        "prompt_tokens": promptTokens,
        "completion_tokens": completionTokens,
        "total_tokens": totalTokens,
      };
}


class GetHistoryModel {
    String searchHistoryId;
    DateTime createdOn;
    String searchQuery;
    String searchResult;

    GetHistoryModel({
        required this.searchHistoryId,
        required this.createdOn,
        required this.searchQuery,
        required this.searchResult,
    });

    factory GetHistoryModel.fromJson(Map<String, dynamic> json) => GetHistoryModel(
        searchHistoryId: json["searchHistoryId"],
        createdOn: DateTime.parse(json["createdOn"]),
        searchQuery: json["searchQuery"],
        searchResult: json["searchResult"],
    );

    Map<String, dynamic> toJson() => {
        "searchHistoryId": searchHistoryId,
        "createdOn": createdOn.toIso8601String(),
        "searchQuery": searchQuery,
        "searchResult": searchResult,
    };
}


