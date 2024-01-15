import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/RoomDetailPage.dart';

class RoomsList extends StatefulWidget {
  String? name;
  String? doctorname;

  RoomsList({
    this.name,
    this.doctorname,
  });

  @override
  _RoomsListState createState() => _RoomsListState();
}

class _RoomsListState extends State<RoomsList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RoomDetailPage(
            name: widget.name,
            doctorname: widget.doctorname,
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.only(left: 4, right: 10, top: 12, bottom: 4),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10.0), // Set your desired radius
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], // Set your desired color
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(left: 15, top: 6, bottom: 6),
                              height: 35,
                              width: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    4.0), // Set your desired radius
                                color: Color(0xff0E4C92),
                              ),
                              child: Text(
                                widget.name ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Created by  ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              'Dr. ' +
                                  (widget.doctorname ??
                                      ' '), // Use parentheses to ensure proper concatenation
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontWeight: widget.doctorname == true
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
