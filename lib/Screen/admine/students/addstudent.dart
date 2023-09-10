import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_management/method/admindata.dart';
import 'package:library_management/method/variables/globalVariable.dart';
import 'package:library_management/widget/textfieldColor.dart';

// ignore: must_be_immutable
class AddStudents extends StatefulWidget {
  AdminData admdata;
  AddStudents({Key? key, required this.admdata}) : super(key: key);

  @override
  _AddStudentsState createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  String? nameController;
  String? studentIdController;
  String? mobileController;
  String? emailController;
  String? passwordController;
  final formKey = GlobalKey<FormState>();

  var title = "Add New User";

  CollectionReference studentcollection =
      FirebaseFirestore.instance.collection("student");

  var admcollection;
  var id;
  final _auth = FirebaseAuth.instance;

  uploadImage(BuildContext context, index, currentUId) async {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yy');
    String formattedDate = formatter.format(now);
    Map<String, dynamic> students = {
      "name": nameController,
      "studentId": studentIdController,
      "mobile": "+91${mobileController!}",
      "email": emailController,
      "password": passwordController,
      "Date": formattedDate,
      "studentkey": id,
      "Issuebooks": 0,
      "Returnbooks": 0,
    };

    studentcollection.doc(currentUId).set(students);
    admcollection
        .doc(currentUId)
        .set(students)
        .then((value) => Navigator.of(context).pop());
  }

  @override
  initState() {
    super.initState();

    admcollection = FirebaseFirestore.instance
        .collection("Admin")
        .doc(widget.admdata.key)
        .collection("student");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appbar(title),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.indigo),
                          ),
                          width: 100,
                          height: 100,
                          child:
                              Image.network(userUrl, height: 100, width: 100),
                        ),
                        onTap: () {
                          // pickimages();
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //    controller: nameController,
                      decoration: textfield(
                          studentlabel, studenthint, usericon, nameController),
                      onChanged: (value) {
                        setState(() {
                          nameController = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //   controller: studentIdController,
                      decoration: textfield(studentIdlabel, studentidhint,
                          idicon, studentIdController),

                      onChanged: (value) {
                        setState(() {
                          studentIdController = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //     controller: mobileController,
                      decoration: textfield(
                          mobilelabel, mobilehint, mobile, mobileController),
                      onChanged: (value) {
                        setState(() {
                          mobileController = value;
                        });
                      },
                      validator: (value) {
                        mobileController = value;
                        if (value!.isEmpty) {
                          return "pleae enter valid mobile number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //        controller: emailController,
                      decoration: textfield(
                          emaillabel, emailhint, emailicon, emailController),
                      onChanged: (value) {
                        setState(() {
                          emailController = value;
                        });
                      },
                      validator: (value) {
                        emailController = value;
                        if (value!.isEmpty) {
                          return "Enter please enter valide email id";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      //     controller: passwordController,
                      decoration: textfield(
                          passlabel, passhint, passicon, passwordController),
                      onChanged: (value) {
                        setState(() {
                          passwordController = value;
                        });
                      },
                      validator: (value) {
                        passwordController = value;
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 60,
                      width: 150,
                      decoration: buttondecoration(),
                      child: ElevatedButton(
                        style: buttonstyle(),
                        child: loading == true
                            ? const CircularProgressIndicator()
                            // ignore: prefer_const_constructors
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.person_add,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "  Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                        onPressed: () {
                          int index = 0;
                          setState(() {
                            loading = true;
                          });
                          try {
                            if (formKey.currentState!.validate()) {
                              _auth
                                  .createUserWithEmailAndPassword(
                                      email: emailController.toString().trim(),
                                      password:
                                          passwordController.toString().trim())
                                  .then((value) {})
                                  .whenComplete(() {
                                setState(() {
                                  id = _auth.currentUser!.uid;
                                  uploadImage(context, index, id);
                                });
                                loading = false;
                              });
                            }
                            // ignore: empty_catches
                          } catch (e) {}
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // pickimages() async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.white,
  //           title: const Text("Pick image from"),
  //           // content: Text("Pick from any one"),
  //           actions: [
  //             //   color: Colors.indigo[200],
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 IconButton(
  //                     onPressed: () {
  //                       var camera = "camera";
  //                       getImages(camera);
  //                       Navigator.of(context).pop();
  //                     },
  //                     icon: Icon(
  //                       Icons.camera_alt,
  //                       size: 45,
  //                       color: Colors.indigo[900],
  //                     )),
  //                 IconButton(
  //                     onPressed: () {
  //                       var camera = "gallery";
  //                       getImages(camera);
  //                       Navigator.of(context).pop();
  //                     },
  //                     icon: Icon(
  //                       Icons.image,
  //                       size: 45,
  //                       color: Colors.indigo[900],
  //                     )),
  //               ],
  //             ),
  //           ],
  //         );
  //       });
  // }
}
