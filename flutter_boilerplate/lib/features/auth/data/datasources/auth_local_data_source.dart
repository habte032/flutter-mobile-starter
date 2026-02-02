import 'dart:convert';
import 'package:flutter_boilerplate/core/databases/cache/cache_helper.dart';
import 'package:flutter_boilerplate/core/errors/failure.dart';
import 'package:flutter_boilerplate/core/storage/storage_key_constants.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<void> cacheAccessToken(String token);
  Future<void> cacheRefreshToken(String token);
  Future<void> cacheVerificationKey(String key);
  Future<UserModel?> getCachedUser();
  Future<String?> getCachedAccessToken();
  Future<String?> getCachedRefreshToken();
  Future<String?> getCachedVerificationKey();
  Future<void> clearAll();
}

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final CacheHelper cacheHelper;

  AuthLocalDataSourceImpl({required this.cacheHelper});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await cacheHelper.saveData(
        key: StorageKeys.user.name,
        value: json.encode(user.toJson()),
      );
    } catch (e) {
      throw CacheFailure('Failed to cache user: $e');
    }
  }

  @override
  Future<void> cacheAccessToken(String token) async {
    try {
      await cacheHelper.saveData(
        key: StorageKeys.accessToken.name,
        value: token,
      );
    } catch (e) {
      throw CacheFailure('Failed to cache access token: $e');
    }
  }

  @override
  Future<void> cacheRefreshToken(String token) async {
    try {
      await cacheHelper.saveData(
        key: StorageKeys.refreshToken.name,
        value: token,
      );
    } catch (e) {
      throw CacheFailure('Failed to cache refresh token: $e');
    }
  }

  @override
  Future<void> cacheVerificationKey(String key) async {
    try {
      await cacheHelper.saveData(
        key: StorageKeys.verificationKey.name,
        value: key,
      );
    } catch (e) {
      throw CacheFailure('Failed to cache verification key: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = cacheHelper.getDataString(key: StorageKeys.user.name);
      if (userJson != null) {
        final decoded = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(decoded);
      }
      return null;
    } catch (e) {
      throw CacheFailure('Failed to get cached user: $e');
    }
  }

  @override
  Future<String?> getCachedAccessToken() async {
    try {
      return cacheHelper.getDataString(key: StorageKeys.accessToken.name);
    } catch (e) {
      throw CacheFailure('Failed to get cached access token: $e');
    }
  }

  @override
  Future<String?> getCachedRefreshToken() async {
    try {
      return cacheHelper.getDataString(key: StorageKeys.refreshToken.name);
    } catch (e) {
      throw CacheFailure('Failed to get cached refresh token: $e');
    }
  }

  @override
  Future<String?> getCachedVerificationKey() async {
    try {
      return cacheHelper.getDataString(key: StorageKeys.verificationKey.name);
    } catch (e) {
      throw CacheFailure('Failed to get cached verification key: $e');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await cacheHelper.removeData(key: StorageKeys.user.name);
      await cacheHelper.removeData(key: StorageKeys.accessToken.name);
      await cacheHelper.removeData(key: StorageKeys.refreshToken.name);
      await cacheHelper.removeData(key: StorageKeys.verificationKey.name);
      await cacheHelper.removeData(key: StorageKeys.loginTimestamp.name);
    } catch (e) {
      throw CacheFailure('Failed to clear auth data: $e');
    }
  }
}
