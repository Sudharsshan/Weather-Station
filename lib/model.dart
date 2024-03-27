import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Model {

  Map<String, double> gatheredData = {
    'temperature' : 0.0,
    'pressure' : 0.0,
    'altitude' : 0.0,
    'light intensity' : 0.0,
    'dew point' : 0.0,
    'humidity' : 0.0,
    'rain' : 0
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
            case 0: gatheredData['altitude'] = lastValue;
            print("Altitude: ${gatheredData['altitude']}");
            break;
            case 1: gatheredData['dew point'] = lastValue;
            print("Dew Point: ${gatheredData['dew point']}");
            break;
            case 2: gatheredData['humidity'] = lastValue;
            print("Humidity: ${gatheredData['humidity']}");
            break;
            case 3: gatheredData['light intensity'] = lastValue;
            print("Light Intensity: ${gatheredData['light intensity']}");
            break;
            case 4: gatheredData['pressure'] = lastValue;
            print("Pressure: ${gatheredData['pressure']}");
            break;
            case 5: gatheredData['rain'] = lastValue;
            print("Rain: ${gatheredData['rain']}");
            break;
            case 6: gatheredData['temperature'] = lastValue;
            print("Temperature: ${gatheredData['temperature']}");
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