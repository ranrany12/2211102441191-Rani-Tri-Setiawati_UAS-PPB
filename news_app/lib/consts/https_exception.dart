class HttpsException implements Exception {
  final String codeMessage;

  HttpsException(this.codeMessage);

  @override
  String toString() {
    return codeMessage;
  }

  String get getNewsApiErrorMessage {
    String errorMessage = '';

    if (codeMessage.contains('apiKeyDisable')) {
      errorMessage = 'Your API key has been disabled.';
    } else if (codeMessage.contains('apiKeyExhausted')) {
      errorMessage = 'Your API key has no more requests available.';
    } else if (codeMessage.contains('apiKeyInvalid')) {
      errorMessage =
          'Your API key hasn\'t been entered correctly. Double check it and try again.';
    } else if (codeMessage.contains('apiKeyMissing')) {
      errorMessage =
          'Your API key is missing from the request. Append it to the request with one of these methods.';
    } else if (codeMessage.contains('parameterInvalid')) {
      errorMessage =
          'You\'ve included a parameter in your request which is currently not supported. Check the message property for more details.';
    } else if (codeMessage.contains('parametersMissing')) {
      errorMessage =
          'Required parameters are missing from the request and it cannot be completed. Check the message property for more details.';
    } else if (codeMessage.contains('rateLimited')) {
      errorMessage =
          'You have been rate limited. Back off for a while before trying the request again.';
    } else if (codeMessage.contains('sourcesTooMany')) {
      errorMessage =
          'You have requested too many sources in a single request. Try splitting the request into 2 smaller requests.';
    } else if (codeMessage.contains('sourceDoesNotExist')) {
      errorMessage = 'You have requested a source which does not exist.';
    } else if (codeMessage.contains('unexpectedError')) {
      errorMessage =
          'This shouldn\'t happen, and if it does then it\'s our fault, not yours. Try the request again shortly.';
    }

    return errorMessage;
  }
}
