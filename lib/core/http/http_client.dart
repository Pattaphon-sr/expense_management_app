// lib/core/http/http_client.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';

enum HttpMethod { get, post, put, patch, delete }

class HttpResult {
  final int statusCode;
  final String body;
  final Map<String, String> headers;
  final dynamic json;
  const HttpResult({
    required this.statusCode,
    required this.body,
    required this.headers,
    this.json,
  });
  bool get ok => statusCode >= 200 && statusCode < 300;
}

class HttpClientLite {
  HttpClientLite({
    String? baseUrl,
    Map<String, String>? defaultHeaders,
    Duration? timeout,
  }) : baseUrl = baseUrl ?? AppConfig.baseUrl,
       defaultHeaders = defaultHeaders ?? AppConfig.defaultHeaders,
       timeout = timeout ?? AppConfig.httpTimeout;

  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final Duration timeout;

  Uri _buildUri(String pathOrAbsolute, [Map<String, String>? query]) {
    final isAbs =
        pathOrAbsolute.startsWith('http://') ||
        pathOrAbsolute.startsWith('https://');
    final base = isAbs
        ? Uri.parse(pathOrAbsolute)
        : Uri.parse(baseUrl).resolve(pathOrAbsolute);
    return base.replace(queryParameters: {...?base.queryParameters, ...?query});
  }

  Map<String, String> _mergeHeaders(
    Map<String, String>? headers,
    bool includeJsonContentType,
  ) => {
    ...defaultHeaders,
    if (includeJsonContentType)
      'Content-Type': 'application/json; charset=utf-8',
    ...?headers,
  };

  Future<HttpResult> requestRaw(
    String pathOrAbsolute, {
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Map<String, String>? query,
    Duration? timeoutOverride,
    int? retries,
    Duration? backoff,
  }) async {
    final uri = _buildUri(pathOrAbsolute, query);
    final hdrs = _mergeHeaders(headers, data != null);

    final _timeout = timeoutOverride ?? timeout;
    final _retries = retries ?? AppConfig.httpRetries;
    final _backoff = backoff ?? AppConfig.httpBackoff;

    Future<HttpResult> sendOnce() async {
      late http.Response res;
      try {
        switch (method) {
          case HttpMethod.get:
            res = await http.get(uri, headers: hdrs).timeout(_timeout);
            break;
          case HttpMethod.post:
            res = await http
                .post(
                  uri,
                  headers: hdrs,
                  body: data != null ? jsonEncode(data) : null,
                )
                .timeout(_timeout);
            break;
          case HttpMethod.put:
            res = await http
                .put(
                  uri,
                  headers: hdrs,
                  body: data != null ? jsonEncode(data) : null,
                )
                .timeout(_timeout);
            break;
          case HttpMethod.patch:
            res = await http
                .patch(
                  uri,
                  headers: hdrs,
                  body: data != null ? jsonEncode(data) : null,
                )
                .timeout(_timeout);
            break;
          case HttpMethod.delete:
            res = await http
                .delete(
                  uri,
                  headers: hdrs,
                  body: data != null ? jsonEncode(data) : null,
                )
                .timeout(_timeout);
            break;
        }
      } on TimeoutException {
        return const HttpResult(
          statusCode: 408,
          body: 'Request Timeout',
          headers: {},
        );
      } on SocketException catch (e) {
        return HttpResult(
          statusCode: 503,
          body: 'Network error: ${e.message}',
          headers: const {},
        );
      } catch (e) {
        return HttpResult(
          statusCode: 520,
          body: 'Unexpected error',
          headers: const {},
          json: '$e',
        );
      }

      dynamic parsed;
      try {
        if (res.body.isNotEmpty) parsed = jsonDecode(res.body);
      } catch (_) {
        parsed = null;
      }
      return HttpResult(
        statusCode: res.statusCode,
        body: res.body,
        headers: res.headers,
        json: parsed,
      );
    }

    HttpResult last = await sendOnce();

    int attempt = 0;
    while (!last.ok && attempt < _retries) {
      final retryable =
          last.statusCode == 408 ||
          last.statusCode == 503 ||
          (last.statusCode >= 500 && last.statusCode < 600);
      if (!retryable) break;
      await Future.delayed(_backoff * (attempt + 1));
      last = await sendOnce();
      attempt++;
    }
    return last;
  }

  Future<dynamic> requestJson(
    String pathOrAbsolute, {
    HttpMethod method = HttpMethod.get,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Map<String, String>? query,
    Duration? timeoutOverride,
    int? retries,
    Duration? backoff,
  }) async {
    final r = await requestRaw(
      pathOrAbsolute,
      method: method,
      data: data,
      headers: headers,
      query: query,
      timeoutOverride: timeoutOverride,
      retries: retries,
      backoff: backoff,
    );
    if (!r.ok) throw Exception('HTTP ${r.statusCode}: ${r.body}');
    return r.json;
  }
}
