import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'my_print.dart';
import 'package:dilidili/lib/library.dart';
import '../constant.dart';

class HtmlUtils {
  static Future<Null> parseHome(String homeHtml, Function fn) async {
    var cartoons = <Cartoon>[];
    var doc = parse(homeHtml);
    List<Element> els =
        doc.documentElement.getElementsByClassName("book\ article");
    List<Element> as = els?.first.getElementsByTagName("a");
    log('${as.length}');
    as.forEach((element) {
      List<Element> figures = element.getElementsByTagName("figure");
      Element figcaption =
          figures.first.getElementsByTagName("figcaption").first;
      List<Element> ps = figcaption.getElementsByTagName("p");
      String url = element.attributes.values.elementAt(0);
      String name = ps.first.innerHtml;
      String episode = ps.last.innerHtml;
      Element e = figures.first.getElementsByClassName("coverImg").first;
      Map<Object, String> attributes = e.attributes as Map<Object, String>;
      String style = attributes.values.last;
      style.replaceAll(")", "");
      var picture = style.split("(").last;
      picture = picture.split(");").first;
      Cartoon cartoon =
          new Cartoon(url: url, picture: picture, name: name, episode: episode);
      cartoons.add(cartoon);
    });
    await fn(cartoons);
  }

//  static Future<List<Cartoon>> parseCategoryDetail(String homeHtml) async {
//    return _parseCategoryDetail(homeHtml);
//  }
  static List<Cartoon> parseCategoryDetail(String html) {
    var cartoons = <Cartoon>[];
    var doc = parse(html);
    List<Element> els =
        doc.documentElement.getElementsByClassName("anime_list");
    if (els.length == 0) return cartoons;
    List<Element> as = els?.first.getElementsByTagName("dl");
    log('${as.length}');
    as.forEach((element) {
      List<Element> dts = element.getElementsByTagName("dt");
      Element img = dts.first.getElementsByTagName("img").first;
      String url = dts.first
          .getElementsByTagName("a")
          .first
          .attributes
          .values
          .elementAt(0);
      List<Element> dds = element.getElementsByTagName("dd");
      Element h3 = dds.first.getElementsByTagName("h3").first;
      String name = h3.getElementsByTagName("a").first.innerHtml;
      var picture = img.attributes.values.elementAt(0);
      Cartoon cartoon = new Cartoon(url: url, picture: picture, name: name);
      cartoons.add(cartoon);
    });
    return cartoons;
  }

  static List<Cartoon> parseCategoryDetailHome(String html) {
    var cartoons = <Cartoon>[];
    var doc = parse(html);
    List<Element> els =
        doc.documentElement.getElementsByClassName("swiper-slide");
    if (els.length == 0) return cartoons;
    List<Element> as = els?.first.getElementsByTagName("li");
    log('${as.length}');
    as.forEach((element) {
//      List<Element> dts = element.getElementsByTagName("a");
      Element a = element.getElementsByTagName("a").first;
      String url = a
          .attributes
          .values
          .elementAt(0);
      Element dds = a.getElementsByTagName("em").first;
      String name = dds.innerHtml;
      name = name.replaceAll(RegExp("<span>(.+)<\/span>"), "");
//      Element img = a.getElementsByTagName("img").first;
//      var picture = img.attributes.values.elementAt(0);
      Cartoon cartoon = new Cartoon(url: url, name: name);
      cartoons.add(cartoon);
    });
    return cartoons;
  }

  static Future<Null> parseCategory(String html, Function fn) async {
    var categorys = <Category>[];
    var doc = parse(html);
    List<Element> tagbox = doc.documentElement.getElementsByClassName("tagbox");
    List<Element> taglist = tagbox[2].getElementsByClassName("tag-list");
    List<Element> as = taglist?.first.getElementsByTagName("a");
    as.forEach((element) {
      var name = element.innerHtml;
      if (name.trim().length == 0) name = "日剧";
      var url = element.attributes.values.first;
      Category category = new Category(url: url, name: name);
      categorys.add(category);
    });
    await fn(categorys);
  }

  static Future<Null> parseDetailList(String html, Function fn) async {
    var cartoons = <Cartoon>[];
    var doc = parse(html);
    List<Element> swipers =
        doc.documentElement.getElementsByClassName("swiper-slide");
    List<Element> clears = swipers.first.getElementsByTagName("ul");
    List<Element> lis = clears.first.getElementsByTagName("li");
    List<Element> details =
        doc.documentElement.getElementsByClassName("detail\ con24\ clear");
    List<Element> dts = details.first.getElementsByTagName("dt");
    String picture = dts.first
        .getElementsByTagName("img")
        .first
        .attributes
        .values
        .elementAt(0);
    List<Element> labels = details.first.getElementsByClassName("d_label2");
    String intro = labels[1].innerHtml;
    intro = intro.split("</b>")[1];
//    List<Element> as = taglist?.first.getElementsByTagName("a");
    if (lis.isEmpty) {
      throw new Exception();
    }
    lis.forEach((element) {
      Element a = element.getElementsByTagName("a").first;
      var name = a.getElementsByTagName("em").first.innerHtml;
      name = name.split("</span>")[1];
      var url = a.attributes.values.first;
      var episode = "";
      Cartoon value = new Cartoon(
          url: url,
          name: name,
          intro: intro,
          picture: picture,
          episode: episode);
      cartoons.add(value);
    });
    await fn(cartoons);
  }

  static Future<Null> parseSearch(String html, Function fn) async {
    var cartoons = <Cartoon>[];
    var doc = parse(html);
    Element results = doc.getElementById("results");
    List<Element> clears = results.getElementsByClassName("result\ f\ s0");
    if (clears.isEmpty) {
      fn(cartoons);
      return;
    }
    clears.forEach((element) {
      Element h3 = element.getElementsByTagName("h3").first;
      Element a = h3.getElementsByTagName("a").first;
      var name = a.innerHtml;
      name = name.replaceAll("<em>", "");
      name = name.replaceAll("</em>", "");
      var url = a.attributes.values.elementAt(2);
      if (url.contains(ConstantValue.URL)) {
        url = url.replaceAll(ConstantValue.URL, "");
        Cartoon value = new Cartoon(url: url, name: name);
        cartoons.add(value);
      }
    });
    await fn(cartoons);
  }

  static Future<Null> parsePlay(
      String playHtml, Function sfn, Function ffn) async {
    String url = "";
    try {
      var doc = parse(playHtml);
      List<Element> els =
          doc.documentElement.getElementsByClassName("player_main");
      List<Element> as = els?.first.getElementsByTagName("iframe");
      url = as.first.attributes.values.elementAt(0);
      log(url);
      await sfn(url);
    } catch (e) {
      log(e);
      await ffn();
    }
  }
}
