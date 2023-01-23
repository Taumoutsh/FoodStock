import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../options/option_popup.dart';

class OptionPopupItem extends StatefulWidget {

  final IconData iconData;

  const OptionPopupItem({super.key, required this.iconData});

  @override
  State<StatefulWidget> createState() => _OptionPopupItemState();

}

class _OptionPopupItemState extends State<OptionPopupItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
            onTap: _showDialog,
            child: Container(
              height: double.infinity,
              margin: const EdgeInsets.fromLTRB(11, 6, 11, 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0x00000000)),
              child: Icon(widget.iconData,
                  size: 30, color: Theme.of(context).colorScheme.secondary),
            )));
  }

  Future<void> _showDialog() {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return OptionPopup();
        });
  }
}
