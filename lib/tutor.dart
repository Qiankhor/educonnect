class Tutor {
  final String name;
  final int age;
  final String gender;
  final String level;
  final String subject;
  final String profileImage;
  final int rating;
  final String education;
  final int experience;
  final String location;
  final String aboutme;
  final double rate;
  final bool review;

  Tutor({
    required this.name,
    required this.age,
    required this.gender,
    required this.level,
    required this.subject,
    required this.profileImage,
    required this.rating,
    required this.education,
    required this.experience,
    required this.location,
    required this.aboutme,
    required this.rate,
    required this.review,
  });
}

final List<Tutor> allTutors = [
  Tutor(
    name: 'Selina',
    subject: 'English',
    age: 29,
    gender: 'Female',
    level: 'Primary',
    profileImage: 'assets/english_teacher.png',
    rating: 4,
    education: 'B.A. in English Literature from University of Malaya',
    experience: 13,
    location: 'Bangi, Selangor',
    aboutme:
        'Hello! I’m Selina, an enthusiastic English tutor with a Bachelor of Arts in English Literature from University of Malaya. I specialize in teaching primary level students, focusing on building strong foundations in reading, writing, grammar, and vocabulary.',
    rate: 20,
    review: true,
  ),
  Tutor(
    name: 'Alya',
    subject: 'BM',
    age: 27,
    gender: 'Female',
    level: 'Primary',
    profileImage: 'assets/bm_teacher.jpg',
    rating: 5,
    education: 'B.A. in Malay Language from National University of Malaysia',
    experience: 7,
    location: 'Tanjung Piandang, Perak',
    aboutme: '',
    rate: 25,
    review: false,
  ),
  Tutor(
    name: 'Anson Goh',
    age: 32,
    gender: 'Male',
    level: 'Secondary',
    subject: 'Chemistry',
    profileImage: 'assets/chemistry_teacher.jpeg',
    rating: 5,
    education:
        "Bachelor's Degree in Chemistry from University of Putra Malaysia",
    experience: 11,
    location: 'Bukit Mertajam, Penang',
    aboutme: '',
    rate: 30,
    review: false,
  ),
  Tutor(
    name: 'Afif Izuddin',
    age: 30,
    gender: 'Male',
    level: 'Secondary',
    subject: 'Mathematics',
    profileImage: 'assets/mathematics_teacher.jpeg',
    rating: 4,
    education:
        "Bachelor's Degree in Mathematics from Nasional University of Malaysia",
    experience: 16,
    location: 'Tanjung Piandang, Perak',
    aboutme: '',
    rate: 35,
    review: false,
  ),
];
