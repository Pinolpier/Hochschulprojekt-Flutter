/// todo: documentation comments are like these: -> /// documenation comment
/// todo: add author
/// todo: CONSIDER writing a library-level doc comment
/*
In Dart an exception doesn't need to inherit from Exception, I decided not to do so, because
1) I want the the original Exception that has happened in the backend to be attached to my BackendException, but if it's final I can't build a constructor that fits Exception's needs
 */
class AuthException implements Exception {
  /// todo: missing documentation about variables
  final Exception _originalException;
  final String _message;

  const AuthException(this._originalException, this._message);

  /// todo: missing documentation
  String toString() {
    return (_message != null
            ? _message
            : "no Message has been provided when this instance of Backend Exception was created.") +
        " " +
        (_originalException != null
            ? (_originalException.toString() != null &&
                    _originalException.toString() != ""
                ? "Originale exception's message was :" +
                    _originalException.toString()
                : "Original exception had no or an empty message.")
            : "no original exception has been provided when this instance of Backend exception was created.");
  }
}

/// todo: missing documentation
class UserEmailNotVerified extends AuthException {
  const UserEmailNotVerified(Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
class UserDisabledException extends AuthException {
  const UserDisabledException(Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
class NotAnEmailException extends AuthException {
  const NotAnEmailException(Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
class WrongPasswordException extends AuthException {
  const WrongPasswordException(Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
class UserNotFoundException extends AuthException {
  const UserNotFoundException(Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
class SignInAbortedException extends AuthException {
  const SignInAbortedException(Exception originalException, String message)
      : super(originalException, message);
}
