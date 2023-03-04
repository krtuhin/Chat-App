import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  bool _isLoading = false;

  String userName = "";
  User? user;

  bool _isJoined = false;

  @override
  void initState() {
    getUserIdAndName();
    super.initState();
  }

  getUserIdAndName() async {
    await HelperFunctions.getUserNameSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getAdmin(String str) {
    return str.substring(str.indexOf("_") + 1);
  }

  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    searchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : groupList(),
        ],
      ),
    );
  }

  searchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService().searchByName(searchController.text).then((value) {
        setState(() {
          searchSnapshot = value;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                  userName,
                  searchSnapshot!.docs[index]["groupId"],
                  searchSnapshot!.docs[index]["groupName"],
                  searchSnapshot!.docs[index]["admin"]);
            },
          )
        : Container();
  }

  joinedOrNot(
      String userName, String groupName, String groupId, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupId, groupName, userName)
        .then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    //if user already joined the group or not
    joinedOrNot(userName, groupName, groupId, admin);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
      ),
      subtitle: Text("Admin: ${getAdmin(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            showSnackbar(
                context, Colors.green, "Successfully joined the group");
            Future.delayed(const Duration(seconds: 2), () {
              nextScreen(
                  context,
                  ChatPage(
                      groupName: groupName,
                      userName: userName,
                      groupId: groupId));
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });
            showSnackbar(context, Colors.red, "Lift the group ${groupName}");
          }
        },
        child: _isJoined
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1)),
                child: const Text(
                  "Joined",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Join Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
      ),
    );
  }
}
