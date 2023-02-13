abstract class LoginStates {}

class InitialState extends LoginStates {}

class ChangePasswordState extends LoginStates {}

class ChangeConfirmPasswordState extends LoginStates {}

class UserLoadingState extends LoginStates {}

class UserErrorState extends LoginStates {}

class UserSuccessState extends LoginStates {}
