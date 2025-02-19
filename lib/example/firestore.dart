

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class FirestoreExample extends StatefulWidget {
//   @override
//   _FirestoreExampleState createState() => _FirestoreExampleState();
// }

// class _FirestoreExampleState extends State<FirestoreExample> {
//   final TextEditingController _nameController = TextEditingController();
//   final CollectionReference users = FirebaseFirestore.instance.collection('users');

//   // Add Data
//   Future<void> addUser() {
//     return users.add({
//       'name': _nameController.text,
//       'timestamp': FieldValue.serverTimestamp(),
//     }).then((value) {
//       _nameController.clear();
//     }).catchError((error) {
//       print("Failed to add user: $error");
//     });
//   }

//   // Update Data
//   Future<void> updateUser(String docId) {
//     return users.doc(docId).update({
//       'name': _nameController.text,
//     }).then((value) {
//       _nameController.clear();
//     }).catchError((error) {
//       print("Failed to update user: $error");
//     });
//   }

//   // Delete Data
//   Future<void> deleteUser(String docId) {
//     return users.doc(docId).delete().catchError((error) {
//       print("Failed to delete user: $error");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Firestore CRUD Example")),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(10),
//             child: TextField(
//               controller: _nameController,
//               decoration: InputDecoration(labelText: "Enter Name"),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: addUser,
//             child: Text("Add User"),
//           ),
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: users.orderBy('timestamp', descending: true).snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

//                 final docs = snapshot.data!.docs;
//                 return ListView.builder(
//                   itemCount: docs.length,
//                   itemBuilder: (context, index) {
//                     var doc = docs[index];
//                     return ListTile(
//                       title: Text(doc['name']),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               _nameController.text = doc['name'];
//                               updateUser(doc.id);
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => deleteUser(doc.id),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
