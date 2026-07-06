abstract class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error. Check your connection.']);
}

class ApiFailure extends Failure {
  final int? statusCode;
  const ApiFailure(super.message, {this.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error.']);
}

class StorageFailure extends Failure {
  const StorageFailure([super.message = 'Storage error.']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error occurred.']);
}

// Simple Result type (no fpdart required for compilation)
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

final class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
}
