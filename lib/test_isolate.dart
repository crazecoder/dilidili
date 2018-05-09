import 'dart:async';
import 'dart:isolate';

run() async {
  var receivePort = new ReceivePort();
  await Isolate.spawn(echo, receivePort.sendPort);

  // 'echo'发送的第一个message，是它的SendPort
  var sendPort = await receivePort.first;

  var msg = await sendReceive(sendPort, "foo");
  print('received $msg');
  msg = await sendReceive(sendPort, "bar");
  print('received $msg');
}

/// 新isolate的入口函数
echo(SendPort sendPort) async {
  // 实例化一个ReceivePort 以接收消息
  var port = new ReceivePort();

  // 把它的sendPort发送给宿主isolate，以便宿主可以给它发送消息
  sendPort.send(port.sendPort);

  // 监听消息
  await for (var msg in port) {
    var data = msg[0];
    SendPort replyTo = msg[1];
    replyTo.send(data);
    if (data == "bar") port.close();
  }
}

/// 对某个port发送消息，并接收结果
Future sendReceive(SendPort port, msg) async {
  ReceivePort response = new ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}
