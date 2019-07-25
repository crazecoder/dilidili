import 'dart:async';

import './bean/bean.dart';
import 'package:flutter/foundation.dart';
import 'package:http_client/console.dart';
import 'utils/html_util.dart';
import 'constant.dart';

Future<String> htmlGetHome() async {
  var _url = "${ConstantValue.URL}/zxgx/?1";
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  await client.close();
  return textContent;
}

Future<String> htmlGetCategory() async {
  var _url = "${ConstantValue.URL}/tvdh/?1";
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  await client.close();
  return textContent;
}

Future<List<Cartoon>> htmlGetCategoryDetail(String url) async {
  var _url = ConstantValue.URL + url;
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  var cartoons = await compute(HtmlUtils.parseCategoryDetail, textContent);

 await client.close();
 return cartoons;
}

Future<List<Cartoon>> htmlGetCategoryDetailHome(String url) async {
  var _url = ConstantValue.URL + url;
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  return await compute(HtmlUtils.parseCategoryDetailHome, textContent);
//  callback(textContent);
//  await client.close();
}

Future<String> htmlGetPlay(String _url) async {
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  return textContent;
}

Future<String> htmlGetSearch(String _name) async {
  var _url =
      "http://zhannei.baidu.com/cse/site?kwtype=0&q=$_name&stp=1&ie=utf8&src=zz&site=www.dilidili.name&cc=www.dilidili.name&rg=1";
  final client = new ConsoleClient();
  final rs = await client.send(new Request('GET', _url));
  final textContent = await rs.readAsString();
  await client.close();
  return textContent;
}

typedef void HttpCallback(String html);
