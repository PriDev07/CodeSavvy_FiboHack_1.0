import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:C1O2/helpers/colors.dart';
import 'package:C1O2/helpers/text_theme.dart';
import 'package:C1O2/screens/reduce/reduce_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fl_chart/fl_chart.dart';  // Import the chart package

class ResultScreen extends StatelessWidget {
  final double userEmission;
  final double averageEmission;
  final String activityName;

  static final routeName = "/result";
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  ResultScreen({
    required Key key,
    required this.activityName,
    required this.userEmission,
    required this.averageEmission,
  }) : super(key: key);

  double roundOff(double value) => double.parse(value.toStringAsFixed(2));

  double getChangePercentage() {
    return roundOff(
        ((userEmission - averageEmission).abs() / averageEmission) * 100);
  }

  List<Widget> getDataGrids(String changePrefix, double changePercent) {
    List<Map<String, dynamic>> emissionDatas = [
      {
        'text': 'Your carbon footprint for $activityName activities',
        'figure': '${roundOff(userEmission)} tonnes CO2',
        'icon': Icons.person_outline,
      },
      {
        'text': 'Average carbon footprint for $activityName',
        'figure': '${roundOff(averageEmission)} tonnes CO2',
        'icon': Icons.nature_people,
      },
      {
        'text': 'You are emitting $changePrefix emission than average',
        'figure': '$changePercent %',
        'icon': Icons.track_changes,
      },
    ];

    return emissionDatas
        .map((emissionData) => Container(
              child: Card(
                elevation: 2,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: ColorPallete.cardBackground,
                child: ListTile(
                  title: CoolText(
                    emissionData['figure'].toString(),
                    fontSize: 18,
                    letterSpacing: 1.1,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      emissionData['text'].toString(),
                      style: TextStyle(
                        color: ColorPallete.color7,
                        fontSize: 13,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  trailing: Icon(
                    emissionData['icon'] as IconData,
                    color: ColorPallete.color3,
                  ),
                ),
              ),
            ))
        .toList();
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = (await getTemporaryDirectory()).path;
      final imgFile = File('$directory/result.png');
      await imgFile.writeAsBytes(pngBytes);

      String message = userEmission < averageEmission
          ? "Great job! 🌍 Your carbon footprint is ${getChangePercentage()}% less than the average for $activityName activities."
          : "Keep pushing! Your carbon footprint is ${getChangePercentage()}% higher than the average for $activityName activities. Let's reduce emissions together!";

      await Share.shareXFiles([XFile(imgFile.path)], text: message);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double changePercent = getChangePercentage();
    bool isHigherEmission = userEmission > averageEmission;
    String changeSuffix = isHigherEmission ? "more" : "less";

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPallete.cardBackground,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            color: ColorPallete.color7,
          ),
          title: Text(
            "$activityName carbon footprint",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: ColorPallete.color7,
            ),
          ),
        ),
        backgroundColor: ColorPallete.background,
        body: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              RepaintBoundary(
                key: _repaintBoundaryKey,
                child: Container(
                  color: ColorPallete.cardBackground,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CoolText(
                          "${roundOff(userEmission)} tonnes CO2",
                          fontSize: 22,
                          letterSpacing: 1.1,
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Your daily carbon footprint is $changePercent% $changeSuffix than an average person",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorPallete.color7,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Pie chart showing emission comparison
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.blue,
                        value: roundOff(userEmission),
                        title: 'Your Emission',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: roundOff(averageEmission),
                        title: 'Average Emission',
                        radius: 50,
                        titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Existing data grids
              ...getDataGrids(changeSuffix, changePercent),
              
              SizedBox(height: 10),
              Divider(
                thickness: 0.7,
                color: ColorPallete.color6,
              ),
              SizedBox(height: 10),
              
              // Reduce Emission Card
              Card(
                color: ColorPallete.cardBackground,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () => Navigator.pushNamed(
                      context, ReduceEmissionScreen.routeName),
                  title: CoolText(
                    "Reduce carbon emissions",
                    fontSize: 18,
                    letterSpacing: 1.1,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Our earth needs it. Let's move together in this.",
                      style: TextStyle(
                        color: ColorPallete.color7,
                        fontSize: 13,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  trailing: Icon(
                    Icons.nature,
                    color: ColorPallete.color3,
                  ),
                ),
              ),
              Card(
                color: ColorPallete.cardBackground,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: _captureAndSharePng,
                  title: CoolText(
                    "Share your result",
                    fontSize: 18,
                    letterSpacing: 1.1,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      "Let others know your carbon footprint and inspire change!",
                      style: TextStyle(
                        color: ColorPallete.color7,
                        fontSize: 13,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                  trailing: Icon(
                    Icons.share,
                    color: ColorPallete.color3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
