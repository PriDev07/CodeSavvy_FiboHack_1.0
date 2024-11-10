class CarbonFootPrint {
  // >> Emission unit = kg of CO2

  // Common electric devices consumptions

  // Assuming the average power usage of a ceiling fan per hour in India is ~75 watts
  static final double kwhUsedByFanPerHour = 0.075;

  // Average LED TV power usage, assuming a common 32-40 inch LED in India
  static final double kwhUsedByTVPerHour = 0.06;

  // Average fridge consumption per hour (common Indian refrigerator ~250-300L size)
  static final double kwhUsedByFridgePerHour = 0.15;

  // Electricity (kWh) - National average based on India’s energy mix
  static final double emissionPerUnitElectricity = 0.82;

  // Water (L) - Assumption based on water processing emissions in India
  static final double emissionPerUnitWater = 0.0005;

  // Fuel consumption (average for Indian vehicles per km)
  static final double emissionPerKmCar = 0.204;  // For an average petrol car
  static final double emissionPerKmBike = 0.049; // For a typical two-wheeler
  static final double emissionPerKmBicycle = 0.0;  // Bicycles typically emit negligible CO2

  // Food-related emissions based on typical Indian diet
  static final double emissionPerUnitCalorieOfMeat = 100.0;  // Lower than global averages as meat intake is generally lower in India
  static final double emissionPerUnitCalorieOfGrain = 10.0;
  static final double emissionPerUnitCalorieOfDairy = 2.5;
  static final double emissionPerUnitCalorieOfFruit = 1.0;

  // Average daily emissions in kg of CO2 for an individual in India
  static final double avgEmissionDueToHouseHoldPerDay = 6.5;  // Typical emissions from electricity, gas, and water usage
  static final double avgEmissionDueToFoodPerDay = 4.5;       // Typical emissions based on an average Indian diet
  static final double avgEmissionDueToTravelPerDay = 3.0;     // Average emissions from daily travel within cities

  // Get the daily carbon footprint of your household activities
  static double getDailyHouseHoldCarbonFootPrint(
    double hoursFanUsed,
    double hoursTVUsed,
    double hoursFridgeUsed,
    double litresOfWaterUsed,
  ) {
    double electricityConsumptionInKWH = (hoursFanUsed * kwhUsedByFanPerHour +
        hoursTVUsed * kwhUsedByTVPerHour +
        hoursFridgeUsed * kwhUsedByFridgePerHour);

    double emissionDueToElectricity =
        emissionPerUnitElectricity * electricityConsumptionInKWH;
    double emissionDueToWater = emissionPerUnitWater * litresOfWaterUsed;

    return (emissionDueToElectricity + emissionDueToWater);
  }

  // Get the daily footprint of your travel related activities
  static double getDailyTravelFootPrint(double distanceTravelledByBike,
      double distanceTravelledByCar, double distanceTravelledByBicycle) {
    return (emissionPerKmBike * distanceTravelledByBike +
            emissionPerKmCar * distanceTravelledByCar +
            emissionPerKmBicycle * distanceTravelledByBicycle);
  }

  // Get the daily footprint of your food-related activities
  static double getDailyFoodCarbonFootPrint(
    double meatCalorieIntake,
    double grainCalorieIntake,
    double dairyCalorieIntake,
    double fruitCalorieIntake,
  ) {
    return (meatCalorieIntake * emissionPerUnitCalorieOfMeat +
            grainCalorieIntake * emissionPerUnitCalorieOfGrain +
            dairyCalorieIntake * emissionPerUnitCalorieOfDairy +
            fruitCalorieIntake * emissionPerUnitCalorieOfFruit) / 1000;
  }

  // Get total carbon footprint according to daily activities
  static double getTotalCarbonFootPrint(
    // Household
    double hoursFanUsed,
    double hoursTVUsed,
    double hoursFridgeUsed,
    double litresOfWaterUsed,

    // Travel
    double distanceTravelledByBike,
    double distanceTravelledByCar,
    double distanceTravelledByBicycle,

    // Food
    double meatCalorieIntake,
    double grainCalorieIntake,
    double dairyCalorieIntake,
    double fruitCalorieIntake,
  ) {
    return (getDailyHouseHoldCarbonFootPrint(
            hoursFanUsed, hoursTVUsed, hoursFridgeUsed, litresOfWaterUsed) +
        getDailyTravelFootPrint(distanceTravelledByBike, distanceTravelledByCar,
            distanceTravelledByBicycle) +
        getDailyFoodCarbonFootPrint(meatCalorieIntake, grainCalorieIntake,
            dairyCalorieIntake, fruitCalorieIntake));
  }
}
