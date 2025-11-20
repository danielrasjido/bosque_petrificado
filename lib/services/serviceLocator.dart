import 'package:appwrite/appwrite.dart';
import 'package:bosque_petrificado/config/appConfig.dart';
import 'package:bosque_petrificado/services/authenthicationService.dart';
import 'package:bosque_petrificado/services/usuariosService.dart';
import 'package:bosque_petrificado/services/paradasService.dart';

class ServiceLocator {
  // Singleton
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() => _instance;

  late final Client client;
  late final Databases databases;

  late final AuthenticationService authService;
  late final UsuariosService usuariosService;
  late final ParadasService paradasService;

  ServiceLocator._internal() {
    // Inicializamos el cliente UNA sola vez
    client = Client()
      ..setEndpoint(AppConfig.endpoint)
      ..setProject(AppConfig.idProject)
      ..setSelfSigned(status: true);

    // Inicializamos databases UNA sola vez
    databases = Databases(client);

    // Servicios base
    usuariosService = UsuariosService(databases: databases);
    paradasService = ParadasService(databases: databases);

    // Authentication necesita ambos
    authService = AuthenticationService(client, databases);
  }
}
