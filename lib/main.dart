
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

/// Flutter code sample for [AppBar].
class Todo {
  final int numbers;
  const Todo (this.numbers);
}
class BatteryTodo{
  final String startDate;
  final String EndDate;
  final int BatteryID;
  const BatteryTodo(this.startDate,this.EndDate, this.BatteryID);
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
        itemCount: 30,
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
  const BatteryPage({super.key});

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
  @override
  void initState() {
    super.initState();
  }

/*  Widget buildBatteries(List<Battery> batteries) => GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 2.0,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
    ),
    itemCount: batteries.length,
    itemBuilder: (context, index){
      final battery = batteries[index];
      return Card(
        child: ListTile(
          title: Text('Battery${battery.battery}'),
          subtitle: Text('Voltage: ${battery.voltage} Resistance: ${battery.internalResistance}\n Soc: ${battery.soc} Soh: ${battery.soh}'),
        ),
      );
    }
  );*/
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

    Future<List<Battery>> getBatteries() async{
      final response = await http.get(Uri.parse('http://api.chansheunglong.com:31311/api/data?battery=6&cell=${widget.CellID}&start=${widget.StartDate}T00:00:00Z&end=${widget.EndDate}T23:59:59Z&interval=$interval'));
      return json.decode(response.body).map<Battery>(Battery.fromJson).toList();
    }

    Future<List<Battery>> batteries = getBatteries();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
      ),
      body: 
      FutureBuilder <List<Battery>>(
        future: batteries,
        builder: (context,snapshot){
          if (snapshot.hasData){
            final battery = snapshot.data!;
            List<DateTime> dateTime = [for(int i=0;i<battery.length;i++)
              DateTime.parse(battery[i].timestamp)
            ];
            List<FlSpot> soh = [
              for (int i=0;i<battery.length;i++)
              FlSpot(dateTime[i].millisecondsSinceEpoch.toDouble(),battery[i].soh.toDouble())
            ];
            List<FlSpot> soh_warn = [
              for (int i=0;i<battery.length;i++)
              FlSpot(dateTime[i].millisecondsSinceEpoch.toDouble(),30)
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
            ];          
            List<List<FlSpot>> spots = [soc,soh,resistance,voltage];
            return ListView(
              padding: const EdgeInsets.all(8),
              children: [
                const Text('SOC\n'),
                SizedBox(
                  height: 600,
                  width: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots[0],
                          dotData: FlDotData(show: false),
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
                  const Text('SOH'),
                SizedBox(
                  height: 600,
                  width: 300,
                  child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: spots[1], dotData: FlDotData(show: false)),
                    LineChartBarData(
                      spots: soh_warn,
                      dotData: FlDotData(show: false),
                      color: Color.fromARGB(255, 255, 0, 0)
                      
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
                  height: 600,
                  width: 300,
                  child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: spots[2], dotData: FlDotData(show: false))],
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
                  height: 600,
                  width: 300,
                  child: LineChart(LineChartData(lineBarsData: [LineChartBarData(spots: spots[3], dotData: FlDotData(show: false))],
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
            
            /* return LineChart( 
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots[0]                      
                  ) 
                ],
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      maxIncluded: false,
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final parts = date.toIso8601String().split("T");
                        final label = parts.last.substring(0,5);
                        return Text(label);
                      },
                      reservedSize: 100,    
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
            ); */   
          }
          else {
            return const Text ('Loading...');
          }
        }  
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            alignment: MainAxisAlignment.center,
            overflowSpacing: 5.0,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    shadowColor = !shadowColor;
                  });
                },
                icon: Icon(
                  shadowColor ? Icons.visibility_off : Icons.visibility,
                ),
                label: const Text('shadow color'),
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  if (scrolledUnderElevation == null) {
                    setState(() {
                      // Default elevation is 3.0, increment by 1.0.
                      scrolledUnderElevation = 4.0;
                    });
                  } else {
                    setState(() {
                      scrolledUnderElevation = scrolledUnderElevation! + 1.0;
                    });
                  }
                },
                child: Text(
                  'scrolledUnderElevation: ${scrolledUnderElevation ?? 'default'}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
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