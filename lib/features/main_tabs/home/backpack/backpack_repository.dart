import 'package:cloud_firestore/cloud_firestore.dart';

import 'backpack_bag.dart';
import 'backpack_item.dart';

class BackpackRepository {
  BackpackRepository({
    FirebaseFirestore? firestore,
    required this.userId,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final String userId;

  CollectionReference<Map<String, dynamic>> get _bagsRef => _firestore
      .collection('users')
      .doc(userId)
      .collection('backpacks');

  // ÇANTALAR
  Future<List<BackpackBag>> loadBags() async {
    final snapshot = await _bagsRef.get();
    return snapshot.docs
        .map((doc) => BackpackBag.fromJson(doc.id, doc.data()))
        .toList();
  }

  Future<BackpackBag> addBag(
    String name, {
    bool isDefault = false,
    List<BackpackItem> initialItems = const [],
  }) async {
    final docRef = await _bagsRef.add({
      'name': name,
      'isDefault': isDefault,
    });

    if (initialItems.isNotEmpty) {
      final itemsRef = _bagsRef.doc(docRef.id).collection('items');
      for (final item in initialItems) {
        await itemsRef.add(item.toJson());
      }
    }

    return BackpackBag(id: docRef.id, name: name, isDefault: isDefault);
  }

  Future<BackpackBag> createDefaultBag() async {
    const defaultBagNameKey = 'default_backpack_name';
    const defaultItemKeys = [
      'towel',
      'water_bottle',
      'sports_shoes',
      'slippers',
      'socks',
    ];

    final defaultItems = [
      for (var i = 0; i < defaultItemKeys.length; i++)
        BackpackItem(
          name: defaultItemKeys[i],
          index: i,
          iconKey: defaultItemKeys[i],
        ),
    ];

    return addBag(
      defaultBagNameKey,
      isDefault: true,
      initialItems: defaultItems,
    );
  }

  Future<void> deleteBag(String bagId) async {
    final bagRef = _bagsRef.doc(bagId);
    final itemsSnapshot = await bagRef.collection('items').get();
    for (final doc in itemsSnapshot.docs) {
      await doc.reference.delete();
    }
    await bagRef.delete();
  }

  Future<void> updateBagName(String bagId, String newName) async {
    await _bagsRef.doc(bagId).update({'name': newName});
  }

  // ITEM'LER
  Future<List<BackpackItem>> fetchItems(String bagId) async {
    final itemsRef = _bagsRef.doc(bagId).collection('items');
    final snapshot = await itemsRef.orderBy('index').get();
    return snapshot.docs
        .map((doc) => BackpackItem.fromJson(doc.data()))
        .toList();
  }

  Future<void> addItemToBag(String bagId, BackpackItem item) async {
    final itemsRef = _bagsRef.doc(bagId).collection('items');
    final snapshot = await itemsRef.orderBy('index').get();
    final nextIndex = snapshot.size;
    await itemsRef.add(item.copyWith(index: nextIndex).toJson());
  }

  Future<void> deleteItemFromBag(String bagId, String itemName) async {
    final itemsRef = _bagsRef.doc(bagId).collection('items');
    final snapshot = await itemsRef.where('name', isEqualTo: itemName).get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
