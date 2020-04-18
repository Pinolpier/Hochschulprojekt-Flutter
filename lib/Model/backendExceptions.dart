/*
In Dart an exception doesn't need to inherit from Exception, I decided not to do so, because
1) I want the the original Exception that has happened in the backend to be attached to my BackendException, but if it's final I can't build a constructor that fits Exception's needs
 */
class BackendException implements Exception {
  final Exception _originalException;
  final String _message;

  const BackendException(this._originalException, this._message);

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

class UserDisabledException extends BackendException {
  const UserDisabledException(Exception originalException, String message)
      : super(originalException, message);
}

class NotAnEmailException extends BackendException {
  const NotAnEmailException(Exception originalException, String message)
      : super(originalException, message);
}

class WrongPasswordException extends BackendException {
  const WrongPasswordException(Exception originalException, String message)
      : super(originalException, message);
}

class UserNotFoundException extends BackendException {
  const UserNotFoundException(Exception originalException, String message)
      : super(originalException, message);
}

class SignInAbortedException extends BackendException {
  const SignInAbortedException(Exception originalException, String message)
      : super(originalException, message);
}
