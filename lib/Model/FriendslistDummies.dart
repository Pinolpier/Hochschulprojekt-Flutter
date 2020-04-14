/**
 * dummie class to test the listview
 */
class FriendslistDummies{
  String name;
  String profilepic;
  bool isSelected = false;
  String group;

  FriendslistDummies({
    this.name, this.profilepic
});

  String getName() {
    return name;
  }

  void setGroup(String newGroup) {
    this.group = newGroup;
  }
}