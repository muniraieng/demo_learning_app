import 'package:equatable/equatable.dart';
abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error. Please try again.']) : super(message);
}
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection.']) : super(message);
}
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Local data unavailable.']) : super(message);
}
class AuthFailure extends Failure {
  const AuthFailure([String message = 'Invalid credentials.']) : super(message);
}
