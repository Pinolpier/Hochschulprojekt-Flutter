/// author Markus Link
/// todo: CONSIDER writing a library-level doc comment
/// --> What

/// In Dart an exception doesn't need to inherit from Exception,
/// I decided not to do so, because
/// 1) I want the the original Exception that has happened in the backend to be attached to my BackendException, but if it's final I can't build a constructor that fits Exception's needs
class UserProfileException implements Exception {
  /// todo: add documentation of variables
  /// --> What (sprechende Namen)
  final Exception _originalException;
  final String _message;

  const UserProfileException(this._originalException, this._message);

  /// todo: missing documentation
  /// --> What
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
/// --> What (sprechende Namen)
class UserNotSignedInException extends UserProfileException {
  const UserNotSignedInException(Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
/// --> What (sprechende Namen)
class NullArgumentException extends UserProfileException {
  const NullArgumentException(Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
/// --> What (sprechende Namen)
class ForeignProfileAccessForbiddenException extends UserProfileException {
  const ForeignProfileAccessForbiddenException(
      Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
/// --> What (sprechende Namen)
class PermissionDeniedException extends UserProfileException {
  const PermissionDeniedException(Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
/// --> What (sprechende Namen)
class IllegalDatabaseStateException extends UserProfileException {
  const IllegalDatabaseStateException(
      Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
/// --> What (sprechende Namen)
class NoUserProfileFoundException extends UserProfileException {
  const NoUserProfileFoundException(Exception originalException, String message)
      : super(originalException, message);
}

/// todo: missing documentation
/// --> What (sprechende Namen)
class UniqueConstraintViolatedException extends UserProfileException {
  const UniqueConstraintViolatedException(
      Exception originalException, String message)
      : super(originalException, message);
}