import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:it_support/dialogs/policy_dialog.dart';


class TermsOfUse extends StatelessWidget {
  const TermsOfUse({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
          text: "By creating an account, you are agreeing to our",
          style: TextStyle(color: Colors.white, fontSize: 14),
          children: [
            TextSpan(
              text: "Terms & Conditions ",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    //configuration: FadeScaleTransitionConfiguration(),
                    builder: (context) {
                      return PolicyDialog(
                        mdFileName: 'terms_and_conditions.md',
                      );
                    },
                  );
                },
            ),
            TextSpan(text: "and and that you have read our "),
            TextSpan(
              text: "Privacy Policy",
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return PolicyDialog(
                        mdFileName: 'privacy_policy.md',
                      );
                    },
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}