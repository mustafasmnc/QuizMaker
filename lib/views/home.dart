import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizmaker/helper/functions.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/create_quiz.dart';
import 'package:quizmaker/views/play_quiz.dart';
import 'package:quizmaker/views/signin.dart';
import 'package:quizmaker/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  String userId;

  HomePage({this.userId});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream quizStream;
  DatabaseService databaseService = DatabaseService();
  //String userId = "";
  String userName = "";
  String userImage =
      "https://www.talentstree.com/wp-content/uploads/2019/05/avatar.png";
  // getUserId() {
  //   HelperFunctions.getUserLoggedInID().then((value) {
  //     setState(() {
  //       userId = value;
  //     });
  //   });
  // }

  getUserName() async {
    await FirebaseFirestore.instance
        .collection("User")
        .doc(widget.userId)
        .get()
        .then((value) {
      print(value.data()["userName"]);
      setState(() {
        userName = value.data()["userName"];
      });
    });
  }

  @override
  void initState() {
    //getUserId();
    databaseService.getQuizData().then((value) {
      setState(() {
        quizStream = value;
      });
    });
    HelperFunctions.getUserLoggedInID().then((value) {
      setState(() {
        widget.userId = value;
      });
    });
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarPages(context, "Home Page"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: quizList(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            drawerHeader(),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 30,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Profile",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    size: 30,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Exit",
                        style: TextStyle(fontSize: 20),
                      ))
                ],
              ),
              onTap: () {
                HelperFunctions.saveUserLoggedInDetails(
                    isLoggedIn: false, userId: null);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateQuiz()));
        },
      ),
    );
  }

  Widget drawerHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/drawer_header_background.png'))),
        child: Stack(
          children: [
            Positioned(
                bottom: 12,
                left: 20,
                child: Text(
                  userName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ))
          ],
        ));
  }

  Widget quizList() {
    return Container(
      child: StreamBuilder(
          stream: quizStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return QuizTile(
                      imgUrl: ds["quizImgUrl"],
                      quizTitle: ds["quizTitle"],
                      quizDesc: ds["quizDesc"],
                      quizId: ds["quizId"],
                    );
                  });
            }
          }),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String quizTitle;
  final String quizDesc;
  final String quizId;

  const QuizTile(
      {@required this.imgUrl,
      @required this.quizTitle,
      @required this.quizDesc,
      @required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PlayQuiz(quizId: quizId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        height: MediaQuery.of(context).size.height / 4,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imgUrl,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    quizTitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 80),
                  Text(
                    quizDesc,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
