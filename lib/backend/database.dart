import 'package:apptry/constants.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

Client client = Client().setProject('678a72290036051ffd0a');

Databases databases = Databases(client);

final String databaseId = '678e7809002853909806';
final String customersCollectionId = '678e79590024bed88403';
final String entriesCollectionId = '678f5dce0001ac12390d';
final String storageCollectionId = '678e78160034d1e6b4fc';
final String logsCollectionId = '67c1fede0002776cab9d';

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
      await databases.createDocument(
          databaseId: databaseId,
          collectionId: storageCollectionId,
          documentId: ID.unique(),
          data: {
            'phone': phone,
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
    );
    return document.documents.length;
  } catch (e) {
    print(e);
  }
  return -1;
}

Future<void> addNewLog(String phone, int slip, String type, Map data) async {
  print('Adding new log');
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
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: logsCollectionId,
        queries: [Query.select(fields)]);
    num total = 0;
    for (var doc in result.documents) {
      for (var field in doc.data.entries) {
        if (field.key != 'phone' &&
            field.key != 'slip' &&
            field.key != 'type') {
          total += field.value;
        }
      }
    }
    return total;
  } catch (e) {
    print(e);
  }
  return -1;
}

Future<Map> fetchVarietyWiseTotalBags() async {
  try {
    final document = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: logsCollectionId,
        queries: [Query.select(varietyPairs)]);

    final result = [];
    final Map test = {};
    for (var doc in document.documents) {
      result.add(doc.data.values.first);
      for (var pair in varietyPairs) {
        if (test[pair] == null) {
          test[pair] = doc.data[pair];
        } else {
          test[pair] += doc.data[pair];
        }
      }
    }
    return test;
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
          Query.orderDesc('\$createdAt')
        ]);
    return result.documents;
  } catch (e) {
    print(e);
  }

  return [];
}

Future<void> insertNewEntry(
    String phone,
    int slip,
    String type,
    int pukhraj,
    int jyoti,
    int diamant,
    int cardinal,
    int himalini,
    int badshah,
    int others) async {
  try {
    // Validate input values
    if (slip < 0 ||
        pukhraj < 0 ||
        jyoti < 0 ||
        diamant < 0 ||
        cardinal < 0 ||
        himalini < 0 ||
        badshah < 0 ||
        others < 0) {
      throw Exception('Values cannot be negative');
    }

    final existingDoc = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: storageCollectionId,
        queries: [Query.equal('phone', phone)]);

    final data = existingDoc.documents.first.data;
    final int total =
        pukhraj + jyoti + diamant + cardinal + himalini + badshah + others;

    // Validate removal amounts
    if (type == 'remove') {
      if (pukhraj > data['pukhraj'] ||
          jyoti > data['jyoti'] ||
          diamant > data['diamant'] ||
          cardinal > data['cardinal'] ||
          himalini > data['himalini'] ||
          badshah > data['badshah'] ||
          others > data['others']) {
        throw Exception('Cannot remove more bags than available in storage');
      }
    }

    // Calculate new values based on type
    final multiplier = type == 'add' ? 1 : -1;

    // Update storage document
    Document doc = await databases.updateDocument(
        databaseId: databaseId,
        collectionId: storageCollectionId,
        documentId: existingDoc.documents.first.$id,
        data: {
          'pukhraj': data['pukhraj'] + (pukhraj * multiplier),
          'jyoti': data['jyoti'] + (jyoti * multiplier),
          'diamant': data['diamant'] + (diamant * multiplier),
          'cardinal': data['cardinal'] + (cardinal * multiplier),
          'himalini': data['himalini'] + (himalini * multiplier),
          'badshah': data['badshah'] + (badshah * multiplier),
          'others': data['others'] + (others * multiplier),
          'total': data['total'] + (total * multiplier),
        });

    // Create entry document
    Document document = await databases.createDocument(
        databaseId: databaseId,
        collectionId: entriesCollectionId,
        documentId: ID.unique(),
        data: {
          'phone': phone,
          'slip': slip,
          'type': type,
          'pukhraj': pukhraj,
          'jyoti': jyoti,
          'diamant': diamant,
          'cardinal': cardinal,
          'himalini': himalini,
          'badshah': badshah,
          'others': others
        });
  } catch (e) {
    print('Error in insertNewEntry: $e');
    rethrow; // Rethrow to handle in UI
  }
}

Future<List<Document>> getAllCustomers() async {
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: customersCollectionId,
        queries: [Query.orderAsc('name')]);
    return result.documents;
  } catch (e) {
    print(e);
  }
  return [];
}

Future<num> getTotalBags() async {
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: storageCollectionId,
        queries: [Query.greaterThan('total', 0)]);
    num total = 0;
    for (var element in result.documents) {
      total += element.data['total'];
    }
    return total;
  } catch (e) {
    print(e);
  }
  return -1;
}

Future<List<Document>> getColdStorageBagsDetails() async {
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: storageCollectionId,
        queries: [
          Query.select([
            'pukhraj',
            'jyoti',
            'diamant',
            'cardinal',
            'himalini',
            'badshah',
            'others',
            'total'
          ])
        ]);
    return result.documents;
  } catch (e) {
    print(e);
  }
  return [];
}

Future<Map> getCustomerData(String phone) async {
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: storageCollectionId,
        queries: [Query.equal('phone', phone)]);
    return result.documents.first.data;
  } catch (e) {
    print(e);
  }
  return {};
}

Future<List<Document>> getCustomerEntries(String phone) async {
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: entriesCollectionId,
        queries: [Query.equal('phone', phone), Query.orderDesc('\$createdAt')]);
    return result.documents;
  } catch (e) {
    print(e);
  }
  return [];
}

Future<List<Document>> getRecentEntries() async {
  try {
    final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: entriesCollectionId,
        queries: [
          Query.orderDesc('\$createdAt'),
        ]);
    return result.documents;
  } catch (e) {
    print(e);
  }
  return [];
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
