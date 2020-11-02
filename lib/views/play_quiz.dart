import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizmaker/models/question_model.dart';
import 'package:quizmaker/services/database.dart';
import 'package:quizmaker/views/result.dart';
import 'package:quizmaker/widgets/quiz_play_widget.dart';
import 'package:quizmaker/widgets/widgets.dart';

int _total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class PlayQuiz extends StatefulWidget {
  final String quizId;

  const PlayQuiz({this.quizId});
  @override
  _PlayQuizState createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService = DatabaseService();
  QuerySnapshot questionSnapshot;

  QuestionModel getQuestionModelFromDataSnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = QuestionModel();
    questionModel.question = questionSnapshot["question"];
    List<String> options = [
      questionSnapshot["option1"],
      questionSnapshot["option2"],
      questionSnapshot["option3"],
      questionSnapshot["option4"],
    ];
    options.shuffle();
    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot["option1"];
    questionModel.answered = false;
    return questionModel;
  }

  @override
  void initState() {
    print("Quiz ID: ${widget.quizId}");
    databaseService.getQuizQuestionAnswer(widget.quizId).then((value) {
      questionSnapshot = value;
      _notAttempted = questionSnapshot.docs.length;
      _correct = 0;
      _incorrect = 0;
      _total = questionSnapshot.docs.length;
      print("Total Question: $_total");
      setState(() {});
    });
    super.initState();
  }

  Widget topInfo() {
    return Container(
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          MyCustomContainer(
            title: "Total",
            number: _total,
            progress: 0.7,
            size: 30,
            backgroundColor: Color(0xFF16F4D0),
            progressColor: Color(0xFF429EA6),
          ),
          SizedBox(width: 10),
          MyCustomContainer(
            title: "Correct",
            number: _correct,
            progress: 0.7,
            size: 40,
            backgroundColor: Color(0xFF16F4D0),
            progressColor: Color(0xFF429EA6),
          ),
          SizedBox(width: 10),
          MyCustomContainer(
            title: "Incorrect",
            number: _incorrect,
            progress: 0.7,
            size: 40,
            backgroundColor: Color(0xFF16F4D0),
            progressColor: Color(0xFF429EA6),
          ),
          SizedBox(width: 10),
          MyCustomContainer(
            title: "NotAttempted",
            number: _notAttempted,
            progress: 0.7,
            size: 55,
            backgroundColor: Color(0xFF16F4D0),
            progressColor: Color(0xFF429EA6),
          ),
        ],
      ),
    );
  }

  // @override
  // void setState(fn) {
  //   super.setState(fn);
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBarPages(context, "Play Quiz"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: questionSnapshot == null
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Column(
                children: [
                  topInfo(),
                  SizedBox(height: 15),
                  Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: ClampingScrollPhysics(),
                        itemCount: questionSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          return QuizPlaytile(
                            questionModel: getQuestionModelFromDataSnapshot(
                                questionSnapshot.docs[index]),
                            index: index,
                          );
                        }),
                  )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Result(
                      correctAnswer: _correct,
                      incorrectAnswer: _incorrect,
                      totalAnswer: _total)));
        },
      ),
    );
  }
}

class QuizPlaytile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlaytile({this.questionModel, this.index});
  @override
  _QuizPlaytileState createState() => _QuizPlaytileState();
}

class _QuizPlaytileState extends State<QuizPlaytile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.index + 1}-) ${widget.questionModel.question}",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 17,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 50),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  //correct
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  //incorrect
                  optionSelected = widget.questionModel.option1;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                  print(
                      "${widget.index + 1}. Question Correct Answer: ${widget.questionModel.correctOption}");
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option1,
              option: "A",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  //correct
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  //incorrect
                  optionSelected = widget.questionModel.option2;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                  print(
                      "${widget.index + 1}. Question Correct Answer: ${widget.questionModel.correctOption}");
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option2,
              option: "B",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  //correct
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  //incorrect
                  optionSelected = widget.questionModel.option3;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                  print(
                      "${widget.index + 1}. Question Correct Answer: ${widget.questionModel.correctOption}");
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option3,
              option: "C",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  //correct
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                } else {
                  //incorrect
                  optionSelected = widget.questionModel.option4;
                  widget.questionModel.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted - 1;
                  setState(() {});
                  print(
                      "${widget.index + 1}. Question Correct Answer: ${widget.questionModel.correctOption}");
                }
              }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option4,
              option: "D",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 20),
        ],
      ),
    );
  }
}
