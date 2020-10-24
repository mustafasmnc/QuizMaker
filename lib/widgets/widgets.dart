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
