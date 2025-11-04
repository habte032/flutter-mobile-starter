import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_boilerplate/core/base/base_repository.dart';
import 'package:flutter_boilerplate/core/connection/network_info.dart';
import 'package:flutter_boilerplate/core/errors/expentions.dart';
import 'package:flutter_boilerplate/core/errors/failure.dart';
import 'package:flutter_boilerplate/core/params/auth_params.dart';
import 'package:flutter_boilerplate/core/logging/app_logger.dart';
import 'package:flutter_boilerplate/core/monitoring/sentry_service.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required AppLogger logger,
    required SentryService sentryService,
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) : super(logger: logger, sentryService: sentryService);

  @override
  Future<Either<Failure, AuthResult>> login(LoginParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.login(params);

        // Cache tokens and user if authentication successful
        if (response.user == null || response.accessToken == null) {
          return Left(ServerFailure('Invalid response from server'));
        }
        await localDataSource.cacheAccessToken(response.accessToken!);
        if (response.refreshToken != null) {
          await localDataSource.cacheRefreshToken(response.refreshToken!);
        }
        await localDataSource.cacheUser(response.user!);
        if (response.verificationKey != null) {
          await localDataSource.cacheVerificationKey(response.verificationKey!);
        }

        return Right(
          AuthResult(
            user: response.user!,
            accessToken: response.accessToken!,
            refreshToken: response.refreshToken ?? '',
            requiresVerification: response.requiresVerification,
            verificationKey: response.verificationKey,
          ),
        );
      } on ServerException catch (e) {
        logger.error('Login failed', e, StackTrace.current);
        return Left(ServerFailure(e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        logger.error('Login error', e, stackTrace);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> signUp(SignUpParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.signUp(params);

        // Cache verification key if provided
        if (response.verificationKey != null) {
          await localDataSource.cacheVerificationKey(response.verificationKey!);
        }

        return Right(
          AuthResult(
            user: response.user ?? UserEntity(id: '', email: params.email),
            accessToken: response.accessToken ?? '',
            refreshToken: response.refreshToken ?? '',
            requiresVerification: response.requiresVerification,
            verificationKey: response.verificationKey,
          ),
        );
      } on ServerException catch (e) {
        logger.error('Login failed', e, StackTrace.current);
        return Left(ServerFailure(e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        logger.error('Login error', e, stackTrace);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> verifyOtp(
    OtpVerificationParams params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyOtp(params);

        // Cache tokens and user on successful verification
        if (response.accessToken != null) {
          await localDataSource.cacheAccessToken(response.accessToken!);
          if (response.refreshToken != null) {
            await localDataSource.cacheRefreshToken(response.refreshToken!);
          }
          if (response.user != null) {
            await localDataSource.cacheUser(response.user!);
          }
        }

        if (response.user == null || response.accessToken == null) {
          return Left(ServerFailure('Invalid response from server'));
        }

        return Right(
          AuthResult(
            user: response.user!,
            accessToken: response.accessToken!,
            refreshToken: response.refreshToken ?? '',
            requiresVerification: false,
            verificationKey: null,
          ),
        );
      } on ServerException catch (e) {
        logger.error('Login failed', e, StackTrace.current);
        return Left(ServerFailure(e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        logger.error('Login error', e, stackTrace);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(String verificationKey) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resendOtp(verificationKey);
        return Right(null);
      } on ServerException catch (e) {
        logger.error('Login failed', e, StackTrace.current);
        return Left(ServerFailure(e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        logger.error('Login error', e, stackTrace);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
    ResetPasswordParams params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(params);
        return Right(null);
      } on ServerException catch (e) {
        logger.error('Login failed', e, StackTrace.current);
        return Left(ServerFailure(e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        logger.error('Login error', e, stackTrace);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyResetPassword(
    VerifyResetPasswordParams params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.verifyResetPassword(params);
        return Right(null);
      } on ServerException catch (e) {
        logger.error('Login failed', e, StackTrace.current);
        return Left(ServerFailure(e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        logger.error('Login error', e, stackTrace);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> refreshToken(
    RefreshTokenParams params,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.refreshToken(params);

        if (response.accessToken != null) {
          await localDataSource.cacheAccessToken(response.accessToken!);
          if (response.refreshToken != null) {
            await localDataSource.cacheRefreshToken(response.refreshToken!);
          }
        }

        if (response.user == null || response.accessToken == null) {
          return Left(ServerFailure('Invalid response from server'));
        }

        return Right(
          AuthResult(
            user: response.user!,
            accessToken: response.accessToken!,
            refreshToken: response.refreshToken ?? '',
            requiresVerification: false,
          ),
        );
      } on ServerException catch (e) {
        logger.error('Login failed', e, StackTrace.current);
        return Left(ServerFailure(e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        logger.error('Login error', e, stackTrace);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await networkInfo.isConnected) {
        final refreshToken = await localDataSource.getCachedRefreshToken();
        if (refreshToken != null) {
          try {
            await remoteDataSource.logout();
          } catch (e) {
            // Even if logout fails on server, clear local data
          }
        }
      }
      await localDataSource.clearAll();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        logger.error('Login failed', e, StackTrace.current);
        return Left(ServerFailure(e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        logger.error('Login error', e, stackTrace);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
