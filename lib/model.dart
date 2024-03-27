import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Model {

  Map<String, double> gatheredData = {
    'Temperature' : 0.0,
    'Pressure' : 0.0,
    'Altitude' : 0.0,
    'Light intensity' : 0.0,
    'Dew point' : 0.0,
    'Humidity' : 0.0,
    'Rain' : 0
  };

  String apiLink = "https://io.adafruit.com/api/v2/SudharsshanSY/feeds/";
  List<String> typeData = ['altitude', 'dew-point','humidity', 'light-intensity', 'pressure', 'rain', 'temperature'];

  Future<Map<String, double>> fetchData() async {

    try {
      for(int i = 0; i < 7; i++){
        print("Call link: ${apiLink+typeData[i]}");
        final fetchLink = Uri.parse(apiLink+typeData[i]);
        final response = await http.get(fetchLink);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final lastValue = double.parse(data['last_value'] as String);
          switch(i){
            case 0: gatheredData['Altitude'] = lastValue;
            print("Altitude: ${gatheredData['Altitude']}");
            break;
            case 1: gatheredData['Dew point'] = lastValue;
            print("Dew Point: ${gatheredData['Dew point']}");
            break;
            case 2: gatheredData['Humidity'] = lastValue;
            print("Humidity: ${gatheredData['Humidity']}");
            break;
            case 3: gatheredData['Light intensity'] = lastValue;
            print("Light Intensity: ${gatheredData['Light intensity']}");
            break;
            case 4: gatheredData['Pressure'] = lastValue;
            print("Pressure: ${gatheredData['Pressure']}");
            break;
            case 5: gatheredData['Rain'] = lastValue;
            print("Rain: ${gatheredData['Rain']}");
            break;
            case 6: gatheredData['Temperature'] = lastValue;
            print("Temperature: ${gatheredData['Temperature']}");
            break;
            default: if (kDebugMode) {
              print("SWITCH ERROR: WRONG PARAMETER");
            }
            break;
          }
        } else {
          if (kDebugMode) {
            print(("Error in fetching data"));
          }
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error is: $error");
      }
    }
    return gatheredData;
  }
}