import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizmaker/models/category_model.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/add_question.dart';
import 'package:quizmaker/views/home.dart';
import 'package:quizmaker/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImage, quizTitle, quizDesc, quizId;
  String radioItem = '';
  // Group Value for Radio Button.
  int id = 1;
  DatabaseService databaseService = DatabaseService();
  bool _isLoading = false;

  List<CategoryModel> fList = [
    CategoryModel(
      index: 1,
      name: "History",
    ),
    CategoryModel(
      index: 2,
      name: "Math",
    ),
    CategoryModel(
      index: 3,
      name: "Literature",
    ),
    CategoryModel(
      index: 4,
      name: "General Knowledge",
    ),
  ];

  createQuiz() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      if (radioItem == "History")
        quizImage =
            "https://media.proprofs.com/images/QM/user_images/1826446/1497614295.jpg";
      if (radioItem == "Math")
        quizImage =
            "https://www.askmemath.com/wp-content/uploads/2019/10/bg.jpg";
      if (radioItem == "Literature")
        quizImage =
            "https://d5qsyj6vaeh11.cloudfront.net/images/whats%20available/literary%20ireland/literature-quiz/literature-quiz-bg-new.jpg";
      if (radioItem == "General Knowledge")
        quizImage =
            "https://cdn.leverageedu.com/blog/wp-content/uploads/2020/02/08152551/General-Knowledge-for-Kids.png";
      quizId = randomAlphaNumeric(16);
      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizTitle": quizTitle,
        "quizDesc": quizDesc,
        "quizImgUrl": quizImage
      };
      await databaseService.addQuizData(quizMap, quizId).then((value) {
        setState(() {
          _isLoading = false;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
        });
      });

      print(
          "Cat: $radioItem Title: $quizTitle Desc: $quizDesc Image: $quizImage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: appBarPages(context, "Create Quiz"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor, //change your color here
        ),
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    radioButton(),
                    SizedBox(height: MediaQuery.of(context).size.height / 60),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Enter quiz title" : null,
                      decoration: InputDecoration(
                        labelText: 'Quiz Title',
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide()),
                      ),
                      onChanged: (value) {
                        quizTitle = value;
                      },
                      maxLength: 50,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 60),
                    TextFormField(
                      maxLines: 5,
                      validator: (value) =>
                          value.isEmpty ? "Enter quiz description" : null,
                      decoration: InputDecoration(
                        labelText: 'Quiz Description',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide()),
                      ),
                      onChanged: (value) {
                        quizDesc = value;
                      },
                      maxLength: 150,
                      maxLengthEnforced: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 60),
                    GestureDetector(
                      onTap: () {
                        createQuiz();
                      },
                      child: submitButton(context: context,text: "Create Quiz"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget radioButton() {
    return Container(
      height: 150,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: fList.length,
                itemBuilder: (BuildContext context, int index) {
                  //return Text(litems[index].toString());
                  return Container(
                    height: 40,
                    child: RadioListTile(
                      title: Text(
                        fList[index].name.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                      groupValue: id,
                      value: fList[index].index,
                      onChanged: (val) {
                        print("RadioButton ${fList[index].name.toString()}");
                        setState(() {
                          id = fList[index].index;
                          radioItem = fList[index].name.toString();
                        });
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
