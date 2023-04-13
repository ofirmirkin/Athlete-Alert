import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'menu-page.dart';

class SearchFriendsPage extends StatefulWidget {
  const SearchFriendsPage({Key? key}) : super(key: key);

  @override
  _SearchFriendsPageState createState() => _SearchFriendsPageState();
}

class _SearchFriendsPageState extends State<SearchFriendsPage> {
  final _searchController = TextEditingController();
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final _currentUser = FirebaseAuth.instance.currentUser;
  List<DocumentSnapshot> _searchResults = [];

  Future<void> _searchUsers(String searchQuery) async {
    QuerySnapshot usersSnapshot = await _usersCollection
        .where('email', isEqualTo: searchQuery)
        .get();
    setState(() {
      _searchResults = usersSnapshot.docs;
    });
  }

  Future<void> _sendFriendRequest(String targetUserId) async {
    await _usersCollection
        .doc(targetUserId)
        .collection('friendRequests')
        .doc(_currentUser!.uid)
        .set({'email': _currentUser!.email});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Friends'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    await _searchUsers(_searchController.text.trim());
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_searchResults[index]['email']),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await _sendFriendRequest(_searchResults[index].id);
                    },
                    child: Text('Send Request'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}