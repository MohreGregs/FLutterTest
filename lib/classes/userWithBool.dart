import '../database/entities/user.dart';

class UserWithBool{
  User user;
  bool value;

  UserWithBool(this.value, this.user);
}