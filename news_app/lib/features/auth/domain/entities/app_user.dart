class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.isGuest = false,
  });

  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final bool isGuest;

  factory AppUser.guest() {
    return const AppUser(
      id: 'guest',
      email: 'guest@pulsewire.app',
      name: 'Guest Reader',
      isGuest: true,
    );
  }
}
