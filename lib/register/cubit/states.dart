import '../../models/register.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {
  final RegisterModel registerModel;

  RegisterSuccessState(this.registerModel);

}

class RegisterErrorState extends RegisterStates {}

class RegisterChangePassswordVisibilityState extends RegisterStates {}
