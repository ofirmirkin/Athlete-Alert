import 'package:flutter/material.dart';
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
      body: const AccSettings(),
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
                        Navigator.pushReplacement(context,
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return MapSample();
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

class AccSettings extends StatelessWidget {
  const AccSettings({super.key});
  // Will Need to be stateful when pulling from database
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          child: ListTile(
            title: const Text("Name"),
            subtitle: const Text("Brian Barrett"),
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            tileColor: const Color.fromARGB(255, 158, 245, 238),
          )
        ),
        Card(
          child: ListTile(
            title: const Text("Username"),
            subtitle: const Text("barretbr"),
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            tileColor: const Color.fromARGB(255, 158, 245, 238),
          )
        ),
        Card(
          child: ListTile(
            title: const Text("Birthday"),
            subtitle: const Text("20 November 2001"),
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            tileColor: const Color.fromARGB(255, 158, 245, 238),
          )
        ),
        Card(
          child: ListTile(
            title: const Text("Mobile Number"),
            subtitle: const Text("083 696 6969"),
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            tileColor: const Color.fromARGB(255, 158, 245, 238),
          )
        ),
        Card(
          child: ListTile(
            title: const Text("Email"),
            subtitle: const Text("barretbr@tcd.ie"),
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            tileColor: const Color.fromARGB(255, 158, 245, 238),
          )
        ),
        Card(
          child: ListTile(
            title: const Text("Profile Picture"),
            onTap: () {},
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            tileColor: const Color.fromARGB(255, 158, 245, 238),
          )
        ),
      ],
    );
  }
}
