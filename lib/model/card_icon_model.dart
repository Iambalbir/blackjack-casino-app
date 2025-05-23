class CardIconModel {
  dynamic icon;
  dynamic color;
  dynamic title;

  CardIconModel({this.icon, this.color, this.title});

  CardIconModel.fromJson(Map<String, dynamic> data) {
    icon = data['icon'];
    title = data['title'];
    color = data['color'];
  }

  Map toJson() {
    Map<String, dynamic> data = Map();
    data['icon'] = this.icon;
    data['title'] = this.title;
    data['color'] = this.color;

    return data;
  }
}
