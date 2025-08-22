class AppConfig {
  /// base URL API
  static String baseUrl = const String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// timeout เริ่มต้นของทุก request
  static Duration httpTimeout = Duration(
    seconds: int.fromEnvironment('HTTP_TIMEOUT_SEC', defaultValue: 12),
  );

  /// จำนวนครั้งที่ retry (เฉพาะ GET/กรณี error 408/503/5xx)
  static int httpRetries = int.fromEnvironment('HTTP_RETRIES', defaultValue: 0);

  /// backoff ต่อครั้งเวลา retry
  static Duration httpBackoff = Duration(
    milliseconds: int.fromEnvironment('HTTP_BACKOFF_MS', defaultValue: 400),
  );

  /// headers เริ่มต้น (เพิ่ม/ลบได้)
  static Map<String, String> defaultHeaders = const {
    'Accept': 'application/json, text/plain, */*',
  };
}
