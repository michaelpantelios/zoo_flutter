// config/current.dart should be a symlink to some config file
import 'package:zoo_flutter/config/current.dart';

class Env {

  static const RPC_URI = Config.rpcUri;

  static const cgiHost = Config.cgiHost;

  static const userPhotosHost = Config.userPhotosHost;

  static const chatUri = Config.chatUri;

  static const zmqHosts = Config.zmqHosts;
  static const zmqInstances = Config.zmqInstances;


  // The options below are fixed. If any of them is configurable it should be moved to the Config class.

  // These are _not_ local (flutter) assets
  static ASSET_URL(path) => "https://www.lazyland.eu/$path";

  static getImageKitURL(photoName) => "https://ik.imagekit.io/bugtown/userphotos/testing/$photoName";

  static get oldZooUri => 'https://www.zoo.gr?version=flash';

}
