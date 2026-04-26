class AuthorSession {
  const AuthorSession({
    required this.token,
    required this.name,
    required this.email,
    this.bio = '',
  });

  final String token;
  final String name;
  final String email;
  final String bio;
}
