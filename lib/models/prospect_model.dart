class Prospect {
  final String id;
  final String name;
  final String contactPerson;
  final String phone;
  final String address;
  final String commune;
  final String category;
  final String notes;
  final String status; // New, Pending, Accepted, Rejected
  final DateTime createdAt;
  final String location;

  Prospect({
    required this.id,
    required this.name,
    required this.contactPerson,
    required this.phone,
    required this.address,
    required this.commune,
    required this.category,
    this.notes = '',
    required this.status,
    required this.createdAt,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'contactPerson': contactPerson,
        'phone': phone,
        'address': address,
        'commune': commune,
        'category': category,
        'notes': notes,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'location': location,
      };

  factory Prospect.fromJson(Map<String, dynamic> json) => Prospect(
        id: json['id'],
        name: json['name'],
        contactPerson: json['contactPerson'],
        phone: json['phone'],
        address: json['address'],
        commune: json['commune'],
        category: json['category'],
        notes: json['notes'] ?? '',
        status: json['status'],
        createdAt: DateTime.parse(json['createdAt']),
        location: json['location'],
      );
}