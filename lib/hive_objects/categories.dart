import 'package:hive/hive.dart';

part 'categories.g.dart';
// helper class for hive objects helps to manage our object easily without using reference of box
@HiveType(typeId: 1,adapterName: "CategoryAdapter")
class Categories extends HiveObject{

  @HiveField(0)
  String name;


  /// we initialize our constructor soo that to check whether my required fields are correct before saving it to boxes or tables
  Categories(this.name);


}