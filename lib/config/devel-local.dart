
// Sample config for development using a local server.

class Config {
  // Full URI for RPC calls
  static var rpcUri = "http://localhost:8070/api";

  // Host-only, where cgi scripts are location
  static const cgiHost = "https://www.zoo.gr";

  // Host-only, where photos are located
  static const userPhotosHost = "https://img.zoo.gr";

  // Full URI of chat server
  static const chatUri = "https://llgames-ltfallback.lazyland.biz/zoo_chat/el_GR";

  // hosts-only, where zmq is located
  static const zmqHosts = ["llgames-lt1.lazyland.biz", "llgames-lt2.lazyland.biz"];

  // number of zmq instances hosted in each zmq server
  static const zmqInstances = 1;
}
