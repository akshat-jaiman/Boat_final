import 'package:boat/models/userdetail.dart';
import 'package:boat/net/chatdatabase.dart';
import 'package:boat/ui/conversation_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class SearchChat extends StatefulWidget {
  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  TextEditingController searchText = new TextEditingController();
  ChatDatabaseMethods databaseMethods = new ChatDatabaseMethods();
  QuerySnapshot searchSnapshot;
  var loggedinUser = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  UserData currentUser;

  void _getUserName() async {
    var doc = await firestore.collection('users').doc(loggedinUser.uid).get();
    setState(() {
      currentUser = UserData.fromDocument(doc);
    });

    print(currentUser.name);
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(searchText.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
      print("$searchSnapshot");
    });
  }

  createChatroomAndStartConversation({String userName}) {
    if (userName != currentUser.name) {
      String chatroomId = getchatroomId(userName, currentUser.name);

      List<String> users = [userName, currentUser.name];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatroomId
      };
      databaseMethods.createChatRoom(chatroomId, chatRoomMap);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatroomId: chatroomId,
            userName: userName,
            currentuser: currentUser,
          ),
        ),
      );
    } else {
      Toast.show("Cannot send message to self", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
    }
  }

  Widget searchTile({String username, String useremail}) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [Text(username), Text(useremail)],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName: username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Text('message'),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot == null
        ? Container()
        : ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              print(searchSnapshot.docs[index].data()["Name"]);
              return searchTile(
                username: searchSnapshot.docs[index].data()["Name"],
                useremail: searchSnapshot.docs[index].data()["Email"],
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Personal Chat',
          style: GoogleFonts.teko(
            color: Colors.black,
            fontSize: 40,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        color: Colors.blue.shade300,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              color: Colors.white54,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchText,
                      decoration: InputDecoration(
                        hintText: "Search Name",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Icon(Icons.search),
                    onTap: () {
                      initiateSearch();
                      print('tapped');
                    },
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

/*class SearchTile extends StatelessWidget {
  final String username;
  final String useremail;

  const SearchTile({Key key, this.username, this.useremail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [Text(username), Text(useremail)],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Text('message'),
            ),
          )
        ],
      ),
    );
  }
}
*/
getchatroomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
