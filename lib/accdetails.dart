import 'package:flutter/material.dart';
import 'package:never_surf_alone/main_page.dart';
import 'map.dart';

// Everything is hard coded at the moment
// Need to pull user details from db
// 


class AccDetailsHome extends StatelessWidget {
  const AccDetailsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
        flexibleSpace: const MenuAppBar(),
      ),
      body: const AccountDetailList(),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Expanded(
          child: Container(
            color: Colors.cyan,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: FloatingActionButton.small(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const AccDetailsHome();
                        }));
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            //placeholder profile picture
                            'https://marketplace.canva.com/EAFEits4-uw/1/0/1600w/canva-boy-cartoon-gamer-animated-twitch-profile-photo-oEqs2yqaL8s.jpg'),
                        backgroundColor: Colors.cyanAccent,
                      )),
                ),
                const Spacer(),
                const Text(
                  "Never Surf Alone",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Spacer(),
                // Menu icon in top right corner, change to icon button in future
                const Icon(
                  Icons.menu,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MenuAppBar extends StatelessWidget {
  const MenuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        Expanded(
          child: Container(
            color: Colors.cyan,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MainPage();
                      }));
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                      color: Colors.white,
                    )),
                const Spacer(),
                const Text(
                  "Account Details",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Spacer(),
                const SizedBox(width: 50),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class AccountDetailList extends StatefulWidget {
  const AccountDetailList({super.key});
  @override
  _AccountDetailListState createState() => _AccountDetailListState();
}

class _AccountDetailListState extends State<AccountDetailList> {
  List<String> fieldNames = ['Name', 'Username', 'Birthday', 'Mobile Number', 'Email'];
  List<String> userData = ['John Doe', 'bigJD_123', '29 February 2030', '189 022 2222', 'JohnDoe@hotmail.ie'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userData.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
            child: ListTile(
              title: Text(
                fieldNames[index],
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
                ),
              subtitle: Text(userData[index]),
              onTap: () {
                _editUserName(context, index);
              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              tileColor: const Color.fromARGB(255, 198, 248, 244),
            )
          );
      },
    );
  }

  void _editUserName(BuildContext context, int index) async {
    String newUserName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: userData[index]);
        return AlertDialog(
          title: Text('Edit ${fieldNames[index]}'),
          backgroundColor: const Color.fromARGB(255, 198, 248, 244),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'New ${fieldNames[index]}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (newUserName != null) {
      setState(() {
        userData[index] = newUserName;
      });
    }
  }
}