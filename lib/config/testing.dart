
// This is the config running in production in https://www.zoo.gr/?version=flutter

class Config {
  // Full URI for RPC calls
  static const rpcUri = "https://www.test.zoo.gr/jsonrpc/api";

  // Host-only, where cgi scripts are located
  static const cgiHost = "https://www.test.zoo.gr";

  // Host-only, where photos are located
  static const userPhotosHost = "https://img.test.zoo.gr";

  // Full URI of chat server
  static const chatUri = "https://testing-1.lazyland.biz/zoo_chat/el_GR";

  // hosts-only, where zmq is located
  static const zmqHosts = ["testing-1.lazyland.biz"];

  // number of zmq instances hosted in each zmq server
  static const zmqInstances = 1;
}