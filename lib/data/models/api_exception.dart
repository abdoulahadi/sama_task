class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? serverMessage;

  ApiException({
    required this.message,
    this.statusCode,
    this.serverMessage,
  });

  @override
  String toString() => 
    'ApiException: $message (Status: $statusCode) | Détails: $serverMessage';
}