import 'package:flutter/material.dart';
import 'package:local_commodities/models/store.dart';
import 'package:local_commodities/screens/home_customer/screens/Home.dart';

class StoreTile extends StatelessWidget {

  final Store store;
  StoreTile({ this.store });
  int something=0;
  @override
  Widget build(BuildContext context) {
    String imageLoc = 'Groceries/' + store.imageLoc;
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0,6.0,20.0,0.0),
        child: GestureDetector(
            onTap: () {
              return Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Home()));
            },
            child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.brown[400],
              backgroundImage: AssetImage(imageLoc),
            ),
            title: Text(store.name),
            subtitle: Text(store.address),
          ),
        )
      ),
    ); 
  }
}