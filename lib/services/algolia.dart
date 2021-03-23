import 'package:algolia/algolia.dart';
import 'services.dart';

class AlgoliaService {
  final Algolia _algolia = Algolia.init(
    // application id from your algolia console
    applicationId: 'YOUR_APPLICATION_ID',
    // search-only api key from your algolia console
    apiKey: 'SEARCH_ONLY_API_KEY',
  );

  /// gets a List of all Users from the given index in Algolia
  Future<List<AppUser>> getAllUsers() {
    return _algolia.instance.index('users').getObjects().then((querySnapshot) {
      // retrieved records are stored in 'hits'
      List<AlgoliaObjectSnapshot> snapshot = querySnapshot.hits;

      List<AppUser> users = [];

      if (snapshot.isNotEmpty)
        users = snapshot
            .map((AlgoliaObjectSnapshot doc) => AppUser.fromMap(doc.data))
            .toList();

      return users;
    });
  }

  /// text based search for given user input
  /// search takes into account searchable-terms configured in Algolia when performing this search
  Future<List<AppUser>> getUsersByText(String text) {
    return _algolia.instance
        .index('users')
        .search(text)
        .getObjects()
        .then((querySnapshot) {
      // retrieved records are stored in 'hits'
      List<AlgoliaObjectSnapshot> snapshot = querySnapshot.hits;

      List<AppUser> users = [];

      if (snapshot.isNotEmpty)
        users = snapshot
            .map((AlgoliaObjectSnapshot doc) => AppUser.fromMap(doc.data))
            .toList();

      return users;
    });
  }

  /// nearby search on given lat-lng, within 5 km of the user's current location in this case
  Future<List<AppUser>> getNearbyUsers(double lat, double lng) {
    return _algolia.instance
        .index('users')
        .setAroundLatLng('$lat, $lng')
        .setAroundRadius(5 * 1000)
        .getObjects()
        .then((querySnapshot) {
      // retrieved records are stored in 'hits'
      List<AlgoliaObjectSnapshot> snapshot = querySnapshot.hits;

      List<AppUser> vendors = [];

      if (snapshot.isNotEmpty)
        vendors = snapshot
            .map((AlgoliaObjectSnapshot doc) => AppUser.fromMap(doc.data))
            .toList();

      return vendors;
    });
  }

  /// query by facetFilter; users having at least 1 interest matching the provided List<String> interests
  Future<List<AppUser>> getUsersByInterests(List<String> interests) {
    String queryString = _getFullCategoriesQuery(interests);

    return _algolia.instance
        .index('users')
        .setFacetFilter('interests')
        .setFilters(queryString)
        .getObjects()
        .then((querySnapshot) {
      List<AlgoliaObjectSnapshot> snapshot = querySnapshot.hits;

      List<AppUser> users = [];

      if (snapshot.isNotEmpty)
        users = snapshot
            .map((AlgoliaObjectSnapshot doc) => AppUser.fromMap(doc.data))
            .toList();

      return users;
    });
  }

  /// dynamically generates the query for facetFilter:
  /// e.g:- interests:dota OR interests:cats OR interests:food
  String _getFullCategoriesQuery(List<String> categoryIds) {
    String queryString = '';

    for (int i = 0; i < categoryIds.length; i++) {
      if (i == categoryIds.length - 1) {
        queryString += 'interests:' + categoryIds[i];
        break;
      }

      queryString += 'interests:' + categoryIds[i] + ' OR ';
    }
    return queryString;
  }
}
