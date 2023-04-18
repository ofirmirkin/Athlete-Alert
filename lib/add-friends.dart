import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final _currentUser = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot> _friendsStream() {
    return _usersCollection
        .doc(_currentUser!.uid)
        .collection('friends')
        .snapshots();
  }

  Stream<QuerySnapshot> _friendRequestsStream() {
    return _usersCollection
        .doc(_currentUser!.uid)
        .collection('friendRequests')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:  Color.fromRGBO(47, 36, 255, 1),   //Background colour at add friends
          title: Text('Friends'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Added Friends'),
              Tab(text: 'Friend Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _friendsStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['email']),
                    );
                  },
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _friendRequestsStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data!.docs[index]['email']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              // Accept friend request
                            },
                            child: Text('Accept'),
                          ),
                          SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              // Reject friend request
                            },
                            child: Text('Reject'),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}