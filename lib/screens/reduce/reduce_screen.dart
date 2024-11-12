import 'package:C1O2/helpers/colors.dart';
import 'package:C1O2/helpers/text_theme.dart';
import 'package:C1O2/screens/home/startScreen.dart';
import 'package:flutter/material.dart';

class ReduceEmissionScreen extends StatelessWidget {
  static final routeName = "/reduce-carbon-footprint";

  List<Widget> getWidgetTree() {
    List<Map<String, dynamic>> reduceCarbonFootPrintmsgs = [
      {
        'icon': Icons.hot_tub,
        'title': 'Reduce emissions due to household activities',
        'options': [
          {
            'icon': Icons.do_not_disturb_alt,
            'message': 'Do not forget to switch off the lights or unplug your electronic devices when they are not in use',
          },
          {
            'icon': Icons.done_outline,
            'message': 'Lower the amount of energy used to pump, treat, and heat water by washing your car less often, using climate-appropriate plants in the garden',
          },
          {
            'icon': Icons.do_not_disturb_alt,
            'message': 'Don\'t set the thermostat too high or low. Install a programmable model to turn off the heat or air conditioning when you\'re not at home',
          },
        ]
      },
      {
        'icon': Icons.card_travel,
        'title': 'Reduce emissions due to your commutes',
        'options': [
          {
            'icon': Icons.do_not_disturb_alt,
            'message': 'Avoid unnecessary acceleration, which increases mileage by up to 33%, wastes gas, money, and increases carbon emissions',
          },
          {
            'icon': Icons.done_outline,
            'message': 'Whenever possible, walk or ride your bike to avoid carbon emissions completely',
          },
          {
            'icon': Icons.do_not_disturb_alt,
            'message': 'Only buy a minivan or SUV if you truly need 4WD or occasional extra space',
          },
        ]
      },
      {
        'icon': Icons.fastfood,
        'title': 'Reduce emissions due to food activities',
        'options': [
          {
            'icon': Icons.do_not_disturb_alt,
            'message': 'Stop wasting food!',
          },
          {
            'icon': Icons.done_outline,
            'message': 'Eat lower on the food chain',
          },
          {
            'icon': Icons.do_not_disturb_alt,
            'message': 'Avoid consuming excess calories!',
          },
        ]
      },
    ];

    List<Widget> parentWidgetTree = [];

    // Iterate over the list with explicit types
    for (var reduceEmissionData in reduceCarbonFootPrintmsgs) {
      List<Widget> widgetTree = [];

      widgetTree.add(SizedBox(height: 15));

      Widget cardHeader = ListTile(
        leading: Icon(
          reduceEmissionData['icon'] as IconData, // Casting to IconData
          color: ColorPallete.color3,
        ),
        title: CoolText(
          reduceEmissionData['title'].toString(), // Converting to String
          fontSize: 17, letterSpacing: 0,
        ),
      );

      widgetTree.add(cardHeader);

      List<Widget> sectionDivider = [
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 1,
            color: ColorPallete.color6,
          ),
        ),
        SizedBox(height: 5),
      ];

      widgetTree = [...widgetTree, ...sectionDivider];

      // Iterate over the options, ensuring types are properly defined
      for (var option in reduceEmissionData['options'] as List<Map<String, dynamic>>) {
        Widget optionWidget = ListTile(
          leading: Icon(
            option['icon'] as IconData, // Casting to IconData
            color: ColorPallete.color3,
          ),
          title: Text(
            option['message'].toString(), // Converting to String
            style: TextStyle(
              color: ColorPallete.color3,
            ),
          ),
        );

        widgetTree.add(optionWidget);
      }

      widgetTree.add(SizedBox(height: 10));

      Widget parentWidget = Container(
        padding: EdgeInsets.all(8),
        width: double.infinity,
        child: Card(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: ColorPallete.cardBackground,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgetTree,
            ),
          ),
        ),
      );

      parentWidgetTree.add(parentWidget);
    }

    return parentWidgetTree;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallete.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
            ...getWidgetTree(),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: ColorPallete.cardBackground.withBlue(150),
        onPressed: () {
          Navigator.pushNamed(context, StartScreen.routeName);
        },
        label: Text(
          "Home",
          style: TextStyle(
            color: ColorPallete.color3,
          ),
        ),
        icon: Icon(
          Icons.home,
          color: ColorPallete.color3,
        ),
      ),
    );
  }
}
