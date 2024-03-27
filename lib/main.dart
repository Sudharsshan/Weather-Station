import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'model.dart';

//basic flutter app
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
    if(obtainedData['Rain'] == 1){
      referencePath = "${imagePath}drizzle.png";
    }
    else if(obtainedData['Humidity']! > 85){
      referencePath = "${imagePath}drizzle.png";
    }
    else if(obtainedData['Humidity']! <= 85 && obtainedData['Humidity']! > 40){
      referencePath = "${imagePath}cloudy.png";
    }
    else{
      referencePath = "${imagePath}sunny.png";
    }

    //Altitude correction
    obtainedData['Altitude'] = 44330*(1 - pow(((obtainedData['Pressure']!/100)/1013.25), 1/5.255)) as double;

    //Pressure correction
    obtainedData['Pressure'] = obtainedData['Pressure']! * (0.00098692/100);

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
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final key = obtainedData.keys.elementAt(index);
                          final value = obtainedData[key];
                          final suffix = switch(index){
                             0 => " °C",
                             1 => " ATM",
                             2 => ' M',
                             3 => ' NITTS',
                             4 => ' %',
                             5 => ' °C Td',
                             6 => '', //Rain doesn't need any units it's only 'RAINING' or 'NOT-RAINING'
                            // TODO: Handle anonymous case.
                            int() => null,
                          };
                          return Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.2,
                                    child: Text("$key:"),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width*0.3,
                                      child: Text("  $value$suffix"),
                                    ),
                                  ],
                              ),
                            );
                          },
                        childCount: obtainedData.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
    );
  }
}