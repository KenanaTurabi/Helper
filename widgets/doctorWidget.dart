// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';
import 'package:flutter_application_1/widgets/docotFullDataWidget.dart';
import '../models/doctorModel.dart';

class DoctorWidget extends StatefulWidget {
  bool isDark;
  Function updateState;
  Doctor doctor;
  DoctorWidget(this.doctor, this.isDark, this.updateState);

  @override
  State<DoctorWidget> createState() => _DoctorWidgetState();
}

class _DoctorWidgetState extends State<DoctorWidget> {
  @override
  Widget build(BuildContext context) {
    print('from doctor widget isDark=' + widget.isDark.toString());
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return doctorFullDataWiddget(
              widget.doctor, widget.isDark, widget.updateState);
        }));
      },
      child: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blue.withOpacity(0.3)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:AssetImage('assets/images/${widget.doctor.image}'),
                      radius: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Name: " + widget.doctor.name!,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Current working place: ' +
                          widget.doctor.CurrentWorkPlace!,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Specialization: ' + widget.doctor.specialization!,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400)),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Experience: ${widget.doctor.experience?.toString() ?? 'N/A'} years',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
