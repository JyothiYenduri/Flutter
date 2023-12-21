class AuthToken{
  String access_token;
  String token_type;
  int expires_in;
  String username;
  DateTime issued;
  DateTime expires;

  AuthToken({this.access_token, this.token_type, this.expires_in, this.username, this.issued, this.expires});
}