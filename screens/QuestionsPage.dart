import 'package:flutter/material.dart';
import 'package:flutter_survey/flutter_survey.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/validation.dart';

class QuestionsPage extends StatefulWidget {
  bool isDark;
  Function updateState;
  QuestionsPage(this.isDark, this.updateState);

  @override
  _MyQuestionsPage createState() => _MyQuestionsPage();
}

class _MyQuestionsPage extends State<QuestionsPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarExample bottomNavigationBarExample =
        //  BottomNavigationBarExample(widget.isDark, widget.updateState);
        BottomNavigationBarExample();
    int validate = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Mental health test",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 20.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Survey(
                onNext: (questionResults) {
                  print(questionResults);
                  //store the result
                },
                initialData: [
                  Question(
                      question:
                          "Little interest or pleasure in doing things Feeling down, depressed, or hopeless?",
                      isMandatory: true,
                      answerChoices: const {
                        "Not at all": null,
                        "Several days": null,
                        "Nearly every day": null,
                      }),
                  Question(
                      question:
                          "Trouble falling or staying asleep, or sleeping too much?",
                      isMandatory: true,
                      answerChoices: const {
                        "Not at all": null,
                        "Several days": null,
                        "Nearly every day": null,
                      }),
                  Question(
                      question: "Feeling tired or having little energy?",
                      isMandatory: true,
                      answerChoices: const {
                        "Not at all": null,
                        "Several days": null,
                        "Nearly every day": null,
                      }),
                  Question(
                      question: "Poor appetite or overeating?",
                      isMandatory: true,
                      answerChoices: const {
                        "Not at all": null,
                        "Several days": null,
                        "Nearly every day": null,
                      }),
                  //        Question(
                  //       question: " Feeling nervous, anxious, or on edge?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //       "Yes": null,
                  //         "No": null,

                  //       }),
                  //        Question(
                  //       question: "Not being able to stop or control worrying?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //      "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "Worrying too much about different things?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //       "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "Trouble relaxing?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //      "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "Has there ever been a period of time when you were not your usual self?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //       "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "You felt so good or hyper that other people thought you were not your normal self or were so hyper that you got into trouble?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //      "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "You were so irritable that you shouted at people or started fights or arguments?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //       "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "You felt much more self-confident than usual?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //        "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "You got much less sleep than usual and found you didn’t really miss it?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  // "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "In the past month, have you....had nightmares about the event(s) or thought about the event(s) when you did not want to?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //      "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "tried hard not to think about the event(s) or went out of your way to avoid situations that reminded you of the event(s)?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //     "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "been constantly on guard, watchful, or easily startled?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //      "Yes": null,
                  //         "No": null,
                  //       }),
                  //        Question(
                  //       question: "felt guilty or unable to stop blaming yourself or others for the event(s) or any problems the event(s) may have caused?",
                  //       isMandatory: true,
                  //       answerChoices: const {
                  //       "Yes": null,
                  //         "No": null,
                  //       }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Card(
        color: Color(0xff87bfff),
        elevation: 10, // Adjust the elevation to control the amount of shadow
        shadowColor: Colors.black, // Specify the shadow color
        child: TextButton(
          style: TextButton.styleFrom(
            primary: Color(0xff87bfff),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              validate = 1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    // Pass the bottomNavigationBarExample to Validation
                    return Validation(widget.isDark, widget.updateState);
                  },
                ),
              );
            }
          },
          child: Text(
            "Validate",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
