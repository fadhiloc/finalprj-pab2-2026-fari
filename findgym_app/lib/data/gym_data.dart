import 'package:aplikasi_gym_palembang/Models/Gym.dart';

var gymList = [
  Gym(
    name: 'Tamk Gym',
    location: 'Jln. Residen Abdul Rozak, Ruko PHDM',
    description:
        'Tamk Gym adalah pusat kebugaran yang terletak di Jln. Residen Abdul Rozak, Ruko PHDM, Palembang. Gym ini menawarkan fasilitas lengkap untuk membantu anggota mencapai tujuan kebugaran mereka.',
    built: '2012',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '08:00 - 21:00'},
    imageAsset: 'images/tamk_gym.jpeg',
    imageUrls: [
      'images/tamk_gym.jpeg',
      'images/tamk2.png',
      'images/olahraga4.png',
    ],
    isFavorite: false,
    rating: 5.0,
    ratingCount: 17,
  ),

  Gym(
    name: 'Dzafin Gym',
    location: 'Jl. R. E. Martadinata No.781',
    description:
        'Dzafin Gym adalah pusat kebugaran yang terletak di Jl. R. E. Martadinata, Palembang. Dengan jam operasional yang luas, gym ini menyediakan berbagai program pelatihan untuk semua tingkatan kebugaran.',
    built: '2010',
    type: 'Gym',
    schedule: {'Senin - Minggu': '08:00 - 22:00'},
    imageAsset: 'images/dzafin_gym.jpeg',
    imageUrls: [
      'images/dzafin_gym.jpeg',
      'images/dzafin2.png',
      'images/dzafin3.png',
    ],
    isFavorite: false,
    rating: 5.0,
    ratingCount: 17,
  ),

  Gym(
    name: 'Numero Uno Fitness',
    location: 'Jl. Veteran, Kepandean Baru',
    description:
        'Numero Uno Fitness adalah pusat kebugaran yang terletak di Jl. Veteran, Palembang. Dengan jam operasional yang nyaman, gym ini menawarkan berbagai program latihan untuk meningkatkan kebugaran anggotanya.',
    built: '2015',
    type: 'Gym',
    secondaryType: 'Aerobic',
    schedule: {'Senin - Minggu': '09:00 - 22:00'},
    imageAsset: 'images/numero_uno_fitness.png',
    imageUrls: [
      'images/numero_uno_fitness.png',
      'images/numero2.png',
      'images/numero3.png',
    ],
    isFavorite: false,
    rating: 4.6,
    ratingCount: 121,
  ),

  Gym(
    name: 'Osbon Gym',
    location: 'Jl. Rajawali No.465 ',
    description:
        'Osbon Gym adalah pusat kebugaran yang terletak di Jl. Rajawali, Palembang. Dengan jam operasional yang panjang, gym ini menyediakan berbagai fasilitas dan program latihan untuk mencapai tujuan kebugaran.',
    built: '2008',
    type: 'Gym',
    schedule: {'Senin - Minggu': '06:00 - 22:00'},
    imageAsset: 'images/osbon_gym.jpeg',
    imageUrls: [
      'images/osbon_gym.jpeg',
      'images/olahraga5.png',
      'images/gymbox2.png',
    ],
    isFavorite: false,
    rating: 4.6,
    ratingCount: 280,
  ),

  Gym(
    name: 'GYMBOXX',
    location: 'Lorong Pendopo, 20 Ilir D II',
    description:
        'GYMBOXX adalah pusat kebugaran yang terletak di Lorong Pendopo, Palembang. Gym ini dilengkapi dengan peralatan modern dan menyediakan berbagai kelas latihan untuk memenuhi kebutuhan anggota.',
    built: '2013',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '08:00 - 22:00'},
    imageAsset: 'images/gymboxx.jpeg',
    imageUrls: [
      'images/gymboxx.jpeg',
      'images/gymbox2.png',
      'images/gymbox3.png',
    ],
    isFavorite: false,
    rating: 4.5,
    ratingCount: 87,
  ),

  Gym(
    name: 'Central Fitness Palembang',
    location: 'Jl. Angkatan 66 No.926',
    description:
        'Central Fitness Palembang adalah pusat kebugaran yang terletak di Jl. Angkatan 66, Palembang. Dengan fasilitas modern dan instruktur berkualitas, gym ini menawarkan pengalaman latihan yang unik.',
    built: '2016',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '08:30 - 22:00'},
    imageAsset: 'images/central_fitness_palembang.png',
    imageUrls: [
      'images/central_fitness_palembang.png',
      'images/central2.png',
      'images/central3.png',
    ],
    isFavorite: false,
    rating: 4.8,
    ratingCount: 68,
  ),

  Gym(
    name: 'Star Fitness',
    location: 'Jl. Merbau No.11, 9 Ilir',
    description:
        'Star Fitness adalah pusat kebugaran yang terletak di Jl. Merbau, Palembang. Dengan jam operasional yang panjang, gym ini menyediakan berbagai fasilitas dan kelas latihan untuk mencapai tujuan kebugaran.',
    built: '2011',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '06:00 - 22:00'},
    imageAsset: 'images/star_fitness.jpeg',
    imageUrls: [
      'images/star_fitness.jpeg',
      'images/star2.png',
      'images/star3.png',
    ],
    isFavorite: false,
    rating: 4.3,
    ratingCount: 49,
  ),

  Gym(
    name: 'Boss Gym',
    location: 'Jl. R. Sukamto No.95, 8 Ilir',
    description:
        'BFF Fitness adalah pusat kebugaran yang terletak di Jl. R. Sukamto, Palembang. Dengan jam operasional yang nyaman, gym ini menyediakan berbagai program latihan dan fasilitas untuk para anggotanya.',
    built: '2014',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '06:30 - 21:00'},
    imageAsset: 'images/boss_gym.png',
    imageUrls: [
      'images/boss_gym.png',
      'images/boss2.png',
      'images/boss4.png',
    ],
    isFavorite: false,
    rating: 4.7,
    ratingCount: 89,
  ),

  Gym(
    name: 'Brothers Gym',
    location: 'Jl. D.I. Panjaitan, Tangga Takat',
    description:
        'Brothers Gym adalah pusat kebugaran yang terletak di Jl. D.I. Panjaitan, Palembang. Dengan jam operasional yang luas, gym ini menyediakan berbagai fasilitas dan kelas latihan untuk memenuhi kebutuhan anggotanya.',
    built: '2009',
    type: 'Gym',
    schedule: {'Senin - Minggu': '07:00 – 22:00'},
    imageAsset: 'images/brothers_gym.jpeg',
    imageUrls: [
      'images/brothers_gym.jpeg',
      'images/brother2.png',
      'images/brother3.png',
    ],
    isFavorite: false,
    rating: 4.7,
    ratingCount: 72,
  ),

  Gym(
    name: 'AW GYM',
    location: 'Jl. Prajurit Nazaruddin, Sri Mulyo',
    description:
        'AW GYM adalah pusat kebugaran yang terletak di Jl. Prajurit Nazaruddin, Palembang. Dengan jam operasional yang luas, gym ini menyediakan berbagai program latihan dan fasilitas untuk anggota.',
    built: '2017',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '08:00 – 22:00'},
    imageAsset: 'images/aw_gym.jpeg',
    imageUrls: [
      'images/aw_gym.jpeg',
      'images/aw2.png',
      'images/aw3.png',
    ],
    isFavorite: false,
    rating: 4.4,
    ratingCount: 17,
  ),

  Gym(
    name: 'FIT HUB Sukamto',
    location: 'Jl. R. Sukamto No.88, 8 Ilir, Kec. Ilir Tim. II',
    description:
        'Gym populer dengan fasilitas lengkap dan area latihan luas. Banyak anggota rutin karena suasana seru dan peralatan modern.',
    built: '2022',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '06:00 - 22:00'},
    imageAsset: 'images/fithub_gym.png',
    imageUrls: [
      'images/fithub_gym.png',
      'images/fithub_gym2.png',
      'images/fithub_gym3.png',
    ],
    isFavorite: false,
    rating: 4.7,
    ratingCount: 173,
  ),

  Gym(
    name: 'D Gym Palembang',
    location: 'Jl. Tj. Barangan, RT.48/RW.10, Demang Lebar Daun, Kec. Ilir Bar',
    description:
        'Gym cozy & ramah pemula di kawasan Demang Lebar Daun dengan instruktur yang membantu.',
    built: '2019',
    type: 'Gym',
    secondaryType: 'Wellness',
    schedule: {'Senin - Minggu': '06:00 - 22:00'},
    imageAsset: 'images/dgym.png',
    imageUrls: [
      'images/dgym.png',
      'images/olahraga2.png',
      'images/olahraga6.png',
    ],
    isFavorite: false,
    rating: 4.8,
    ratingCount: 69,
  ),

  Gym(
    name: 'GoGym',
    location: 'Jl. Perintis Kemerdekaan No.1112, Duku, Kec. Ilir Tim. II',
    description:
        'Gym baru dengan ruang latihan yang luas, alat berkualitas dan fokus pada semua level latihan.',
    built: '2023',
    type: 'Gym',
    schedule: {'Senin - Minggu': '06:00 - 22:00'},
    imageAsset: 'images/GOGYM.png',
    imageUrls: [
      'images/GOGYM.png',
      'images/olahraga3.png',
      'images/gymbox4.png',
    ],
    isFavorite: false,
    rating: 4.7,
    ratingCount: 36,
  ),

  Gym(
    name: 'Power Gym',
    location: '3Q5J+VCV, Jl. Sapta Marga, Bukit Sangkal, Kec. Kalidoni',
    description:
        'Gym bersih dan terawat di area Bukit Sangkal, populer di kalangan lokal.',
    built: '2016',
    type: 'Gym',
    schedule: {'Senin - Minggu': '09:00 - 22:00'},
    imageAsset: 'images/powergym.png',
    imageUrls: [
      'images/powergym.png',
      'images/olahraga4.png',
      'images/olahraga5.png',
    ],
    isFavorite: false,
    rating: 4.7,
    ratingCount: 32,
  ),

  Gym(
    name: 'TEN FIT Palembang',
    location: 'Jl. Demang Lebar Daun No.4-7, Demang Lebar Daun, Kec. Ilir Bar',
    description:
        'Fitness center dengan fasilitas lengkap untuk kardio dan strength training.',
    built: '2018',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '08:00 - 22:00'},
    imageAsset: 'images/tenfit.png',
    imageUrls: [
      'images/tenfit.png',
      'images/tenfit2.png',
      'images/tenfit3.png',
    ],
    isFavorite: false,
    rating: 4.7,
    ratingCount: 143,
  ),

  Gym(
    name: '7 GYM & STUDIO',
    location: 'Jl. R.A. Abusamah No.05, Suka Bangun, Kec. Sukarami',
    description: 'GYM dan studio kebugaran dengan variasi kelas latihan.',
    built: '2019',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '05:00 - 23:00'},
    imageAsset: 'images/7gym.png',
    imageUrls: [
      'images/7gym.png',
      'images/olahraga2.png',
      'images/olahraga3.png',
    ],
    isFavorite: false,
    rating: 4.7,
    ratingCount: 86,
  ),

  Gym(
    name: 'LIFE STYLE UP Fitness & Aerobic',
    location: 'Jl. Sultan M. Mansyur No.11, Bukit Lama, Kec. Ilir Bar',
    description: 'Gym dengan fokus aerobik dan fun workouts.',
    built: '2017',
    type: 'Fitness',
    secondaryType: 'Aerobic',
    schedule: {'Senin - Minggu': '06:00 - 22:00'},
    imageAsset: 'images/life.png',
    imageUrls: [
      'images/life.png',
      'images/life2.png',
      'images/life3.png',
    ],
    isFavorite: false,
    rating: 4.7,
    ratingCount: 60,
  ),

  Gym(
    name: 'Solitaire Fitness Palembang',
    location: 'Jl. Veteran No.999, 9 Ilir, Kec. Ilir Tim. II',
    description: 'Fitness stylish di lokasi strategis, cocok untuk urban workout.',
    built: '2018',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '09:00 - 21:00'},
    imageAsset: 'images/solitaire.png',
    imageUrls: [
      'images/solitaire.png',
      'images/solitaire2.png',
      'images/solitaire3.png',
    ],
    isFavorite: false,
    rating: 4.8,
    ratingCount: 26,
  ),

  Gym(
    name: 'Kitafit Gym & Fitness',
    location: 'Jl. Letnan Hadin No.1731, 20 Ilir D. III, Kec. Ilir Tim. I',
    description: 'Gym dengan rating tinggi karena kebersihan, dan peralatan update.',
    built: '2020',
    type: 'Gym',
    secondaryType: 'Fitness',
    schedule: {'Senin - Minggu': '07:00 - 22:00'},
    imageAsset: 'images/kitafit.png',
    imageUrls: [
      'images/kitafit.png',
      'images/kitafit2.png',
      'images/olahraga2.png',
    ],
    isFavorite: false,
    rating: 4.9,
    ratingCount: 135,
  ),

  Gym(
    name: 'TEN GYM',
    location:
        'Jl. Jaksa Agung R. Soeprapto No.329, Kemang Manis, Kec. Ilir Bar. II',
    description: 'Gym dengan alat yang lengkap dan suasana yang nyaman.',
    built: '2018',
    type: 'Gym',
    schedule: {'Senin - Minggu': '08:00 - 22:00'},
    imageAsset: 'images/tengym.png',
    imageUrls: [
      'images/tengym.png',
      'images/tengym2.png',
      'images/olahraga6.png',
    ],
    isFavorite: false,
    rating: 4.8,
    ratingCount: 88,
  ),

  Gym(
    name: 'Svastha Gym 2 Talang Putri',
    location: 'Jl. Kapten Abdullah, Talang Putri, Kec. Plaju',
    description: 'Gym yang populer di daerah Talang Putri.',
    built: '2019',
    type: 'Gym',
    schedule: {'Senin - Minggu': '08:00 - 22:00'},
    imageAsset: 'images/svasta.png',
    imageUrls: [
      'images/svasta.png',
      'images/svasta2.png',
      'images/svasta3.png',
    ],
    isFavorite: false,
    rating: 4.6,
    ratingCount: 27,
  ),

  Gym(
    name: 'Ōkami Fitness',
    location:
        'Jl. Kolonel H. Barlian No.188 KM9, Karya Baru, Kec. Alang-Alang Lebar',
    description: 'Fitness center dengan latar jepang dan jam operasi yang besar.',
    built: '2021',
    type: 'Fitness Center',
    schedule: {'Senin - Minggu': '05:00 - 00:00'},
    imageAsset: 'images/okami.png',
    imageUrls: [
      'images/okami.png',
      'images/okami2.png',
      'images/okami3.png',
    ],
    isFavorite: false,
    rating: 4.6,
    ratingCount: 117,
  ),

  Gym(
    name: 'Loyal Fitness Indonesia',
    location: '2Q85+F52, Jl. Jend. Sudirman, 18 Ilir, Kec. Ilir Tim. I',
    description: 'Gym dan kelas grup internasional di mall IP kota Palembang.',
    built: '2022',
    type: 'Gym',
    secondaryType: 'Wellness', 
    schedule: {'Senin - Minggu': '06:00 - 22:00'},
    imageAsset: 'images/loyal.png',
    imageUrls: [
      'images/loyal.png',
      'images/loyal2.png',
      'images/olahraga3.png',
    ],
    isFavorite: false,
    rating: 5.0,
    ratingCount: 142,
  ),

  Gym(
    name: 'Aris Gym & Fitness Center',
    location: 'Jl. Sukorejo No.7/8 Blok A, 8 Ilir, Kec. Ilir Tim. II',
    description: 'Gym daerah yang bersih dan nyaman buat latihan rutin.',
    built: '2020',
    type: 'Gym',
    secondaryType: 'Fitness Center',
    schedule: {'Senin - Minggu': '07:00 - 22:00'},
    imageAsset: 'images/aris.png',
    imageUrls: [
      'images/aris.png',
      'images/olahraga2.png',
      'images/olahraga4.png',
    ],
    isFavorite: false,
    rating: 4.8,
    ratingCount: 25,
  ),

  Gym(
    name: 'HSSE Fitness Center',
    location: '2R5F+8M6, Jl. Beringin, Komperta, Kec. Plaju',
    description: 'Tempat untuk berlatih workout dan diving di daerah plaju.',
    built: '2021',
    type: 'Gym',
    secondaryType: 'Diving',
    schedule: {'Senin - Minggu': '06:00 - 22:00'},
    imageAsset: 'images/hse.png',
    imageUrls: [
      'images/hse.png',
      'images/hse2.png',
      'images/hse3.png',
    ],
    isFavorite: false,
    rating: 4.8,
    ratingCount: 12,
  ),

  Gym(
    name: 'Curves Palembang',
    location:
        'Jl. Angkatan 45 No.2126, RT.038/RW.011, Lorok Pakjo, Kec. Ilir Bar. I',
    description: 'Tempat fitness untuk para wanita dengan program kebugaran ringan.',
    built: '2019',
    type: 'Fitness Center (wanita)',
    schedule: {'Senin - Minggu': '10:00 - 19:00'},
    imageAsset: 'images/curve.png',
    imageUrls: [
      'images/curve.png',
      'images/curve2.png',
      'images/olahraga5.png',
    ],
    isFavorite: false,
    rating: 4.8,
    ratingCount: 132,
  ),
];
