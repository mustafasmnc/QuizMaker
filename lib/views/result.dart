import 'package:flutter/material.dart';
import 'package:quizmaker/widgets/widgets.dart';

class Result extends StatefulWidget {
  final int correctAnswer;
  final int incorrectAnswer;
  final int totalAnswer;

  const Result(
      {Key key,
      @required this.correctAnswer,
      @required this.incorrectAnswer,
      @required this.totalAnswer})
      : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${widget.totalAnswer}/${widget.correctAnswer}"),
              SizedBox(height: 10),
              Text(
                "Total Question: ${widget.totalAnswer}",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),
              ),
              Text(
                "Correct Answer: ${widget.correctAnswer}",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),
              ),
              Text(
                "Incorrect Answer: ${widget.incorrectAnswer}",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: submitButton(
                      context: context,
                      text: "Home",
                      buttonWith: MediaQuery.of(context).size.width / 2))
            ],
          ),
        ),
      ),
    );
  }
}
