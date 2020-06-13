import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_commodities/models/item.dart';
import 'package:local_commodities/models/user.dart';
import 'package:local_commodities/models/store.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  //collection reference
  final CollectionReference users = Firestore.instance.collection('users');
  final CollectionReference stores = Firestore.instance.collection('stores');
  final CollectionReference oldStores = Firestore.instance.collection('Stores');

  Future addUserTypeandName(String userType, String name) async {
    return await users.document(uid).setData({
      'Type' : userType,
      'Name' : name,
    });
  }

  Future addStoreInfo(String name,String address,String imageLoc) async {
    return await stores.document(uid).setData({
      'Name': name,
      'Address': address,
      'Image': imageLoc,
    });
  }

  Future addItemData(String name, String price, String type) async {
    return await stores.document(uid).collection('Items').document(name).setData({  
    'Name': name,
    'Image': name + '.jpg',
    'Price': price,
    'Type': type,
    'counter': 0,
    'qty_type': 3,
    'sp_price': 0,
    });
  }

  Future addAllItems(String name,double price, int type, String imageLoc, int counter, int qtyType, double spPrice) async {
    return await stores.document(uid).collection('Items').document(name).setData({
     'Name': name,
    'Image': imageLoc,
    'Price': price,
    'Type': type,
    'counter': counter,
    'qty_type': qtyType,
    'sp_price': spPrice, 
    });
  }

  //stores list from snapshot
  List<Store> _storesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Store(
        name: doc.data['Name'] ?? '',
        address: doc.data['Address'] ?? '',
        imageLoc: doc.data['Image'] ?? '',
      );
    }).toList();
  }


  Store _storeFromSnapshot(DocumentSnapshot snapshot) {
    return Store(
      name: snapshot.data['Name'],
      address: snapshot.data['Address'],
      imageLoc: snapshot.data['Image'],
    );
  }


  Stream<List<Store>> get shops {
    return stores.snapshots()
      .map(_storesListFromSnapshot);
  }

  Stream<Store> get store {
    return stores.document(uid).snapshots()
    .map(_storeFromSnapshot);
  }

  UserType _userTypeFromSnapshot(DocumentSnapshot snapshot) {
    return UserType(userType: snapshot.data['Type']);
  }

  Stream<UserType> get userType {
    return users.document(uid).snapshots()
    .map(_userTypeFromSnapshot);
  }

  List<AllItems> _getAllItemsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
    return AllItems(
      name: doc.data['Name'],
      imageLoc: doc.data['Image'],
      price: doc.data['Price'],
      type: doc.data['Type'],
      counter: doc.data['counter'],
      qtyType: doc.data['qty_type'],
      spPrice: doc.data['sp_price'],
    );
    }).toList();
  }

  Stream<List<AllItems>> get allItems {
    return oldStores.document('Store1').collection('Items').snapshots()
    .map(_getAllItemsFromSnapshot);
  }

} 


