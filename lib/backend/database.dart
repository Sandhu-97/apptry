// ignore_for_file: avoid_print

import 'package:apptry/constants.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

Client client = Client().setProject('678a72290036051ffd0a');

Databases databases = Databases(client);

List<Document> cachedLogs = [];
List<Document> cachedCustomers = [];

final int slipLimit = 300;

List<Document> getCachedCustomers() => cachedCustomers;

Future<bool> createNewCustomer(String phone, String name) async {
  try {
    DocumentList docs = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: customersCollectionId,
        queries: [Query.equal('phone', phone)]);
    if (docs.documents.isNotEmpty) {
      return false;
    } else {
      Document document = await databases.createDocument(
          databaseId: databaseId,
          collectionId: customersCollectionId,
          documentId: ID.unique(),
          data: {
            'phone': phone,
            'name': name,
          });
    }
  } catch (e) {
    print(e);
  }
  return true;
}

Future<String> getName(String phone) async {
  try {
    DocumentList docs = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: customersCollectionId,
        queries: [Query.equal('phone', phone)]);

    String name = (docs.documents.first.data['name']);
    return name;
  } catch (e) {
    print(e);
  }
  return "";
}

Future<num> fetchTotalCustomersCount() async {
  try {
    final document = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: customersCollectionId,
        queries: [Query.limit(100)]);
    return document.documents.length;
  } catch (e) {
    print(e);
  }
  return -1;
}

Future<void> addNewLog(String phone, int slip, String type, Map data) async {
  Map output = {
    'phone': phone,
    'slip': slip,
    'type': type,
  };
  for (var entry in data.entries) {
    output[entry.key.toString().toLowerCase()] = entry.value;
  }
  try {
    Document document = await databases.createDocument(
        databaseId: databaseId,
        collectionId: logsCollectionId,
        documentId: ID.unique(),
        data: output);
  } catch (e) {
    print('Error in addNewLog: $e');
    rethrow;
  }
}

Future<num> fetchTotalBags() async {
  List<String> fields = [];
  fields = varietyPairs;
  try {
    Map result = await fetchVarietyWiseTotalBags();
    num total = 0;

    for (var pair in fields) {
      total += result[pair];
    }

    return total;
  } catch (e) {
    print(e);
  }
  return -1;
}

Future<Map> fetchVarietyWiseTotalBags({String phone = ""}) async {
  final List<String> addQuery = [
    Query.select(varietyPairs),
    Query.equal('type', 'add'),
    Query.limit(slipLimit)
  ];
  final List<String> removeQuery = [
    Query.select(varietyPairs),
    Query.equal('type', 'remove'),
    Query.limit(slipLimit)
  ];
  if (phone.isNotEmpty) {
    addQuery.add(Query.equal('phone', phone));
    removeQuery.add(Query.equal('phone', phone));
  }
  try {
    final additons = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: logsCollectionId,
        queries: addQuery);

    final removals = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: logsCollectionId,
        queries: removeQuery);
    final Map result = {};
    final Map addedBags = {};
    final Map removedBags = {};
    for (var doc in additons.documents) {
      for (var pair in varietyPairs) {
        if (addedBags[pair] == null) {
          addedBags[pair] = doc.data[pair];
        } else {
          addedBags[pair] += doc.data[pair];
        }
      }
    }

    for (var doc in removals.documents) {
      for (var pair in varietyPairs) {
        if (removedBags[pair] == null) {
          removedBags[pair] = doc.data[pair];
        } else {
          removedBags[pair] += doc.data[pair];
        }
      }
    }
    for (var pair in varietyPairs) {
      result[pair] = addedBags[pair] - (removedBags[pair] ?? 0);
    }
    return result;
  } catch (e) {
    print(e);
  }
  return {};
}

Future<List> fetchSlipHistory() async {
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: logsCollectionId,
        queries: [
          Query.select(
            ['phone', 'slip', 'type', '\$createdAt'],
          ),
          Query.orderDesc('slip'),
          Query.limit(slipLimit),
        ]);
    return result.documents;
  } catch (e) {
    print(e);
  }

  return [];
}

Future<List> fetchSlipHistoryByPhone(String phone) async {
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: logsCollectionId,
        queries: [
          Query.select(
            ['phone', 'slip', 'type', '\$createdAt'],
          ),
          Query.equal('phone', phone),
          Query.orderDesc('slip'),
          Query.limit(slipLimit),
        ]);
    return result.documents;
  } catch (e) {
    print(e);
  }

  return [];
}

Future<List<Document>> getAllCustomers() async {
  try {
        final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: customersCollectionId,
        queries: [Query.orderAsc('name'), Query.limit(100)]);

    cachedCustomers = result.documents;
    return result.documents;
  } catch (e) {
    print(e);
  }
  return [];
}

Future<Map> getCustomerData(String phone) async {
  try {
    final result = await fetchVarietyWiseTotalBags(phone: phone);
    return result;
  } catch (e) {
    print(e);
  }
  return {};
}

Future<List<Document>> getEntryBySlip(String slip) async {
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: logsCollectionId,
        queries: [
          Query.equal('slip', num.parse(slip)),
          Query.select(varietyPairs),
        ]);
    return result.documents;
  } catch (e) {
    print(e);
  }
  return [];
}
