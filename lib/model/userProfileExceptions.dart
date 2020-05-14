/*
In Dart an exception doesn't need to inherit from Exception, I decided not to do so, because
1) I want the the original Exception that has happened in the backend to be attached to my BackendException, but if it's final I can't build a constructor that fits Exception's needs
 */
class UserProfileException implements Exception {
  final Exception _originalException;
  final String _message;

  const UserProfileException(this._originalException, this._message);

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

class UserNotSignedInException extends UserProfileException {
  const UserNotSignedInException(Exception originalException, String message)
      : super(originalException, message);
}

class NullArgumentException extends UserProfileException {
  const NullArgumentException(Exception originalException, String message)
      : super(originalException, message);
}

class ForeignProfileAccessForbiddenException extends UserProfileException {
  const ForeignProfileAccessForbiddenException(
      Exception originalException, String message)
      : super(originalException, message);
}

class PermissionDeniedException extends UserProfileException {
  const PermissionDeniedException(Exception originalException, String message)
      : super(originalException, message);
}

class IllegalDatabaseStateException extends UserProfileException {
  const IllegalDatabaseStateException(Exception originalException,
      String message) : super(originalException, message);
}

class NoUserProfileFoundException extends UserProfileException {
  const NoUserProfileFoundException(Exception originalException, String message)
      : super(originalException, message);
}