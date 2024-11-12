class CarbonFootPrint {
  // >> Emission unit = kg of CO2

  // Common electric device consumption
  static final double kwhUsedByFanPerHour = 0.065;  // Assumed average for India
  static final double kwhUsedByTVPerHour = 0.03;    // For a 35-inch LED TV
  static final double kwhUsedByFridgePerHour = 0.25;  // Average for a 250W fridge

  // Electricity (kWh) - National average based on India's energy mix
  static final double emissionPerUnitElectricity = 0.475;

  // Water (L)
  static final double emissionPerUnitWater = 0.001;

  // Fuel (km) - India average
  static final double emissionPerKmCar = 0.313;
  static final double emissionPerKmBike = 0.0687;
  static final double emissionPerKmBicycle = 0.016;

  // Food-related emissions (calories)
  static final double emissionPerUnitCalorieOfMeat = 219.67;
  static final double emissionPerUnitCalorieOfGrain = 15.34;
  static final double emissionPerUnitCalorieOfDairy = 1.9;
  static final double emissionPerUnitCalorieOfFruit = 1.55;

  // Waste emissions (grams)
  static final double emissionPerGramOrganicWaste = 0.001;
  static final double emissionPerGramElectronicWaste = 0.04;
  static final double emissionPerGramPlasticWaste = 0.03;

  // Average daily emissions in kg of CO2 for an individual in India
  static final double avgEmissionDueToHouseHoldPerDay = 10;
  static final double avgEmissionDueToFoodPerDay = 10;
  static final double avgEmissionDueToTravelPerDay = 10;
  static final double avgEmissionDueToWastePerDay = 5;

  // Household footprint calculation
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

  // Travel footprint calculation
  static double getDailyTravelFootPrint(double distanceTravelledByBike,
      double distanceTravelledByCar, double distanceTravelledByBicycle) {
    return (emissionPerKmBike * distanceTravelledByBike +
            emissionPerKmCar * distanceTravelledByCar +
            emissionPerKmBicycle * distanceTravelledByBicycle);
  }

  // Food footprint calculation
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

  // Waste footprint calculation
  static double getDailyWasteCarbonFootPrint(
    double organicWasteInGrams,
    double electronicWasteInGrams,
    double plasticWasteInGrams,
  ) {
    return (organicWasteInGrams * emissionPerGramOrganicWaste +
            electronicWasteInGrams * emissionPerGramElectronicWaste +
            plasticWasteInGrams * emissionPerGramPlasticWaste);
  }

  // Total carbon footprint calculation
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

    // Waste
    double organicWasteInGrams,
    double electronicWasteInGrams,
    double plasticWasteInGrams,
  ) {
    return (getDailyHouseHoldCarbonFootPrint(
            hoursFanUsed, hoursTVUsed, hoursFridgeUsed, litresOfWaterUsed) +
        getDailyTravelFootPrint(distanceTravelledByBike, distanceTravelledByCar,
            distanceTravelledByBicycle) +
        getDailyFoodCarbonFootPrint(meatCalorieIntake, grainCalorieIntake,
            dairyCalorieIntake, fruitCalorieIntake) +
        getDailyWasteCarbonFootPrint(
            organicWasteInGrams, electronicWasteInGrams, plasticWasteInGrams));
  }
}
