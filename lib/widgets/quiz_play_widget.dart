import 'package:flutter/material.dart';

class OptionTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;

  const OptionTile(
      {@required this.option,
      @required this.description,
      @required this.correctAnswer,
      @required this.optionSelected});
  @override
  _OptionTileState createState() => _OptionTileState();
}

class _OptionTileState extends State<OptionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: widget.description == widget.optionSelected
                        ? widget.optionSelected == widget.correctAnswer
                            ? Colors.green.withOpacity(0.7)
                            : Colors.red.withOpacity(0.7)
                        : Colors.grey,
                    width: 1.0),
                color: widget.description == widget.optionSelected
                    ? widget.optionSelected == widget.correctAnswer
                        ? Colors.green.withOpacity(0.7)
                        : Colors.red.withOpacity(0.7)
                    : Colors.transparent),
            child: Text(
              "${widget.option}",
              style: TextStyle(
                  fontWeight: widget.description == widget.optionSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 18,
                  color: widget.description == widget.optionSelected
                      ? Colors.white
                      : Colors.grey),
            ),
          ),
          SizedBox(width: 10),
          Text(
            widget.description,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 17,
            ),
          )
        ],
      ),
    );
  }
}
