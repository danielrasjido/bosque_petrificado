import 'package:appwrite/appwrite.dart';

class AppwriteService {
  late Client client;
  late Databases databases;
  late Storage storage;

  void init() {
    try {

      client = Client()
          .setEndpoint('https://nyc.cloud.appwrite.io/v1')
          .setProject('68f6caff0036fd8024e1');

      databases = Databases(client);
      storage = Storage(client);

      print('Appwrite inicializado correctamente');

    } catch (e) {
      print('Error crítico en Appwrite init: $e');
    }
  }
}