
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class Sample {
  final DateTime timestamp;
  final double value;
  Sample(this.timestamp, this.value);
}

class TimeSeriesData {
  final DateTime start;
  final DateTime end;
  final int interval;
  final Map<String, List<double?>> fields; // <-- store as map

  TimeSeriesData({
    required this.start,
    required this.end,
    required this.interval,
    required this.fields,
  });

  factory TimeSeriesData.fromJson(Map<String, dynamic> json) {
    final Map<String, List<double?>> map = {};
    for (var item in (json['data'] as List)) {
      map[item['field'] as String] =
          (item['values'] as List).map((v) => v == null ? null : (v as num).toDouble()).toList();
    }
    return TimeSeriesData(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      interval: int.parse(json['interval']),
      fields: map,
    );
  }

  /// Return timestamped samples for one field (skips nulls).
  List<Sample> samplesFor(String field) {
    final values = fields[field];
    if (values == null) return [];
    final step = Duration(seconds: interval);
    final List<Sample> out = [];
    for (int i = 0; i < values.length; i++) {
      final ts = start.add(step * i);
      final val = values[i];
      if (val != null) {
        out.add(Sample(ts, val));
      }
    }
    return out;
  }

  /// Convert directly into fl_chart spots (x = millis, y = value)
  List<FlSpot> spotsFor(String field) {
    final samples = samplesFor(field);
    return samples
        .map((s) => FlSpot(s.timestamp.millisecondsSinceEpoch.toDouble(), s.value))
        .toList();
  }
}
class Battery {
  final num cell;
  final num battery;
  final num statusCode;
  final num errorCode;
  final num voltage;
  final num soc;
  final num soh;
  final num internalResistance;
  final String timestamp;
  final num flag;

  const Battery({
    required this.cell,
    required this.battery,
    required this.statusCode,
    required this.errorCode,
    required this.voltage,
    required this.soc,
    required this.soh,
    required this.internalResistance,
    required this.timestamp,
    required this.flag,
  });
  static Battery fromJson(json) => Battery(
    timestamp: json['timestamp'],
    cell: json['cell'],
    battery: json['battery'],
    statusCode: json['status_code'],
    errorCode: json['error_code'],
    flag: json['flag'],
    internalResistance: json['internal_resistance'],
    soc: json['soc'],
    soh: json['soh'],
    voltage: json['voltage'],
  );
}



void main() => runApp(
  const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
      home: BatteryPage(

      )
    );
  }
}

class CellPage extends StatefulWidget {
  final String StartDate;
  final String EndDate;
  final int BatteryID;
  const CellPage({
    super.key,
    required this.StartDate,
    required this.EndDate,
    required this.BatteryID
  });

  @override
  State<CellPage> createState() => _CellPage();
}

class _CellPage extends State<CellPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: const Text("Cell List")),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 70),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              splashColor: Colors.blue.withAlpha(20),
              onTap:(){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppBarExample(
                      StartDate: widget.StartDate,
                      EndDate: widget.EndDate,
                      BatteryID: widget.BatteryID,
                      CellID: index+1,
                    )
                  )
                );
              },
              child: Text('Cell ${index+1}'),
              
            ),
                    
          );
        },
      ),
    );
  }
}


class BatteryPage extends StatefulWidget {
  @override
  State<BatteryPage> createState() => _BatteryPage();
}

class _BatteryPage extends State<BatteryPage>{

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();
  @override
  Widget build(BuildContext context){
    Future<void> selectStartDate() async{
      DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2100),
      );
      if (_picked !=null){
        setState(() {
          _dateController.text = _picked.toString().split(" ")[0];
        });
      }
    }
    Future<void> selectEndDate() async{
      DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2100),
      );
      if (_picked !=null){
        setState(() {
          _dateController2.text = _picked.toString().split(" ")[0];
        });
      }
    }
    return MaterialApp(
      title: "Battery List",
      home: Scaffold(
        appBar: AppBar(title: const Text("Battery List")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "Start Date",
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
                readOnly: true,
                onTap: () {
                selectStartDate();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _dateController2,
                decoration: const InputDecoration(
                  labelText: "End Date",
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                  ),
                ),
                readOnly: true,
                onTap: () {
                selectEndDate();
                },
              ),
            ),
            Flexible(
              child:GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisExtent: 70),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(20),
                      onTap:(){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CellPage(
                            StartDate: _dateController.text,
                            EndDate: _dateController2.text,
                            BatteryID: index+1,
                            )
                          )
                        );
                      },
                      child: Text('Battery ${index+1}'),
                    ),                    
                  );
                },
              )
            )
          ] 
        )
      ),
    );
  }
}

class AppBarExample extends StatefulWidget {
  final String StartDate;
  final String EndDate;
  final int BatteryID;
  final int CellID;

  const AppBarExample({
    super.key,
    required this.StartDate,
    required this.EndDate,
    required this.BatteryID,
    required this.CellID,
    });
  @override
  State<AppBarExample> createState() => _AppBarExampleState();
}

class _AppBarExampleState extends State<AppBarExample> {
  bool shadowColor = false;
  double? scrolledUnderElevation;
  get todos => null;
  late TransformationController _transformationController;
  bool _isPanEnabled = true;
  bool _isScaleEnabled = true;
  @override
  void initState() {
    _transformationController = TransformationController();
    super.initState();
  }
  String _graphs = 'soc';
  @override 
  Widget build(BuildContext context) {
    int interval = 1800;
    int numberOfDays = (DateTime.parse(widget.EndDate).difference(DateTime.parse(widget.StartDate)).inHours /24).round();
    if( numberOfDays <= 14 )
    {
      interval = 1800; //30min
    }
    else if( numberOfDays <= 28 )
    {
      interval = 3600; //1hour
    }
    else if( numberOfDays <=  90)
    {
      interval = 7200; //2hour
    }
    else if( numberOfDays <=  180)
    {
      interval = 14400; //4hour
    }
    else {interval = 43200;}
    Future <TimeSeriesData> getTimeSeries() async{
      final response = await http.get(Uri.parse('http://remote.cityu.chansheunglong.com:31401/api/timeseries?battery=${widget.BatteryID}&cell=${widget.CellID}&start=${widget.StartDate}T00:00:00Z&end=${widget.EndDate}T23:59:59Z&interval=$interval'));
      return TimeSeriesData.fromJson(jsonDecode(response.body));
    }
    Future<TimeSeriesData> timeSeries = getTimeSeries();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
      ),
      body: 
      FutureBuilder <TimeSeriesData>(
        future: timeSeries,
        builder: (context,snapshot){
          if (snapshot.hasData){
            final timeSeries = snapshot.data!;
            /*List<DateTime> dateTime = [for(int i=0;i<battery.length;i++)
              DateTime.parse(battery[i].timestamp)
            ];
            List<FlSpot> soh = [
              for (int i=0;i<battery.length;i++)
              FlSpot(dateTime[i].millisecondsSinceEpoch.toDouble(),battery[i].soh.toDouble())
            ];
            List<FlSpot> soh_warn = [FlSpot(dateTime.first.millisecondsSinceEpoch.toDouble(),30), FlSpot(dateTime.last.millisecondsSinceEpoch.toDouble(),30)
            ];
            List<FlSpot> resistance = [
              for (int i=0;i<battery.length;i++)
              FlSpot(dateTime[i].millisecondsSinceEpoch.toDouble(),battery[i].internalResistance.toDouble())
            ];            
            List<FlSpot> soc = [
              for (int i=0;i<battery.length;i++)
              FlSpot(dateTime[i].millisecondsSinceEpoch.toDouble(),battery[i].soc.toDouble())
            ];
            List<FlSpot> voltage = [
              for (int i=0;i<battery.length;i++)
              FlSpot(dateTime[i].millisecondsSinceEpoch.toDouble(),battery[i].voltage.toDouble())
            ];*/
            //List<List<FlSpot>> spots = [soc,soh,resistance,voltage];
            return Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return width >= 380
                    ? Row(
                        children: [
                          const SizedBox(width: 16),
                          Flexible(
                            child: RadioGroup<String>(
                            groupValue: _graphs,
                            onChanged: (value) {
                              setState(() {
                                if (value == null) return;
                                _graphs = value;
                              });
                            },
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text('soc'),
                                  leading: Radio(value: 'soc',),
                                  visualDensity: VisualDensity(vertical: -4),
                                  minVerticalPadding: 0,
                                  dense: true,
                                ),
                                ListTile(
                                  title: Text('soh'),
                                  leading: Radio(value: 'soh',),
                                  visualDensity: VisualDensity(vertical: -4),
                                  minVerticalPadding: 0,
                                  dense: true,
                                ),
                                ListTile(
                                  title: Text('ocv'),
                                  leading: Radio(value: 'ocv',),
                                  visualDensity: VisualDensity(vertical: -4),
                                  minVerticalPadding: 0,
                                  dense: true,
                                ),
                                ListTile(
                                  title: Text('r0'),
                                  leading: Radio(value: 'r0',),
                                  visualDensity: VisualDensity(vertical: -4),
                                  minVerticalPadding: 0,
                                  dense: true,
                                ),
                                ListTile(
                                  title: Text('vb'),
                                  leading: Radio(value: 'vb',),
                                  visualDensity: VisualDensity(vertical: -4),
                                  minVerticalPadding: 0,
                                  dense: true,
                                ),                                                                                                  
                                ],),
                              ),
                          ),  
                        const Spacer(),
                        Center(
                          child: _TransformationButtons(
                            controller: _transformationController,
                          ),
                        ),
                      ],
                    )
                    : Column(
                      children: [
                          RadioGroup<String>(
                            groupValue: _graphs,
                            onChanged: (value) {
                              setState(() {
                                if (value == null) return;
                                _graphs = value;
                              });
                            },
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                ListTile(
                                  title: Text('soc'),
                                  leading: Radio(value: 'soc',)
                                ),
                                ListTile(
                                  title: Text('soh'),
                                  leading: Radio(value: 'soh',)
                                ),
                                ListTile(
                                  title: Text('ocv'),
                                  leading: Radio(value: 'ocv',)
                                ),
                                ListTile(
                                  title: Text('r0'),
                                  leading: Radio(value: 'r0',)
                                ),
                                ListTile(
                                  title: Text('vb'),
                                  leading: Radio(value: 'vb',)
                                ),
                                                                                                                                           
                                ],),
                              ),
                        const SizedBox(height: 16),
                        _TransformationButtons(
                          controller: _transformationController,
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Pan'),
                      Switch(
                        value: _isPanEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isPanEnabled = value;
                          });
                        },
                      ),
                      const Text('Scale'),
                      Switch(
                        value: _isScaleEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isScaleEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1.4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                    top: 0.0,
                    right: 18.0,
                    ),
                    child: LineChart(
                      transformationConfig: FlTransformationConfig(
                      scaleAxis: FlScaleAxis.horizontal,
                      minScale: 1.0,
                      maxScale: 25.0,
                      panEnabled: _isPanEnabled,
                      scaleEnabled: _isScaleEnabled,
                      transformationController: _transformationController,
                      ),
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots:timeSeries.spotsFor(_graphs),
                            dotData: const FlDotData(show: false),
                            barWidth: 1,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: const LinearGradient(
                                colors: [Color.fromARGB(122, 122, 122, 122), Color.fromARGB(133, 122, 122, 122)]),
                            )
                          )
                        ],
                        /*minY: 0,
                        maxY: 100,*/
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              maxIncluded: false,
                              minIncluded: false,
                              showTitles: true,
                              /*getTitlesWidget: (value, meta){
                                final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                                final parts = timestamp.toIso8601String().split("T");
                                final label = parts.first.substring(5,10);
                                return Text(label);
                              },*/
                              getTitlesWidget: (value, meta){
                                final DateTime date =  DateTime.fromMillisecondsSinceEpoch(value.toInt());
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Transform.rotate(
                                    angle: -45*3.14/180,
                                    child: Text(
                                      '${date.month}/${date.day}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        ),
                                      ),
                                    ),
                                );
                              },
                              reservedSize: 40,
                            )
                          )
                        ),
                        lineTouchData: LineTouchData(
                          touchSpotThreshold: 5,
                          getTouchLineStart: (_, __) => -double.infinity,
                          getTouchLineEnd: (_, __) => double.infinity,
                          getTouchedSpotIndicator:
                          (LineChartBarData barData, List<int> spotIndexes) {
                            return spotIndexes.map((spotIndex) {
                              return TouchedSpotIndicatorData(
                                const FlLine(
                                  color:  Color.fromARGB(255, 200, 0, 0),
                                  strokeWidth: 1.5,
                                  dashArray: [8, 2],
                                ),
                                FlDotData(
                                  show: true,
                                  getDotPainter: (spot, percent, barData, index) {
                                    return FlDotCirclePainter(
                                      radius: 6,
                                      color: const Color.fromARGB(255, 255, 255, 0),
                                      strokeWidth: 0,
                                      strokeColor: const Color.fromARGB(255, 255, 255, 0),
                                    );
                                  },
                                ),
                              );
                            }).toList();
                          },
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                              return touchedBarSpots.map((barSpot) {
                                final price = barSpot.y;
                                final DateTime date = DateTime.fromMillisecondsSinceEpoch(barSpot.x.toInt());
                                //timeSeries.spotsFor("soc")[barSpot.x.toInt()].x;
                                return LineTooltipItem(
                                  '',
                                  const TextStyle(
                                    color: Color.fromARGB(0, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '$date',
                                      style: const TextStyle(
                                        color: Color.fromARGB(180, 0, 200, 0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\n${barSpot.y}',
                                      style: const TextStyle(
                                        color: Color.fromARGB(200, 0, 255, 255),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
                            getTooltipColor: (LineBarSpot barSpot) =>
                            Colors.black,
                          ),
                        ),
                      )
                    )  
                  ),
                )
              ]
            
            /*ListView(
              padding: const EdgeInsets.all(8),
              children: [
                const Text('SOC\n'),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots[0],
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                      minY: 0,
                      maxY: 100,
                    titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        maxIncluded: false,
                        minIncluded: false,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                          final parts = date.toIso8601String().split("T");
                          final label = parts.first.substring(5,10);
                          return Text(label);
                        },
                        reservedSize: 100,
                        interval:  (soc.last.x - soc.first.x)/(numberOfDays+1)*2,
                      )
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      )
                  
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        minIncluded: true,
                        maxIncluded: true,
                        reservedSize: 40,
                      )
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        minIncluded: true,
                        maxIncluded: true,
                        reservedSize: 40,
                      )
                    )                    
                    ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    getTooltipColor: (touchedSpot) => Colors.black,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ??
                              touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()).toIso8601String().substring(0,10)}\n${
                            DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()).toIso8601String().substring(11,19)}\n ${
                              touchedSpot.y.toStringAsFixed(2)}',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),                
              )   
                    )
                  ),
                  const Text('SOH'),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: spots[1], dotData: const FlDotData(show: false)),
                    LineChartBarData(
                      spots: soh_warn,
                      dotData: const FlDotData(show: false),
                      color: const Color.fromARGB(255, 255, 0, 0)
                      
                    )
                  ],
                  minY: 0,
                  maxY: 100,
                  
                  titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      maxIncluded: false,
                      minIncluded: false,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final parts = date.toIso8601String().split("T");
                        final label = parts.first.substring(5,10);
                        return Text(label);
                      },
                      reservedSize: 100,
                      interval: (soh.last.x-soh.first.x)/(numberOfDays+1)*2,    
                    )
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    )
                  
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      minIncluded: true,
                      maxIncluded: true,
                      reservedSize: 40,
                    )
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      minIncluded: true,
                      maxIncluded: true,
                      reservedSize: 40,
                    )
                  )                  
                  
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    getTooltipColor: (touchedSpot) => Colors.black,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ??
                              touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()).toIso8601String().substring(0,10)} \n ${DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()).toIso8601String().substring(11,19)}\n ${touchedSpot.y.toStringAsFixed(2)}',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),                
              )   
                  )
                  ),
                  const Text('Internal Resistance'),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: spots[2], dotData: const FlDotData(show: false))],
                  titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      maxIncluded: false,
                      minIncluded: false,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final parts = date.toIso8601String().split("T");
                        final label = parts.first.substring(5,10);
                        return Text(label);
                      },
                      reservedSize: 100,
                      interval: (resistance.last.x - resistance.first.x)/(numberOfDays+1)*2,    
                    )
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    )
                  
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      minIncluded: false,
                      maxIncluded: false,
                      reservedSize: 40,
                    )
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      minIncluded: false,
                      maxIncluded: false,
                      reservedSize: 40,
                    )
                  )                  
                  
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    getTooltipColor: (touchedSpot) => Colors.black,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ??
                              touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()).toIso8601String().substring(0,10)} \n ${DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()).toIso8601String().substring(11,19)}\n ${touchedSpot.y.toStringAsFixed(2)}mOhm',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),                
              )   
                  )
                  ),
                  const Text('Voltage'),
                  SizedBox(
                  height: 300,
                  width: 300,
                  child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: spots[3], dotData: const FlDotData(show: false))],
                  titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      maxIncluded: false,
                      minIncluded: false,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final parts = date.toIso8601String().split("T");
                        final label = parts.first.substring(5,10);
                        return Text(label);
                      },
                      reservedSize: 100,
                      interval: (voltage.last.x-voltage.first.x)/(numberOfDays+1)*2,    
                    )
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    )
                  
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      minIncluded: false,
                      maxIncluded: false,
                      reservedSize: 40,
                    )
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      minIncluded: false,
                      maxIncluded: false,
                      reservedSize: 40,
                    )
                  )                  
                  
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    getTooltipColor: (touchedSpot) => Colors.black,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ??
                              touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()).toIso8601String().substring(0,10)} \n ${DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt()).toIso8601String().substring(11,19)}\n ${touchedSpot.y.toStringAsFixed(2)}V',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),                
              )   
                  )
                  )                      
              ],
            );
          }
          else {
            return const Text ('Loading...');
          }
        }  
      ),*/
            );
          }
          else {return const Text ('Loading...');}
        }
      )
    );
  }
  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }
}

class DetailPage extends StatefulWidget{
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPage();
}
class _DetailPage extends State<DetailPage>{
  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery $index Detailed information'),
      ),
      body: GridView.builder(
        itemCount: 4,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index ) {
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 125,
                    child: Image.asset('jpeg/graph.png'),
                  )                
                ),
                Center(
                  child: Text(index == 0 ? 'SOC' : index == 1 ? 'SOH' : index == 2 ? 'Voltage' : 'Internal Resistance'),
                )
              ],
            )            
          );
        }
      )
      //body: const Image(
        //image: AssetImage('jpeg/graph.png'),
      //),
    );
  }
}
/*class updatedGraph extends StatefulWidget{
  final String StartDate;
  final String EndDate;
  final int BatteryID;
  final int CellID;

  const updatedGraph({
    super.key,
    required this.StartDate,
    required this.EndDate,
    required this.BatteryID,
    required this.CellID,
    });
  @override
  State<updatedGraph> createState() => _updatedGraph();
}
class _updatedGraph extends State<updatedGraph>{
  late TransformationController _transformationController;
  bool _isPanEnabled = true;
  bool _isScaleEnabled = true;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    int interval = 1800;
    Future <TimeSeriesData> getTimeSeries() async{
      final response = await http.get(Uri.parse('http://remote.cityu.chansheunglong.com:31401/api/timeseries?battery=${widget.BatteryID}&cell=${widget.CellID}&start=${widget.StartDate}T00:00:00Z&end=${widget.EndDate}T23:59:59Z&interval=$interval'));
      return TimeSeriesData.fromJson(jsonDecode(response.body));
    }
    Future<TimeSeriesData> TimeSeries = getTimeSeries();

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return width >= 380
                ? Row(
                    children: [
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 14),
                          /*OutlinedButton(child: Text('SOC')),
                          OutlinedButton(child: Text('SOH')),
                          OutlinedButton(child: Text('Internal Resistance')),
                          OutlinedButton(child: Text('Voltage')),*/
                          SizedBox(height: 14),
                        ],
                      ),
                      const Spacer(),
                      Center(
                        child: _TransformationButtons(
                          controller: TransformationController(),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 14),
                          /*OutlinedButton(child: Text('SOC')),
                          OutlinedButton(child: Text('SOH')),
                          OutlinedButton(child: Text('Internal Resistance')),
                          OutlinedButton(child: Text('Voltage')),*/
                          SizedBox(height: 14),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _TransformationButtons(
                        controller: TransformationController(),
                      ),
                    ],
                  );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Pan'),
              Switch(
                value: _isPanEnabled,
                onChanged: (value) {
                  setState(() {
                    _isPanEnabled = value;
                  });
                },
              ),
              const Text('Scale'),
              Switch(
                value: _isScaleEnabled,
                onChanged: (value) {
                  setState(() {
                    _isScaleEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 1.4,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 0.0,
              right: 18.0,
            ),
            child: LineChart(
                transformationConfig: FlTransformationConfig(
                  scaleAxis: FlScaleAxis.horizontal,
                  minScale: 1.0,
                  maxScale: 25.0,
                  panEnabled: _isPanEnabled,
                  scaleEnabled: _isScaleEnabled,
                  transformationController: _transformationController,
                ),
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots
                    )
                  ]
                )
  }
}*/
class _TransformationButtons extends StatelessWidget {
  const _TransformationButtons({
    required this.controller,
  });

  final TransformationController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Tooltip(
          message: 'Zoom in',
          child: IconButton(
            icon: const Icon(
              Icons.add,
              size: 16,
            ),
            onPressed: _transformationZoomIn,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: 'Move left',
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                ),
                onPressed: _transformationMoveLeft,
              ),
            ),
            Tooltip(
              message: 'Reset zoom',
              child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  size: 16,
                ),
                onPressed: _transformationReset,
              ),
            ),
            Tooltip(
              message: 'Move right',
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
                onPressed: _transformationMoveRight,
              ),
            ),
          ],
        ),
        Tooltip(
          message: 'Zoom out',
          child: IconButton(
            icon: const Icon(
              Icons.minimize,
              size: 16,
            ),
            onPressed: _transformationZoomOut,
          ),
        ),
      ],
    );
  }

  void _transformationReset() {
    controller.value = Matrix4.identity();
  }

  void _transformationZoomIn() {
    controller.value *= Matrix4.diagonal3Values(
      1.1,
      1.1,
      1,
    );
  }

  void _transformationMoveLeft() {
    controller.value *= Matrix4.translationValues(
      20,
      0,
      0,
    );
  }

  void _transformationMoveRight() {
    controller.value *= Matrix4.translationValues(
      -20,
      0,
      0,
    );
  }

  void _transformationZoomOut() {
    controller.value *= Matrix4.diagonal3Values(
      0.9,
      0.9,
      1,
    );
  }
}