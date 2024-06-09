
class MapOrderFood
{
  final int cost;
  final List image;
  final String name;
  final int giamgia;
  final String nhasx;
  final bool trangthai;

   MapOrderFood({
    required this.nhasx,
    required this.cost,
    required this.image,
    required this.name,
    required this.giamgia,
    required this.trangthai,

  });
  factory  MapOrderFood.fromMap(Map<String,dynamic> map)
  {
    return  MapOrderFood(trangthai: map['trangthai'],nhasx: map['nhasx'],cost: map['cost'],image: map['image'], name: map['name'],giamgia: map['giamgia']);
  }

}