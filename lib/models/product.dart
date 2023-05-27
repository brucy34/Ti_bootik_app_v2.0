class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;
  final String category;
  bool isClicked1=false;
  bool isClicked2=false;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    // this.isClicked=false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],
      description: json['description'],
      price: json['price'],
      image: json['images'][0],
      category: json['category']['name'],
    );
  }

  Map<String,dynamic> mapping(){
    return {'id':id,
      'name':name,
      'price':price,
      'category':category,
      'description':description,
      'image':image};
  }

  @override
  String toString(){
    return 'Product{id:$id,name: $name,category: $category,price: $price,description: $description,image: $image}';
  }
}