class Extra {
  String? sessionId;

  Extra({this.sessionId});

  Extra copy() {
    return Extra(sessionId: sessionId);
  }

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
      sessionId: json['sessionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
    };
  }
}
