class Units {
  static double inchesToMm(double inches) => inches * 25.4;
  static double mmToInches(double mm) => mm / 25.4;

  static const nominalQuarters = [4, 5, 6, 8];
  static String quartersLabel(int q) => '$q/4';
}
