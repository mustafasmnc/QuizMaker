import 'package:flutter/material.dart';

Widget appBar(BuildContext context) {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 22),
      children: <TextSpan>[
        TextSpan(
            text: 'Quiz',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            )),
        TextSpan(
            text: 'Maker',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            )),
      ],
    ),
  );
}

Widget appBarPages(BuildContext context, String title) {
  return Text(title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).primaryColor,
      ));
}

Widget submitButton({BuildContext context, String text, buttonWith}) {
  return Container(
    height: 50,
    alignment: Alignment.center,
    width: buttonWith != null ? buttonWith : MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}

class MyCustomContainer extends StatefulWidget {
  final Color backgroundColor;
  final Color progressColor;
  final double progress;
  final double size;
  final int number;
  final String title;

  const MyCustomContainer({
    Key key,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.red,
    @required this.progress,
    @required this.size,
    @required this.number,
    @required this.title,
  }) : super(key: key);

  @override
  _MyCustomContainerState createState() => _MyCustomContainerState();
}

class _MyCustomContainerState extends State<MyCustomContainer> {
  void callBack() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new SizedBox(
        width: widget.size * 3,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              width: 40,
              decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: new Text(
                "${widget.number}",
                style: new TextStyle(
                    color: Colors.black45, fontWeight: FontWeight.bold),
              ),
            ),
            new Container(
              width: widget.size * 3 - 40,
              decoration: BoxDecoration(
                  color: widget.progressColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: new Text(
                widget.title,
                style: new TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
