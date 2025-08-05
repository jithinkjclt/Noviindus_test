import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/constants/api_endpoints.dart';
import '../../presentation/widget/custome_snackbar.dart';
import '../../data/local/shared_pref.dart';

class ApiService {
  static Future<bool> _isConnected(BuildContext context) async {
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      ShowCustomSnackbar.error(
        context,
        message: "No internet connection.",
        icon: Icons.wifi_off,
      );
      return false;
    }
    return true;
  }

  static Future<Map<String, dynamic>> _request({
    required BuildContext context,
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    bool requiresAuth = true,
    String? tempToken,
  }) async {
    if (!await _isConnected(context)) {
      return {'statusCode': 503, 'error': 'No internet', 'offline': true};
    }

    final url = Uri.parse("$baseUrl$endpoint");
    final headers = {'Content-Type': 'application/json'};

    String? token = tempToken ?? await SplashSharedPref.getToken();
    if (token != null && requiresAuth) {
      headers['Authorization'] = 'Token $token';
    }

    try {
      http.Response response;

      if (method == 'GET') {
        response = await http.get(url, headers: headers);
      } else if (method == 'POST') {
        response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(body),
        );
      } else {
        throw Exception('Unsupported method: $method');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {
          'statusCode': response.statusCode,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'statusCode': response.statusCode,
          'error': jsonDecode(response.body)['message'] ?? 'Error occurred',
        };
      }
    } on SocketException {
      ShowCustomSnackbar.error(
        context,
        message: "Network error",
        icon: Icons.signal_wifi_bad,
      );
      return {'statusCode': 503, 'error': 'Network error', 'offline': true};
    } on TimeoutException {
      ShowCustomSnackbar.warning(
        context,
        message: "Timeout",
        icon: Icons.timer_off,
      );
      return {'statusCode': 408, 'error': 'Request timeout'};
    } catch (e) {
      ShowCustomSnackbar.error(
        context,
        message: "Unexpected error",
        icon: Icons.error,
      );
      return {'statusCode': 500, 'error': 'Unexpected error: $e'};
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
      method: 'GET',
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
      method: 'POST',
      body: body,
      requiresAuth: requiresAuth,
      tempToken: token,
    );
  }
}
