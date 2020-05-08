/// A generic class that holds a value with its loading status.
/// @param <T>

class Result<R> {}

class LoadingState<T> extends Result<T> {}

class ErrorResult<T> extends Result<T> {
    ErrorResult(this.errorMessage);

    final T errorMessage;
}

class SuccessResult<T> extends Result<T> {
    SuccessResult(this.value);

    final T value;
}