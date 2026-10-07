import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({Connectivity? connectivity, InternetConnection? internetConnection})
      : _connectivity = connectivity ?? Connectivity(),
        _internetConnection = internetConnection ?? InternetConnection();
  final Connectivity _connectivity;
  final InternetConnection _internetConnection;
  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    final hasInterface = results.any((r) => r != ConnectivityResult.none);
    if (!hasInterface) return false;
    return _internetConnection.hasInternetAccess;
  }
}
