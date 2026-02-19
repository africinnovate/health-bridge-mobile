import 'dart:convert';

import 'package:HealthBridge/core/constants/app_constants.dart';
import 'package:http/http.dart';
import '../../data/models/response_status_m.dart';
import '../extension/inbuilt_ext.dart';

class ResponseUtils {
  // reusable method to get api response
  static ResponseStatusM getApiResponse(Response response,
      {String message = "Error"}) {
    try {
      // print("General log: raw data mode is ${response.body}");
      ResponseStatusM model =
          ResponseStatusM.fromJson(jsonDecode(response.body));
      print("General log: the api model is $model");
      return model;
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return model;
      // } else {
      //   // Handle error responses
      //   return ResponseStatusM(
      //     status_code: response.statusCode,
      //     message:
      //         '$message: ${model.message ?? 'Unknown error'} (${response.statusCode})',
      //   );
      // }
    } catch (e) {
      return ResponseStatusM(
        status_code: AppConstants.errorCode,
        message: '$message: ${e.toString()}',
      );
    }
  }

  static Future<ResponseStatusM> checkError(dynamic e) async {
    return await checkNetwork().then((networkIsOkay) {
      if (networkIsOkay) {
        return ResponseStatusM(
            status_code: AppConstants.errorCode,
            message: 'Error: ${e.toString()}');
      } else {
        return ResponseStatusM(
            status_code: AppConstants.networkErrorCode,
            message: 'No network connection');
      }
    });
  }

  static bool isSuccessful(ResponseStatusM response) {
    return response.status_code == 200 || response.status_code == 201;
  }
}
