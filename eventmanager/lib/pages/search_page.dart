import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search...'),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: UserSearchDelegate());
              },
              icon: const Icon(Icons.search))
        ],
      ),
    );
  }
}

class UserSearchDelegate extends SearchDelegate<String> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: searchForUsers(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final String name =
                  '${documents[index].get('firstname')} ${documents[index].get('lastname')}';
              return ListTile(
                title: Text(name),
                onTap: () {
                  close(context, name);
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: Text('No results found'),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder<QuerySnapshot>(
      future: searchForUsers(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final String name =
                '${documents[index].get('firstname')} ${documents[index].get('lastname')}';
            return ListTile(
              title: Text(name),
              onTap: () {
                close(context, name);
              },
            );
          },
        );
      },
    );
  }

  Future<QuerySnapshot> searchForUsers(String query) async {
    final QuerySnapshot snapshot = await firestore
        .collection('users')
        .where('firstname', isGreaterThanOrEqualTo: query)
        .where('firstname', isLessThan: '${query}z')
        .get();

    return snapshot;
  }
}
