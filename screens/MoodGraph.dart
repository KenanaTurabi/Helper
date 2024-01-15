import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/shared_preferences_helper.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodDiagramPage extends StatefulWidget {
  @override
  _MoodDiagramPageState createState() => _MoodDiagramPageState();
}

class _MoodDiagramPageState extends State<MoodDiagramPage> {
  List<EmojiData> emojiData = [];
  Map<String, String> emojiToWord = {
    '😂': 'Awesome',
    '😊': 'Happy',
    '😇': 'Good',
    '🥺': 'Pleading',
    '😢': 'Sad',
    '😡': 'Angry',
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final int? userId = await getUserId();
    final url = 'http://localhost:5000/emojiPercentages/$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        List<EmojiData> tempEmojiData = [];

        data.forEach((emoji, percentage) {
          double fontSize = 12.0;
          var emojiData = EmojiData(emoji, double.parse(percentage), fontSize: fontSize);
          tempEmojiData.add(emojiData);
        });

        setState(() {
          emojiData = tempEmojiData;
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during fetch data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            // backgroundColor:  Color.fromARGB(255, 213, 231, 251),
            backgroundColor:  Colors.white,

      appBar: AppBar(

            backgroundColor:  Colors.white,

      title: Text('Mood Chart'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 50,
            ),
          ),
        
          Container(
            height: 550,
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              
             child:Column(
              children:[

  Text(
              'Your mood this month',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
 
                padding: EdgeInsets.only(top: 60),
                height: 400,
                width: 400,
                child: charts.BarChart(
                  
                  _createData(),
                  animate: true,
                  barGroupingType: charts.BarGroupingType.grouped,
                  vertical: true,
                 primaryMeasureAxis: charts.NumericAxisSpec(
  renderSpec: charts.GridlineRendererSpec(
    labelAnchor: charts.TickLabelAnchor.before,
    labelJustification: charts.TickLabelJustification.inside,
  ),
  tickProviderSpec: charts.BasicNumericTickProviderSpec(
    desiredTickCount: 5,
    // Set the desired range for the y-axis (from 0 to 100)
    desiredMaxTickCount: 5,
    desiredMinTickCount: 0,
  ),
  showAxisLine: true,
  tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
    (num? value) {
      if (value != null) {
        return '${value.toStringAsFixed(0)}%';
      }
      return '';
    },
  ),
),

                  domainAxis: charts.OrdinalAxisSpec(
 renderSpec: charts.SmallTickRendererSpec(
  labelAnchor: charts.TickLabelAnchor.centered,
  labelJustification: charts.TickLabelJustification.inside,
  labelRotation: 0, // Set rotation to 0
  labelOffsetFromAxisPx: 20, // Adjust the offset to move the labels away from the axis
  lineStyle: charts.LineStyleSpec(
    color: charts.MaterialPalette.black,
  ),
),


                    tickProviderSpec: charts.StaticOrdinalTickProviderSpec(
                      <charts.TickSpec<String>>[
                        for (var emoji in emojiData.map((data) => data.emoji))
                          charts.TickSpec<String>(emoji, label: '   ${emojiToWord[emoji] ?? ''}'),
                      ],
                    ),
                  ),
                  defaultRenderer: charts.BarRendererConfig(
                    cornerStrategy: const charts.ConstCornerStrategy(30),
                  ),
                ),
              ),

              ]
             )
              
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<EmojiData, String>> _createData() {
    List<Color> barColors = [Color(0xff87bfff), Color.fromARGB(255, 106, 174, 251), Color.fromARGB(255, 182, 215, 253)];

    return [
      charts.Series<EmojiData, String>(
        id: 'Emojis',
        domainFn: (EmojiData data, _) => data.emoji,
        measureFn: (EmojiData data, _) => data.percentage,
        data: emojiData,
        colorFn: (EmojiData data, _) => charts.ColorUtil.fromDartColor(barColors[emojiData.indexOf(data) % barColors.length]),
        labelAccessorFn: (EmojiData data, _) => data.label, // Use the custom label
      ),
    ];
  }
}

class EmojiData {
  final String emoji;
  final double percentage;
  final String label; // Custom label
  final double fontSize;

  EmojiData(this.emoji, this.percentage, {this.fontSize = 50.0}) : label = '$emoji\n${percentage.toStringAsFixed(0)}%';
}
