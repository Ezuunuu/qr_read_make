import 'package:flutter/material.dart';

class CustomAlertDialog {
  Future<void> showAlertDialog({required BuildContext context, String title = '', required Widget content, required Color backgroundColor, bool dismissible = true, bool alwaysDismissible = false}) async {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Material(
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: PopScope(
                canPop: dismissible,
                child: Transform.scale(
                  scale: a1.value,
                  child: Opacity(
                    opacity: a1.value,
                    child: InkWell(
                      onTap: () {
                        if (alwaysDismissible) Navigator.of(context).pop();
                      },
                      child: AlertDialog(
                        contentPadding: const EdgeInsets.all(10),
                        titlePadding: const EdgeInsets.all(15),
                        elevation: 0,
                          backgroundColor: backgroundColor,
                          shape: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.transparent
                              ),
                              borderRadius: BorderRadius.circular(16.0)
                          ),
                          title: title != '' ? Text(title, style: const TextStyle(color: Colors.white)) : null,
                          content: content
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 150),
        barrierDismissible: dismissible,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        }
    );
  }
}
