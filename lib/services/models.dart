class AppUser {
  String id, name, photoUrl;
  double lat, lng;
  List<String> interests;

  AppUser({
    this.id,
    this.name,
    this.photoUrl,
    this.lat,
    this.lng,
    this.interests,
  });

  factory AppUser.fromMap(Map<String, dynamic> data) {
    final AppUser appUser = AppUser(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      interests: (data['interests'] as List ?? [])
          .map((v) => v.toString())
          .toList(),
    );

    try {
      appUser.lat = data['_geoloc']['lat'] ?? 0;
      appUser.lng = data['_geoloc']['lng'] ?? 0;
    } catch (e) {}

    return appUser;
  }
}
