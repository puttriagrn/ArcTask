class Category {
  final String name;
  final String icon;
  final String color;

  Category({required this.name, required this.icon, required this.color});

  // Mengubah kategori menjadi map untuk disimpan ke JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  // Membuat instance kategori dari map JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
    );
  }
}
