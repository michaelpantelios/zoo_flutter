class Env {
  static bool _testing = false;
  static String _server;
  static String _RPC_URI;

  Env(config) {
    print(config);

    Env._testing = config["testing"];
    Env._server = config["server"];
  }

  static get testing {
    return Env._testing;
  }

  static get server {
    return Env._server;
  }

  static get RPC_URI {
    if (Env._testing && Env._server != null)
      return "http://" + Env._server + ":8070/api";
    else if (Env._testing)
      return "https://www.zoo.test.gr/jsonrpc/api";
    else if (!Env._testing) return "https://www.zoo.gr/jsonrpc/api";
  }

  static ASSET_URL(path) {
    if (Env._testing && Env._server != null)
      return "http://" + Env._server + ":8070/$path";
    else if (Env._testing)
      return "https://www.lazyland.eu/$path";
    else if (!Env._testing) return "https://www.lazyland.eu/$path";
  }

  static getImageKitURL(photoName) {
    return "https://ik.imagekit.io/bugtown/userphotos/testing/" + photoName;
  }

  static get zooURL => "https://www.zoo.gr";
}
