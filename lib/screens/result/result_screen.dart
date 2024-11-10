import 'package:C1O2/helpers/colors.dart';
import 'package:C1O2/helpers/text_theme.dart';
import 'package:C1O2/screens/reduce/reduce_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class ResultScreen extends StatelessWidget {
  final double userEmission;
  final double averageEmission;
  final String activityName;

  static final routeName = "/result";

  ResultScreen({
    required Key key,
    required this.activityName,
    required this.userEmission,
    required this.averageEmission,
  }) : super(key: key);

  double roundOff(double value) => double.parse(value.toStringAsFixed(2));

  double getChangePercentage() {
    return roundOff(((userEmission - averageEmission).abs() / averageEmission) * 100);
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


    return emissionDatas.map((emissionData) => Container(
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
    )).toList();
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
              Container(
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
                        "Your carbon footprint is $changePercent% $changeSuffix than an average person",
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
              Card(
                elevation: 2,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: ColorPallete.cardBackground,
                child: FlutterSlider(
                  step: FlutterSliderStep(step: 0.01),
                  values: isHigherEmission
                      ? [roundOff(averageEmission), roundOff(userEmission)]
                      : [roundOff(userEmission), roundOff(averageEmission)],
                  rangeSlider: true,
                  disabled: true,
                  min: 0,
                  max: (isHigherEmission ? userEmission : averageEmission) * 1.1,
                  trackBar: FlutterSliderTrackBar(
                    activeDisabledTrackBarColor: isHigherEmission ? Colors.red : Colors.greenAccent,
                    inactiveDisabledTrackBarColor: ColorPallete.color6,
                  ),
                  handler: FlutterSliderHandler(
                    child: Icon(Icons.person, color: ColorPallete.color3),
                  ),
                  rightHandler: FlutterSliderHandler(
                    child: Icon(Icons.nature_people, color: ColorPallete.color4),
                  ),
                  tooltip: FlutterSliderTooltip(
                    positionOffset: FlutterSliderTooltipPositionOffset(top: -5),
                    boxStyle: FlutterSliderTooltipBox(
                      decoration: BoxDecoration(
                        color: ColorPallete.cardBackground,
                      ),
                    ),
                    alwaysShowTooltip: true,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    leftSuffix: Text(
                      " tonnes CO2",
                      style: TextStyle(fontSize: 12, color: ColorPallete.color3),
                    ),
                    rightSuffix: Text(
                      " tonnes CO2",
                      style: TextStyle(fontSize: 12, color: ColorPallete.color3),
                    ),
                  ),
                ),
              ),
              ...getDataGrids(changeSuffix, changePercent),
              SizedBox(height: 10),
              Divider(
                thickness: 0.7,
                color: ColorPallete.color6,
              ),
              SizedBox(height: 10),
              Card(
                color: ColorPallete.cardBackground,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () => Navigator.pushNamed(context, ReduceEmissionScreen.routeName),
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
            ],
          ),
        ),
      ),
    );
  }
}
