class UserModel {
  final String id;
  final String name;
  final String jobTitle;
  final String region;
  final String phone;
  final String email;
  final String avatarInitials;

  UserModel({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.region,
    required this.phone,
    required this.email,
    required this.avatarInitials,
  });

  static UserModel sampleUser() {
    return UserModel(
      id: '1',
      name: 'John Doe',
      jobTitle: 'Sales Representative',
      region: 'Algiers Region',
      phone: '+213 555 123 456',
      email: 'john.doe@mobilis.dz',
      avatarInitials: 'JD',
    );
  }
}