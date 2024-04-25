import 'package:serverpod/serverpod.dart';
import 'package:todo_server/src/generated/protocol.dart';

class ChannelEndPoint extends Endpoint {
  Future<List<Channel>> getChannels(Session session) async {
    var channels = await Channel.db.find(
      session,
    );
    return channels;
  }
}
