import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'model.dart';

//basic fllutter app
void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  bool isLoading = true;
  Map<String, double> obtainedData = {'': 0,};
  String imagePath = "assets/images/", referencePath = "";

  @override
  void initState(){
    super.initState();

    //Initializing variables
    updateData();
    //Setting background call for every 5 minutes
    Timer.periodic(const Duration(minutes: 5), (timer) {
        updateData();
    });
  }

  void updateData() async{
    obtainedData = await Model().fetchData();
    if(obtainedData['rain'] == 1){
      referencePath = "${imagePath}drizzle.png";
    }
    else if(obtainedData['humidity']! > 85){
      referencePath = "${imagePath}drizzle.png";
    }
    else if(obtainedData['humidity']! <= 85 && obtainedData['humidity']! > 40){
      referencePath = "${imagePath}cloudy.png";
    }
    else{
      referencePath = "${imagePath}sunny.png";
    }

    //Altitude correction
    obtainedData['altitude'] = 44330*(1 - pow(((obtainedData['pressure']!/100)/1013.25), 1/5.255)) as double;

    //Pressure correction
    obtainedData['pressure'] = obtainedData['pressure']! * (0.00098692/100);

    setState(() {
      isLoading = false;
      //Nothing lol.
      //We wait till the data is updated then update the UI after fetching the UI
      //Still in testing phase but it works!!
    });

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xff38a5ff)),
        home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Weather Station"),
            backgroundColor: const Color(0xff38a5ff),
            actions: [
              IconButton(onPressed: updateData, icon: const Icon(Icons.refresh))
            ],
          ),
          body: isLoading? const Center(child: CircularProgressIndicator()) :
          Column(
            children: [
              //Image widget
              Center(
                child: Image.asset(referencePath, width: 150, height: 150,),
              ),
              //Data widgets
              Column(

                children: [
                  //Temperature widget
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: const Text("Temperature:"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text("  ${obtainedData['temperature']}°C"),
                        ),
                      ],
                    ),
                  ),
                  //Altitude widget
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: const Text("Altitude:"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text("  ${obtainedData['altitude']?.toStringAsFixed(3)}M"),
                        ),
                      ],
                    ),
                  ),
                  //Dew point widget
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: const Text("Dew point:"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text("  ${obtainedData['dew point']}°C Td"),
                        ),

                      ],
                    ),
                  ),
                  //Humidity widget
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: const Text("Humidity:"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text("  ${obtainedData['humidity']}%"),
                        ),
                      ],
                    ),
                  ),
                  //Pressure widget
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: const Text("Pressure:"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text("  ${obtainedData['pressure']?.toStringAsFixed(3)}ATM"),
                        ),

                      ],
                    ),
                  ),
                  //Light intensity widget
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: const Text("Light intensity:"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text("  ${obtainedData['light intensity']}NITTS"),
                        ),
                      ],
                    ),
                  ),
                  //Rain widget
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: const Text("Rain:"),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.3,
                          child: Text("  ${obtainedData['rain']}"),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          )
        ),
    );
  }

}