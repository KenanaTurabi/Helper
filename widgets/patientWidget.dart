// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';
import 'package:flutter_application_1/widgets/patientFullDataWiddget.dart';
import '../models/patientModel.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientWidget extends StatefulWidget {
  bool isDark;
  Function updateState;
  Patient patient;
  PatientWidget(this.patient, this.isDark, this.updateState);

  @override
  State<PatientWidget> createState() => _PatientWidgetState();
}

class _PatientWidgetState extends State<PatientWidget> {
  @override
  Widget build(BuildContext context) {
    print('from patient widget isDark=' + widget.isDark.toString());
    // TODO: implement build
     return  GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return patientFullDataWiddget(
              widget.patient, widget.isDark, widget.updateState);
        }));
      },
      child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:AssetImage('assets/images/${widget.patient.image}'),
                      radius: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                       widget.patient.name!,
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                      
                    ),
                  ],
                ),
             
              
            
              ],
            ),
          )),
      
    );
  }
}
