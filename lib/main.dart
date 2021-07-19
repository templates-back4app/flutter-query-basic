import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final keyApplicationId = 'YOUR_APP_ID_HERE';
  final keyClientKey = 'YOUR_CLIENT_KEY_HERE';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ParseObject> results = <ParseObject>[];

  void doQueryByName() async {
    // Create your query
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Profile'));

    // `whereContains` is a basic query method that checks if string field
    // contains a specific substring
    parseQuery.whereContains('name', 'Adam');

    // The query will resolve only after calling this method, retrieving
    // an array of `ParseObjects`, if success
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      // Let's show the results
      for (var o in apiResponse.results!) {
        print((o as ParseObject).toString());
      }

      setState(() {
        results = apiResponse.results as List<ParseObject>;
      });
    } else {
      results = [];
    }
  }

  void doQueryByFriendCount() async {
    // Create your query
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Profile'));

    // `whereGreaterThan` is a basic query method that does what it
    // says on the tin
    parseQuery.whereGreaterThan('friendCount', 20);

    // The query will resolve only after calling this method, retrieving
    // an array of `ParseObjects`, if success
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      // Let's show the results
      for (var o in apiResponse.results!) {
        print((o as ParseObject).toString());
      }

      setState(() {
        results = apiResponse.results as List<ParseObject>;
      });
    } else {
      results = [];
    }
  }

  void doQueryByOrdering() async {
    // Create your query
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Profile'));

    // `orderByDescending` and `orderByAscending(` can and should be chained
    // with other query methods to improve your queries
    parseQuery.orderByDescending('birthDay');

    // The query will resolve only after calling this method, retrieving
    // an array of `ParseObjects`, if success
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      // Let's show the results
      for (var o in apiResponse.results!) {
        print((o as ParseObject).toString());
      }
      setState(() {
        results = apiResponse.results as List<ParseObject>;
      });
    } else {
      results = [];
    }
  }

  void doQueryByAll() async {
    // Create your query
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Profile'));

    parseQuery
      ..whereContains('name', 'Adam')
      ..whereGreaterThan('friendCount', 20)
      ..orderByDescending('birthDay');

    // The query will resolve only after calling this method, retrieving
    // an array of `ParseObjects`, if success
    final ParseResponse apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      // Let's show the results
      for (var o in apiResponse.results!) {
        print((o as ParseObject).toString());
      }
      setState(() {
        results = apiResponse.results as List<ParseObject>;
      });
    } else {
      results = [];
    }
  }

  void doClearResults() async {
    setState(() {
      results = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            child: Image.network(
                'https://blog.back4app.com/wp-content/uploads/2017/11/logo-b4a-1-768x175-1.png'),
          ),
          Center(
            child: const Text('Flutter on Back4app - Basic Queries',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            child: ElevatedButton(
                onPressed: doQueryByName,
                child: Text('Query by name'),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            child: ElevatedButton(
                onPressed: doQueryByFriendCount,
                child: Text('Query by friend count'),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            child: ElevatedButton(
                onPressed: doQueryByOrdering,
                child: Text('Query by Ordening'),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            child: ElevatedButton(
                onPressed: doQueryByAll,
                child: Text('Query by all'),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            child: ElevatedButton(
                onPressed: doClearResults,
                child: Text('Clear results'),
                style: ElevatedButton.styleFrom(primary: Colors.blue)),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'Result List: ${results.length}',
          ),
          Expanded(
            child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(4),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Text(results[index].toString()),
                  );
                }),
          )
        ],
      ),
    ));
  }
}
