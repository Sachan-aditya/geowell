import 'package:flutter/material.dart';
import 'package:geowell/screens/home.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(cMyApp());
}

class cMyApp extends StatelessWidget {
  const cMyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GeoWell',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double value1 = 0.0;
  double value2 = 0.0;
  double barValue = 0.0;
  bool waterWellConstruct = false;
  String drillingTechnique = '';
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    try {
      // Replace this with your actual API endpoint and data
      final response = await http.post(
        Uri.parse("https://047pegasus.pythonanywhere.com/predict"),
        body: jsonEncode({
          "latitude": 40,
          "longitude": -71.7,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          value1 = jsonData['expectedDischarge'] / 100;
          value2 = jsonData['qualityIndex'] * 100;
          barValue = jsonData['minDepthEncounter'];
          waterWellConstruct = jsonData['WaterWellConstruct'];
          drillingTechnique = jsonData['drillTech'];
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to fetch data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Data Representation',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.transparent,
        elevation: 3,
        leading: IconButton(
          icon: const  Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=> const HomeyApp())); // This will navigate back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Expected Discharge',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Quality Index',
                    style: TextStyle(
                      fontSize: 10.0,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildDoughnutChart(
                      'Discharge',
                      value1,
                      Colors.lightBlueAccent,
                      const Color.fromARGB(255, 3, 25, 43)),
                  buildDoughnutChart('Quality Index', value2, Colors.red,
                      const Color.fromARGB(255, 41, 11, 1)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLegendItem('Discharge', Colors.lightBlueAccent),
                  _buildLegendItem('Quality Index', Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Depth Encounter',
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                color: Colors.black,
                height: 300,
                width: 300,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <ChartSeries<Data, String>>[
                    ColumnSeries<Data, String>(
                      dataSource: <Data>[
                        Data('DEPTH', barValue),
                      ],
                      xValueMapper: (Data data, _) => data.category,
                      yValueMapper: (Data data, _) => data.value,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Waterwell Construct ',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                waterWellConstruct ? 'Yes' : 'No',
                style: TextStyle(
                  fontSize: 16.0,
                  color: waterWellConstruct ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Drilling Technique ',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                drillingTechnique,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDoughnutChart(
      String label, double chartValue, Color segmentColor, Color restColor) {
    return Container(
      width: 150,
      height: 150,
      child: SfCircularChart(
        series: <CircularSeries>[
          DoughnutSeries<Data, String>(
            dataSource: <Data>[
              Data(label, chartValue),
              Data('Rest', 100.0 - chartValue),
            ],
            xValueMapper: (Data data, _) => data.category,
            yValueMapper: (Data data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              color: Colors.white,
              labelPosition: ChartDataLabelPosition.outside,
            ),
            pointColorMapper: (Data data, _) =>
                data.category == label ? segmentColor : restColor,
          ),
        ],
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(
            widget: Text(
              '${chartValue.toInt()}%',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}

class Data {
  final String category;
  final double value;

  Data(this.category, this.value);
}
