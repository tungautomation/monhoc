
class MapFood
{
  final int cost;
  final List image;
  final String mota;
  final String name;
  final int giamgia;
  final String email;

  MapFood({
    required this.cost,
    required this.image,
    required this.mota,
    required this.name,
    required this.giamgia,
    required this.email
  });
  factory MapFood.fromMap(Map<String,dynamic> map)
  {
    return MapFood(email: map['email'],cost: map['cost'],image: map['image'], mota: map['mota'], name: map['name'],giamgia: map['giamgia']);
  }

}