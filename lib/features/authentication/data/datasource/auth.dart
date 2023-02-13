import 'dart:developer';


import 'package:dio/dio.dart';
import 'package:shop_app/core/error/exception.dart';
import 'package:shop_app/core/network/api_constant.dart';
import 'package:shop_app/core/network/error_message_model.dart';
import 'package:shop_app/features/authentication/data/model/auth_model.dart';
import 'package:shop_app/features/authentication/domain/usecase/sign_in.dart';
import 'package:shop_app/features/authentication/domain/usecase/sign_up.dart';

abstract class AuthBaseRemoteDataSource
{
  Future<AuthModel> signIn(SignInParameters parameters);

  Future<AuthModel> signUp(SignUpParameters parameters);
}

class AuthRemoteDataSource extends AuthBaseRemoteDataSource {
  @override
  Future<AuthModel> signIn(SignInParameters parameters) async {
    final response = await Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        baseUrl: ApiConstant.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'lang': 'en',
        },
      ),
    ).post(ApiConstant.signIn, data: parameters.data);
    if (response.data['status'] == true)
    {
      print('=============================== response ============================');
      log(response.toString());
      return AuthModel.fromJson(response.data);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }

  @override
  Future<AuthModel> signUp(SignUpParameters parameters) async {
    final response = await Dio(BaseOptions(
        baseUrl: ApiConstant.baseUrl,
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
          'lang': 'en',
        })).post(ApiConstant.signUp, data: parameters.data);

    if (response.data['status'] == true) {
      print('=============================== response ================');
      log(response.toString());
      return AuthModel.fromJson(response.data);
    } else
    {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          response.data,
        ),
      );
    }
  }
}