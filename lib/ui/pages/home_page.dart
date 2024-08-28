import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpClient;
import '../../models/data_model.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataModel? mDataModel;

  @override
  void initState() {
    super.initState();
    getQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Q u o t e s"),
        centerTitle: true,
      ),
      body: FutureBuilder<DataModel?>(
        future: getQuotes(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
             return Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasData){
            return snapshot.data != null
          ? ListView.builder(itemBuilder: (context, index){
            print("mDataModel!.quotesSize: ${snapshot.data!.quotes.length}");
            return Card(
              elevation: 11,
              margin: EdgeInsets.all(11),
              child: ListTile(
                title: Text(snapshot.data!.quotes[index].quote),
                subtitle: Text(snapshot.data!.quotes[index].author),
              ),
            );
      }, itemCount: snapshot.data!.quotes.length,)
          :  Center( child: Text("No Quotes Found"),);
          }
          else if(snapshot.hasError){
            return Center(
              child: Text("Error: ${snapshot.error.toString()}"),
            );
          }
          else{
            return Container();
          }
        },
      )
    );
  }

  Future<DataModel?> getQuotes() async{
    Uri apiUri = Uri.parse("https://dummyjson.com/quotes");
    httpClient.Response res =  await httpClient.get(apiUri);
    if(res.statusCode == 200){
      print(res.body);
      dynamic actualResponse = jsonDecode(res.body);
      mDataModel = DataModel.fromJson(actualResponse);
      return mDataModel;
    }else{
      return null;
    }
  }
}
