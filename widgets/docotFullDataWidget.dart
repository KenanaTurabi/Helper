import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/widgets/CustomAppBar.dart';
import '../models/doctorModel.dart';

class doctorFullDataWiddget extends StatefulWidget {
  Doctor doctor;
  bool isDark;
  Function updateState;
  doctorFullDataWiddget(this.doctor, this.isDark, this.updateState);

  @override
  State<doctorFullDataWiddget> createState() => _doctorFullDataWiddgetState();
}

class _doctorFullDataWiddgetState extends State<doctorFullDataWiddget> {
  void updateState(bool newValue) {
    setState(() {
      widget.isDark = newValue;
      print(widget.isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('from doctorFullData isDark =' + widget.isDark.toString());
    CustomeAppBar customeAppBar = new CustomeAppBar(widget.isDark, updateState);
    // TODO: implement build

    return Theme(
      data: widget.isDark ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: customeAppBar,
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(30),
            color: Colors.blue.withOpacity(0.3),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 400,
                  child: Image(image: AssetImage('assets/images/${widget.doctor.image}'),
),
                ),
                Row(
                  children: [
                    Text("Name: "),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.doctor.name ?? "No Name")
                  ],
                ),
                Row(
                  children: [
                    Text("Id: "),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.doctor.id.toString()!)
                  ],
                ),
                Row(
                  children: [
                    Text("Mobile Number: "),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.doctor.mobileNumber.toString()!)
                  ],
                ),
                Row(
                  children: [
                    Text("Country: "),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.doctor.city!)
                  ],
                ),
                Row(
                  children: [
                    Text("Specilization: "),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.doctor.specialization!)
                  ],
                ),
                Row(
                  children: [
                    Text("Experience: "),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.doctor.experience.toString()!)
                  ],
                ),
                Row(
                  children: [
                    Text("Current working place: "),
                    SizedBox(
                      width: 10,
                    ),
                    Text(widget.doctor.CurrentWorkPlace!)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
