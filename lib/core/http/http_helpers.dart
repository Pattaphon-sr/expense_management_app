import '../config.dart';
import 'http_client.dart';

/// สร้าง client กลางตัวเดียว ใช้ทั้งแอป
final httpc = HttpClientLite(
  baseUrl: AppConfig.baseUrl,
  defaultHeaders: AppConfig.defaultHeaders,
  timeout: AppConfig.httpTimeout,
);

/// ---- ฟังก์ชันลัดที่อ่านค่าจาก config + ใช้ client กลาง ----
Future<dynamic> getJson(
  String path, {
  Map<String, String>? query,
  Map<String, String>? headers,
  Duration? timeout,
  int? retries,
}) {
  return httpc.requestJson(
    path,
    method: HttpMethod.get,
    query: query,
    headers: headers,
    timeoutOverride: timeout,
    retries: retries,
  );
}

Future<dynamic> postJson(
  String path, {
  Map<String, dynamic>? data,
  Map<String, String>? headers,
  Map<String, String>? query,
  Duration? timeout,
}) {
  return httpc.requestJson(
    path,
    method: HttpMethod.post,
    data: data,
    headers: headers,
    query: query,
    timeoutOverride: timeout,
  );
}

Future<dynamic> putJson(
  String path, {
  Map<String, dynamic>? data,
  Map<String, String>? headers,
  Map<String, String>? query,
  Duration? timeout,
}) {
  return httpc.requestJson(
    path,
    method: HttpMethod.put,
    data: data,
    headers: headers,
    query: query,
    timeoutOverride: timeout,
  );
}

Future<dynamic> patchJson(
  String path, {
  Map<String, dynamic>? data,
  Map<String, String>? headers,
  Map<String, String>? query,
  Duration? timeout,
}) {
  return httpc.requestJson(
    path,
    method: HttpMethod.patch,
    data: data,
    headers: headers,
    query: query,
    timeoutOverride: timeout,
  );
}

Future<dynamic> deleteJson(
  String path, {
  Map<String, dynamic>? data,
  Map<String, String>? headers,
  Map<String, String>? query,
  Duration? timeout,
}) {
  return httpc.requestJson(
    path,
    method: HttpMethod.delete,
    data: data,
    headers: headers,
    query: query,
    timeoutOverride: timeout,
  );
}
