import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/constants/api_endpoints.dart';
import '../../presentation/widget/custome_snackbar.dart';
import '../../data/local/shared_pref.dart';

class NoInternetException implements Exception {
  final String message;

  NoInternetException(this.message);
}

class ApiService {
  static Future<bool> _isConnected(context) async {
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      showCustomSnackbar.error(
        context,
        message: "No internet connection. Please check your connectivity.",
        icon: Icons.wifi_off,
      );
      return false;
    }
    return true;
  }

  static Future<Map<String, dynamic>> _request({
    required context,
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    bool requiresAuth = true,
    String? tempToken,
  }) async {
    if (!await _isConnected(context)) {
      return {
        'statusCode': 503,
        'error': 'No internet connection',
        'offline': true,
      };
    }

    final url = Uri.parse("$baseUrl$endpoint");
    final headers = {'Content-Type': 'application/json'};

    String? authToken = tempToken ?? await SplashSharedPref.getToken();

    if (authToken != null && requiresAuth) {
      headers['Authorization'] = 'Token $authToken';
    }

    debugPrint("─── API REQUEST ───");
    debugPrint("Method: $method");
    debugPrint("URL: $url");
    debugPrint("Headers: $headers");
    if (body != null) {
      debugPrint("Body: ${jsonEncode(body)}");
    }
    debugPrint("──────────────────");

    http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
          );
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception("Invalid HTTP method: $method");
      }

      debugPrint("─── API RESPONSE ───");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");
      debugPrint("────────────────────");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'statusCode': response.statusCode,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'error': jsonDecode(response.body)['message'] ?? 'Unknown error',
        };
      }
    } on SocketException {
      showCustomSnackbar.error(
        context,
        message: "Network error. Please check your connection.",
        icon: Icons.signal_wifi_statusbar_connected_no_internet_4,
      );
      return {'statusCode': 503, 'error': 'Network error', 'offline': true};
    } on TimeoutException {
      showCustomSnackbar.warning(
        context,
        message: "Request timed out. Try again.",
        icon: Icons.timer_off,
      );
      return {'statusCode': 408, 'error': "Request timed out. Try again."};
    } catch (e) {
      showCustomSnackbar.error(
        context,
        message: "Something went wrong. Please try again.",
        icon: Icons.error_outline,
      );
      return {
        'statusCode': 500,
        'error': "Something went wrong: ${e.toString()}",
      };
    }
  }

  static Future<Map<String, dynamic>> get({
    required BuildContext context,
    required String endpoint,
    bool requiresAuth = true,
    String? token,
  }) async {
    return await _request(
      context: context,
      endpoint: endpoint,
      method: "GET",
      requiresAuth: requiresAuth,
      tempToken: token,
    );
  }

  static Future<Map<String, dynamic>> post({
    required BuildContext context,
    required String endpoint,
    required Map<String, dynamic> body,
    bool requiresAuth = true,
    String? token,
  }) async {
    return await _request(
      context: context,
      endpoint: endpoint,
      method: "POST",
      body: body,
      requiresAuth: requiresAuth,
      tempToken: token,
    );
  }

  static Future<Map<String, dynamic>> put({
    required BuildContext context,
    required String endpoint,
    required Map<String, dynamic> body,
    bool requiresAuth = true,
    String? token,
  }) async {
    return await _request(
      context: context,
      endpoint: endpoint,
      method: "PUT",
      body: body,
      requiresAuth: requiresAuth,
      tempToken: token,
    );
  }

  static Future<Map<String, dynamic>> delete({
    required BuildContext context,
    required String endpoint,
    bool requiresAuth = true,
    String? token,
  }) async {
    return await _request(
      context: context,
      endpoint: endpoint,
      method: "DELETE",
      requiresAuth: requiresAuth,
      tempToken: token,
    );
  }
}
