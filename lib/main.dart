import 'package:flutter/material.dart';
import 'services/services.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AlgoliaService algoliaService = AlgoliaService();

  final TextEditingController _searchController = TextEditingController();
  List<AppUser> users = []; // users retrieved from Algolia

  bool isLoading = false; // to control CircularProgressIndicator()
  bool customSearch = false; // to show/hide reset button in app bar

  @override
  void initState() {
    super.initState();

    getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: Colors.white, fontSize: 16.0),
          decoration: InputDecoration(
            icon: Icon(
              Icons.search,
              color: Colors.grey[700],
            ),
            hintText: 'Search someone',
            hintStyle: TextStyle(color: Colors.grey[700]),
            border: InputBorder.none,
          ),
          onSubmitted: (queryString) {
            searchUsersByText(queryString);
          },
          keyboardType: TextInputType.text,
        ),
        actions: customSearch
            ? [
                TextButton(
                  onPressed: getAllUsers,
                  child: Text(
                    'Reset',
                    style: TextStyle(color: Colors.yellow),
                  ),
                ),
              ]
            : null,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.my_location),
        onPressed: getNearbyUsers,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : users.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(users[index].photoUrl),
                      radius: 30,
                    ),
                    title: Text(users[index].name),
                    subtitle: Text(users[index].interests.join(', ')),
                  ),
                )
              : Center(
                  child: Text('No users found!'),
                ),
    );
  }

  Future<void> getAllUsers() async {
    setState(() {
      isLoading = true;
      users.clear();
    });
    List<AppUser> result = await algoliaService.getAllUsers();
    if (result.isNotEmpty) {
      setState(() {
        users = [];
        users.addAll(result);
        customSearch = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> searchUsersByText(String queryString) async {
    if (queryString.trim().isNotEmpty) {
      setState(() {
        isLoading = true;
        users.clear();
      });
      List<AppUser> result = await algoliaService.getUsersByText(queryString);
      if (result.isNotEmpty) {
        setState(() {
          users = [];
          users.addAll(result);
          customSearch = true;
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getNearbyUsers() async {
    setState(() {
      isLoading = true;
      users.clear();
    });
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<AppUser> result = await algoliaService.getNearbyUsers(
          currentPosition.latitude, currentPosition.longitude);
      if (result.isNotEmpty) {
        setState(() {
          users = [];
          users.addAll(result);
          customSearch = true;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
