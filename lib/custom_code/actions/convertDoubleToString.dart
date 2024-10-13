import 'package:intl/intl.dart';

String convertDoubleToString(double value) {
  final NumberFormat formatter = NumberFormat("#,##0.00", "pt_BR");
  return formatter.format(value);
}