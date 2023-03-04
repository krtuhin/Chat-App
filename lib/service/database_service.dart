import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String? uid;

  DatabaseService({this.uid});

  //reference of our user collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //saving the user data

  Future saveUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid
    });
  }

  //getting user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // getting our groups

  Future getUserGroups() async {
    return await userCollection.doc(uid).snapshots();
  }

  //creating a group

  Future createGroup(String userName, String uid, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${uid}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "recentMessageTime": "",
    });

    //update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);

    return userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  //getting the chats
  Future getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection("message")
        .orderBy("time")
        .snapshots();
  }

//to get group admin
  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"];
  }

  // to get the group members
  Future getGroupMember(String groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }

//search
  Future searchByName(String groupName) async {
    return await groupCollection
        .where(
          "groupName",
          isEqualTo: groupName,
        )
        .get();
  }

//function --> bool

  Future isUserJoined(String groupId, String groupName, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List groups = documentSnapshot["groups"];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

// toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
//doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List groups = documentSnapshot["groups"];
//if user has the group then remove them or also re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // send message
  Future sendMessage(
      String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("message").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData["message"],
      "recentMessageSender": chatMessageData["sender"],
      "recentMessageTime": chatMessageData["time"].toString(),
    });
  }
}
