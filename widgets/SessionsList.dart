import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; 

class SessionsList extends StatefulWidget {
  String? doctorname;
  String? doctorimage;
  String? subject;
  String? time;
  final DateTime? Session_Date;

  SessionsList({
    this.doctorname,
    this.doctorimage,
    this.subject,
    this.time,
    required this.Session_Date,
  });

  @override
  _SessionsListState createState() => _SessionsListState();
}

class _SessionsListState extends State<SessionsList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap event if needed
      },

            child: Container(
                      height:140,

        padding: EdgeInsets.only(left: 6, right: 6, top:8, bottom: 8),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(12), // Adjust padding as needed
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: widget.doctorimage != null
                    ? AssetImage('assets/images/'+widget.doctorimage!)
                    : AssetImage('assets/images/undraw_completed_tasks_vs6q.png'),
                maxRadius: 30,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.subject ?? '',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 6,),
                    Text(
                      'Dr. ' + (widget.doctorname ?? ''),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'On ' +
                          (widget.Session_Date != null
                              ? DateFormat('yyyy-MM-dd').format(widget.Session_Date!)
                              : ''),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: widget.Session_Date != null
                            ? FontWeight.normal
                            : FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      widget.time ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: widget.time != null
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Container(

      child:  ElevatedButton(
               
      onPressed: (){
                     },
   style: ElevatedButton.styleFrom(
    primary: Color((0xff87bfff)),
       elevation: 0,
),
        child: Text(
          'Join Us',  style: GoogleFonts.poppins(

          textStyle: TextStyle(
            fontSize: 12,
           fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        ),),
        ),
      ),
            ],
          ),
        ),
      ),
            ),
    );
  }
}
