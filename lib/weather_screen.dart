import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/additional_info_item.dart';
import 'package:weather/general_data.dart';
import 'package:weather/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
      String cityName='London';
      final res =await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherAPIKey',
        ),
      );
      final data=jsonDecode(res.body);
      if(data['cod']!='200'){
        throw 'An unexpected error occure';
      }
      return data;
    }
    catch(e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Weather App',
        style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
         IconButton(
          onPressed: (){
            setState(() {

            });
          },
        icon: const  Icon(Icons.refresh),
         ),
        ],
      ),
      body: 
      FutureBuilder(
        future: getCurrentWeather(),
         builder:(context,snapshot) {
          print(snapshot);
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child:  CircularProgressIndicator.adaptive());
          }
          if(snapshot.hasError){
            return  Text(snapshot.error.toString());
          }
            final data = snapshot.data!;
          final currentTemp= data['list'][0]['main']['temp'];
          final currentSky=data['list'][0]['weather'][0]['main'];
          final currentPresuure=data['list'][0]['main']['pressure'];
          final  currentWindspeed=data['list'][0]['wind']['speed'];
          final  currentHumidity=data['list'][0]['main']['humidity'];


          return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //main card
             SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)
                ) ,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX:10,
                      sigmaY: 10,
                    ),
                    child:  Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            ' $currentTemp K',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),),
                          const SizedBox(height: 16,),
                           Icon(
                          currentSky=='Clouds' || currentSky=='Rain' ?
                          Icons.cloud
                              :Icons.sunny ,
                          size: 64,
                          ),
                          const SizedBox(height: 16,),
                          Text('$currentSky',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
              const SizedBox(height: 20,),
              const Text('Weather Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                ),
              ),
              const  SizedBox(height:  15,),
              //wheather forcast card
            /*   SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for(int i=0;i<5;i++){
                      HourlyForecastItem(
                        time: data['list'][i+1]['dt'].toString(),
                        temp: data['list'][i+1]['main']['temp'].toString(),
                      icon: data['list'][i+1]['weather'][0]['main']=='Clouds' || data['list'][i+1]['weather'][0]['main']=='Rain' ? Icons.cloud:Icons.sunny,),
                    }
                  ],
                ),
              ),*/
              SizedBox(
                height: 120,
                child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index){
                      final hourlyForcast=data['list'][index+1];
                      final hourlySky=data['list'][index+1]['weather'][0]['main'];
                      final time=DateTime.parse(hourlyForcast['dt_txt']);
                      return HourlyForecastItem(
                          temp: DateFormat.Hm().format(time),
                          time: hourlyForcast['main']['temp'].toString(),
                          icon: hourlySky=='Clouds' || hourlySky=='Rain' ?
                            Icons.cloud
                          : Icons.sunny,
                      );
                    },
                ),
              ),
              const SizedBox(height: 20,),
              const Text('Additional Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20,),
              //additional information
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AdditionalInfoItem(icon: Icons.water_drop,
                  label: 'Humditiy',
                  value: currentHumidity.toString(),),
                  AdditionalInfoItem(icon: Icons.air,
                    label: 'Wind Speed',
                    value: currentWindspeed.toString(),),
                  AdditionalInfoItem(icon: Icons.beach_access,
                    label: 'Pressure',
                    value: currentPresuure.toString(),),
                ],
              )

            ],
          ),
        );
         },
      ),
    );
  }
}







