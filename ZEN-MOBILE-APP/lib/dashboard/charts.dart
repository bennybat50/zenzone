import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mindcast/models/PublicVar.dart';

class LineChartView extends StatelessWidget {
  LineChartView(
      {required this.isShowingMainData,
      this.happyDays,
      this.sadDays,
      this.angryDays});
  final bool isShowingMainData;
  final happyDays, sadDays, angryDays;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData1,
      swapAnimationDuration: Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 1,
        maxX: 12,
        maxY: 30,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black);
    String text;
    switch (value.toInt()) {
      case 2:
        text = '2';
        break;
      case 4:
        text = '4';
        break;
      case 6:
        text = '6';
        break;
      case 8:
        text = '8';
        break;
      case 10:
        text = '10';
        break;
      case 12:
        text = '12';
        break;
      case 14:
        text = '14';
        break;
      case 16:
        text = '16';
        break;
      case 18:
        text = '18';
        break;
      case 20:
        text = '20';
        break;
      case 22:
        text = '22';
        break;
      case 24:
        text = '24';
        break;
      case 26:
        text = '26';
        break;
      case 28:
        text = '28';
        break;
      case 30:
        text = '30';
        break;
      default:
        return Container();
    }

    return Text(
      text,
      style: style,
      textAlign: TextAlign.center,
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 6,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 8, color: Colors.black);
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('JAN', style: style);
        break;
      case 2:
        text = const Text('FEB', style: style);
        break;
      case 3:
        text = const Text('MAR', style: style);
        break;
      case 4:
        text = const Text('APR', style: style);
        break;
      case 5:
        text = const Text('MAY', style: style);
        break;
      case 6:
        text = const Text('JUN', style: style);
        break;
      case 7:
        text = const Text('JUL', style: style);
        break;
      case 8:
        text = const Text('AUG', style: style);
        break;
      case 9:
        text = const Text('SEP', style: style);
        break;
      case 10:
        text = const Text('OCT', style: style);
        break;
      case 11:
        text = const Text('NOV', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 20,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 52,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: Color(PublicVar.angry),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
            show: true, color: Color(PublicVar.angry).withOpacity(0.5)),
        spots: List<FlSpot>.generate(angryDays.length, (index) {
          return FlSpot(
              index + 1, double.parse("${angryDays[index]["total"]}"));
        }).toList(),
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Color(PublicVar.sad),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
            show: true, color: Color(PublicVar.sad).withOpacity(0.5)),
        spots: List<FlSpot>.generate(sadDays.length, (index) {
          return FlSpot(index + 1, double.parse("${sadDays[index]["total"]}"));
        }).toList(),
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
      isCurved: true,
      color: Color(PublicVar.happy),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(
          show: true, color: Color(PublicVar.happy).withOpacity(0.5)),
      spots: List<FlSpot>.generate(happyDays.length, (index) {
        return FlSpot(index + 1, double.parse("${happyDays[index]["total"]}"));
      }).toList());
}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;
  List happyDays = [
    {"month": 1, "total": 2},
    {"month": 2, "total": 5},
    {"month": 3, "total": 2},
    {"month": 4, "total": 0},
    {"month": 5, "total": 23},
    {"month": 6, "total": 4},
    {"month": 7, "total": 17},
    {"month": 8, "total": 15},
    {"month": 9, "total": 22},
    {"month": 10, "total": 20},
    {"month": 11, "total": 17},
    {"month": 12, "total": 12}
  ];

  List sadDays = [
    {"month": 1, "total": 1},
    {"month": 2, "total": 9},
    {"month": 3, "total": 7},
    {"month": 4, "total": 5},
    {"month": 5, "total": 14},
    {"month": 6, "total": 4},
    {"month": 7, "total": 8},
    {"month": 8, "total": 9},
    {"month": 9, "total": 17},
    {"month": 10, "total": 7},
    {"month": 11, "total": 2},
    {"month": 12, "total": 4}
  ];

  List angryDays = [
    {"month": 1, "total": 3},
    {"month": 2, "total": 7},
    {"month": 3, "total": 9},
    {"month": 4, "total": 15},
    {"month": 5, "total": 4},
    {"month": 6, "total": 14},
    {"month": 7, "total": 18},
    {"month": 8, "total": 19},
    {"month": 9, "total": 27},
    {"month": 10, "total": 17},
    {"month": 11, "total": 12},
    {"month": 12, "total": 29}
  ];

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.02,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const SizedBox(
                                height: 27,
                              ),
                              const Text(
                                'Mood Tracker',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 27,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 6, left: 6),
                                  child: LineChartView(
                                    isShowingMainData: isShowingMainData,
                                    happyDays: happyDays,
                                    sadDays: sadDays,
                                    angryDays: angryDays,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: Colors.white
                                  .withOpacity(isShowingMainData ? 1.0 : 0.5),
                            ),
                            onPressed: () {
                              setState(() {
                                isShowingMainData = !isShowingMainData;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              GetCircle(Color(PublicVar.happy)),
                              Text(
                                "Happy",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GetCircle(Color(PublicVar.angry)),
                              Text(
                                "Anger",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GetCircle(Color(PublicVar.sad)),
                              Text(
                                "Sad",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget GetCircle(color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 20,
        height: 20,
        color: color,
      ),
    );
  }
}
