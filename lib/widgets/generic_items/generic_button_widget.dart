import 'package:flutter/material.dart';

class GenericButtonWidget extends StatefulWidget {

  final List<Color> colorsToApply;

  final GestureTapCallback onTapFunction;

  final IconData iconData;

  final double iconSize;

  const GenericButtonWidget(
      {super.key,
      required this.colorsToApply,
      required this.onTapFunction,
      required this.iconData,
      required this.iconSize});

  @override
  State<StatefulWidget> createState() => _GenericButtonWidget();
}

class _GenericButtonWidget extends State<GenericButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTapFunction,
        child: Container(
            height: double.infinity,
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            constraints: const BoxConstraints(
              maxHeight: 70,
              maxWidth: 70,
              minHeight: 30,
              minWidth: 30,
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: widget.colorsToApply),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.surface,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(0, 4))
                ]),
            child: Icon(
              widget.iconData,
              size: widget.iconSize,
              color: Theme.of(context).colorScheme.onBackground,
            )));
  }
}
