import 'package:C1O2/helpers/helpers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/colors.dart';
import '../result/result_screen.dart';
import './user_input_questions.dart';

class UserInputs extends StatefulWidget {
  static const routeName = '/user-inputs';
  @override
  _UserInputsState createState() => _UserInputsState();
}

class _UserInputsState extends State<UserInputs> {
  List<double> answers = [];
  int index = 0;
  final _answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String? ?? '';

    // Get the question lists from provider
    final foodQ = Provider.of<Questions>(context).foodQuestions;
    final travelQ = Provider.of<Questions>(context).travelQuestions;
    final waterQ = Provider.of<Questions>(context).waterQuestions;
    final wasteQ = Provider.of<Questions>(context).wasteQuestions;

    // Initialize questions list based on `args`
    List<String> questions = [];
    if (args == 'food') {
      questions = foodQ;
    } else if (args == 'travel') {
      questions = travelQ;
    } else if (args == 'waste') {
      questions = wasteQ;
    } else {
      questions = waterQ;
    }

    void submitAnswer() {
      final answerText = _answerController.text;
      if (answerText.isEmpty || double.tryParse(answerText) == null) return;

      answers.add(double.parse(answerText));
      if (index == questions.length - 1) {
        double footprint;
        double averageEmission;
        String activityName;

        switch (args) {
          case 'food':
            footprint = CarbonFootPrint.getDailyFoodCarbonFootPrint(
                answers[0], answers[1], answers[2], answers[3]);
            averageEmission = CarbonFootPrint.avgEmissionDueToFoodPerDay;
            activityName = "Food";
            break;
          case 'travel':
            footprint = CarbonFootPrint.getDailyTravelFootPrint(
                answers[0], answers[1], answers[2]);
            averageEmission = CarbonFootPrint.avgEmissionDueToTravelPerDay;
            activityName = "Travel";
            break;
          case 'water':
            footprint = CarbonFootPrint.getDailyHouseHoldCarbonFootPrint(
                answers[0], answers[1], answers[2], answers[3]);
            averageEmission = CarbonFootPrint.avgEmissionDueToHouseHoldPerDay;
            activityName = "Household";
            break;
            case 'waste':
            footprint = CarbonFootPrint.getDailyWasteCarbonFootPrint(
                answers[0], answers[1], answers[2]);
            averageEmission = CarbonFootPrint.avgEmissionDueToWastePerDay;
            activityName = "Waste";
            break;
          default:
            return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              key: Key('result_screen_key'),
              userEmission: footprint,
              averageEmission: averageEmission,
              activityName: activityName,
            ),
          ),
        );
      } else {
        setState(() {
          index++;
          _answerController.clear();
        });
      }
    }

    Widget buildFlareAnimation(String path, String animation,
        {BoxFit fit = BoxFit.cover,
        Alignment alignment = Alignment.bottomCenter}) {
      return FlareActor(
        path,
        animation: animation,
        fit: fit,
        alignment: alignment,
        color: ColorPallete.background,
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(color: ColorPallete.background),
              if (args == 'food') ...[
                buildFlareAnimation('assets/flare/base_two_flow.flr', 'flow'),
                if (index == 0 || index == 1)
                  buildFlareAnimation('assets/flare/food_1.flr', 'flow',
                      fit: BoxFit.fitWidth),
                if (index == 2 || index == 3)
                  Positioned(
                    bottom: 30,
                    child: Image.asset('assets/images/eat_1.png'),
                  ),
              ],
              if (args == 'travel') ...[
                buildFlareAnimation('assets/flare/base_one.flr', 'Flow'),
                if (index == 0 || index == 2)
                  buildFlareAnimation('assets/flare/bicycle_flow.flr', 'flow'),
                if (index == 1)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset('assets/images/car.png',
                        height: MediaQuery.of(context).size.height * 0.3),
                  ),
              ],
              if (args == 'water') ...[
                buildFlareAnimation('assets/flare/base_water.flr', 'island01'),
                if (index == 0 || index == 1 || index == 2)
                  buildFlareAnimation('assets/flare/watch_tv.flr', 'flow'),
                if (index == 3)
                  buildFlareAnimation('assets/flare/water_flow.flr', 'flow',
                      alignment: Alignment.bottomRight, fit: BoxFit.fitWidth),
              ],
              if (args == 'waste') ...[
                buildFlareAnimation('assets/flare/base_two_flow.flr', 'flow'),
                if (index == 0 || index == 1)
                  buildFlareAnimation('assets/flare/food_1.flr', 'flow',
                      fit: BoxFit.fitWidth),
                if (index == 2 || index == 3)
                  Positioned(
                    bottom: 30,
                    child: Image.asset('assets/images/eat_1.png'),
                  ),
              ],
              Positioned(
                top: 150,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        questions[index],
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: ColorPallete.color3, fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        controller: _answerController,
                        decoration: InputDecoration(
                          hintText: args == 'travel'
                              ? '(In miles)'
                              : args == 'food'
                                  ? '(In Grams)'
                                  : args == 'waste'
                                      ? '(In Grams)'
                                      : '(In Hrs)',
                          hintStyle: TextStyle(color: ColorPallete.color4),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.trending_flat,
                                color: ColorPallete.color3),
                            onPressed: submitAnswer,
                          ),
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: ColorPallete.color3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
