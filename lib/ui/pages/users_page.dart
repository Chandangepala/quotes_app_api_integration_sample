import 'dart:convert';

import 'package:flutter/material.dart';
import '../../models/user_data_model.dart';
import 'package:http/http.dart' as httpClient;

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  UserDataModel? mUserDataModel;
  @override
  void initState() {
    super.initState();
    getUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("U s e r s"),
        centerTitle: true,
      ),
      body: FutureBuilder<UserDataModel?>(
        future: getUsersData(),
          builder: ( context,  snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          } 
          else if(snapshot.hasData){
            return snapshot.data != null
                ?   ListView.builder(itemBuilder: (context, index){
              return ListTile(
                leading: CircleAvatar(backgroundImage: NetworkImage(snapshot.data!.users![index].image!),),
                title: Text(snapshot.data!.users![index].username!),
                subtitle: Text(snapshot.data!.users![index].email!),
              );
            }, itemCount: snapshot.data!.users?.length,)
                :  Center(child: Text("No Data Found"),);
          }else if(snapshot.hasError){
            return Center(child: Text("Error: ${snapshot.error.toString()}"),);
          }else{
            return Container();
          }
          },
        ),
    );
  }

  Future<UserDataModel?> getUsersData() async{
      Uri apiUri = Uri.parse("https://dummyjson.com/users");
      httpClient.Response res = await httpClient.get(apiUri);
      if(res.statusCode == 200){
          dynamic actualResponse = jsonDecode(res.body);
          print("actualResponse: ${actualResponse}");
          mUserDataModel = UserDataModel.fromJson(actualResponse);
          return mUserDataModel;
      }else{
        return null;
      }
  }
}
