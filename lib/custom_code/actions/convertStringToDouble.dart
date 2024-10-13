double convertStringToDouble(String stringNumber){
  stringNumber = stringNumber.replaceAll('.', '').replaceAll(',', '.');
  return double.parse(stringNumber);
}