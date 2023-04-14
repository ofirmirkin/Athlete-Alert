import 'package:flutter/material.dart';
import 'map.dart';
import 'menu-page.dart';

// Everything is hard coded at the moment
// Need to pull user details from db
//

class AccDetailsHome extends StatelessWidget {
  const AccDetailsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(47, 36, 255, 1),
        title: const Text(
                  "Account Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
        centerTitle: true,
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
            color: Color.fromRGBO(47, 36, 255, 1),
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
                            'https://instagram.fdub7-1.fna.fbcdn.net/v/t51.2885-19/209080492_326970612307483_2835102815111713539_n.jpg?stp=dst-jpg_s150x150&_nc_ht=instagram.fdub7-1.fna.fbcdn.net&_nc_cat=107&_nc_ohc=E6zekHs1LOQAX9rFNyF&edm=AOQ1c0wBAAAA&ccb=7-5&oh=00_AfAS_SZjw3bS7BgKN8Tx748405DyIrODI4F4x1ANbWE_Gw&oe=643C9480&_nc_sid=8fd12b'),
                        backgroundColor: Colors.white,
                      )),
                ),
                const Spacer(),
                const Text(
                  "Athlete Alert",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Spacer(),
                // Menu icon in top right corner, change to icon button in future
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NavDrawer();
                    }));
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 40,
                    color: Colors.white,
                  ),
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
            color:  Color.fromRGBO(47, 36, 255, 1),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapSample()),
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 30,
                      color: Colors.white,
                    )),
                const Spacer(),
                const Text(
                  "Account Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
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
  List<String> fieldNames = [
    'Name',
    'Username',
    'Birthday',
    'Mobile Number',
    'Email'
  ];
  List<String> userData = [
    'John Doe',
    'bigJD_123',
    '29 February 2030',
    '189 022 2222',
    'JohnDoe@hotmail.ie'
  ];


//IconData(0xee35, fontFamily: 'MaterialIcons')
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: userData.length,
      itemBuilder: (BuildContext context, int index)
      {
        return Card(
            child: ListTile(
              title: Text(
                fieldNames[index],
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
                ),
          //       shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(80),
          // ),
              subtitle: Text(userData[index]),
              onTap: () {
                _editUserName(context, index);
              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              tileColor: const Color.fromARGB(255, 164, 195, 248),

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
          backgroundColor: const Color.fromARGB(255, 164, 195, 248),
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
