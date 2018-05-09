import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Cartoon  extends Object with _$CartoonSerializerMixin{
  String url;
  String name;
  String episode;
  String picture;
  String intro;
  Cartoon({this.url,this.name,this.episode,this.picture,this.intro});
  get cartoonUrl=>url;
  get cartoonName=>name;
  get cartoonEpisode=>episode;
  get cartoonPicture=>picture;
  get cartoonIntro=>intro;

  factory Cartoon.fromJson(Map<String, dynamic> json) {
    Cartoon cartoon = _$CartoonFromJson(json);
    return cartoon;
  }
}
Cartoon _$CartoonFromJson(Map<String, dynamic> json) => new Cartoon(
    url: json['url'] as String,
    name: json['name'] as String,
    episode: json['episode'] as String,
    picture: json['picture'] as String,
    intro: json['intro'] as String);

abstract class _$CartoonSerializerMixin {
  String get url;
  String get name;
  String get episode;
  String get picture;
  String get intro;
  Map<String, dynamic> toJson() => <String, dynamic>{
    'url': url,
    'name': name,
    'episode': episode,
    'picture': picture,
    'intro': intro
  };
}
