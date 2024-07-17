enum Month {
  january("January"), february("February"), march("March"), april("April"), may("May"), june("June"), july("July"), august("August"), september("September"), october("October"), november("November"), december("December");

  final String displayName;

  const Month(this.displayName);

  static String getMonth(int index) {
    return values.firstWhere((element) => element.index + 1 == index, orElse: () => Month.january,).displayName;
  }
}