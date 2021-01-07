
// This is the config running in production in https://www.zoo.gr/?version=flutter

class Config {
  // Full URI for RPC calls
  static const rpcUri = "https://www.local.zoo.gr/jsonrpc/api";

  // Host-only, where cgi scripts are located
  static const cgiHost = "https://www.local.zoo.gr";

  // Host-only, where photos are located
  static const userPhotosHost = "https://img.local.zoo.gr";

  // Full URI of chat server
  static const chatUri = "https://local.lazyland.biz:3001/zoo_chat/el_GR";

  // Hosts-only, where zmq is located
  static const zmqHosts = ["local.lazyland.biz:3001"];
}
