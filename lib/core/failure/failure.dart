// ignore_for_file: public_member_api_docs, sort_constructors_first
class FailureRespose {
  final String message;
  FailureRespose([this.message = "Sorry, an unexpected error occured"]);

  @override
  String toString() => 'FailureRespose(message: $message)';
}
