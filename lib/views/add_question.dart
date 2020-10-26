import 'package:flutter/material.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;

  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  String question, option1, option2, option3, option4;
  bool _isLoading = false;
  DatabaseService databaseService = DatabaseService();

  uploadQuestionData() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };
      await databaseService
          .addQuestionData(questionMap, widget.quizId)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: appBarPages(context, "Add Question"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        centerTitle: true,
        //iconTheme: IconThemeData(color: Theme.of(context).primaryColor,),
      ),
      body: _isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: [
                    TextFormField(
                      maxLines: 4,
                      validator: (value) =>
                          value.isEmpty ? "Enter question" : null,
                      decoration: InputDecoration(
                        labelText: 'Question',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide()),
                      ),
                      onChanged: (value) {
                        question = value;
                      },
                      maxLength: 150,
                      maxLengthEnforced: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 100),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Enter Option1 (Correct One)" : null,
                      decoration: InputDecoration(
                        labelText: 'Option1 (Correct One)',
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide()),
                      ),
                      onChanged: (value) {
                        option1 = value;
                      },
                      maxLength: 50,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 100),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Enter Option2" : null,
                      decoration: InputDecoration(
                        labelText: 'Option2',
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide()),
                      ),
                      onChanged: (value) {
                        option2 = value;
                      },
                      maxLength: 50,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 100),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Enter Option3" : null,
                      decoration: InputDecoration(
                        labelText: 'Option3',
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide()),
                      ),
                      onChanged: (value) {
                        option3 = value;
                      },
                      maxLength: 50,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 100),
                    TextFormField(
                      validator: (value) =>
                          value.isEmpty ? "Enter Option4" : null,
                      decoration: InputDecoration(
                        labelText: 'Option4',
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide()),
                      ),
                      onChanged: (value) {
                        option4 = value;
                      },
                      maxLength: 50,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: submitButton(
                                context: context,
                                text: "Submit",
                                buttonWith:
                                    MediaQuery.of(context).size.width / 2.5)),
                        GestureDetector(
                            onTap: () {
                              uploadQuestionData();
                            },
                            child: submitButton(
                                context: context,
                                text: "Add Question",
                                buttonWith:
                                    MediaQuery.of(context).size.width / 2.5)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
