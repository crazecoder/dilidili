import 'dart:async';

import 'package:http_client/console.dart';
import 'package:dilidili/utils/my_print.dart';
import 'utils/html_util.dart';
import 'lib/library.dart';
import 'lib/my_isolate.dart';

const URL = 'http://www.dilidili.name';
void htmlGetHome(HttpCallback callback) async {
  var _url = "$URL/zxgx/?1";
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  log(textContent);
  callback(textContent);
  await client.close();
}

void htmlGetCategory(HttpCallback callback) async {
  var _url = "$URL/tvdh/?1";
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  log(textContent);
  callback(textContent);
  await client.close();
}

Future<Null> htmlGetCategoryDetail(String url,
    {Function sfn, Function ffn}) async {
  var _url = URL + url;
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  log(textContent);
  var cartoons = await compute(HtmlUtils.parseCategoryDetail, textContent);
  if (cartoons.isEmpty) {
    ffn();
  } else
    sfn(cartoons);

//  callback(textContent);
//  await client.close();
}

Future<Null> htmlGetCategoryDetailHome(String url,
    {Function sfn, Function ffn}) async {
  var _url = URL + url;
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  log(textContent);
  var cartoons = await compute(HtmlUtils.parseCategoryDetailHome, textContent);
  if (cartoons.isEmpty) {
    ffn();
  } else
    sfn(cartoons);

//  callback(textContent);
//  await client.close();
}

void htmlGetPlay(HttpCallback callback, String _url) async {
  log(_url);
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  log(textContent);
  callback(textContent);
  await client.close();
}

void htmlGetSearch(HttpCallback callback, String _name) async {
  var _url =
      "http://zhannei.baidu.com/cse/site?kwtype=0&q=$_name&stp=1&ie=utf8&src=zz&site=www.dilidili.name&cc=www.dilidili.name&rg=1";
  final client = new ConsoleClient();
  log(_url);
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  log(textContent);
  callback(textContent);
  await client.close();
}

typedef void HttpCallback(String html);
