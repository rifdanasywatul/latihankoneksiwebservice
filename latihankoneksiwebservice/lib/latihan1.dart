// Mengimpor pustaka 'dart:convert' untuk memungkinkan pengkodean dan dekodean data JSON.
import 'dart:convert';

void main() {
  // String yang berisi data JSON yang direpresentasikan sebagai string multi-line.
  String jsonString = '''
  {
    "mahasiswa": {
      "nama": "Gina Wijayanti",
      "nim": "12345678",
      "prodi": "Manajemen Informatika",
      "universitas": "Universitas Kebangkitan"
    },
    "transkrip": [
      {
        "kode_matkul": "KM101",
        "matkul": "Pengembangan Software",
        "sks": 3,
        "nilai": "A-"
      },
      {
        "kode_matkul": "KM102",
        "matkul": "Perancangan Sistem Informasi",
        "sks": 3,
        "nilai": "B+"
      },
      {
        "kode_matkul": "KM103",
        "matkul": "Jaringan Komputer",
        "sks": 3,
        "nilai": "B+"
      },
      {
        "kode_matkul": "KM104",
        "matkul": "Technopreneurship",
        "sks": 2,
        "nilai": "A"
      }
    ]
  }
  ''';

  // Konversi data JSON yang tersimpan dalam variabel 'jsonString'
  // menjadi sebuah objek Map yang dapat diakses dengan kunci String
  // dan berisi nilai dinamis.
  Map<String, dynamic> parsedJson = jsonDecode(jsonString);

  // Mengakses daftar transkrip dari objek Map 'parsedJson'
  List<dynamic> transkrip = parsedJson['transkrip'];

  // Deklarasi variabel untuk menyimpan jumlah nilai dan jumlah sks
  double jumlahNilai = 0.0;
  int totalSks = 0;

  // Fungsi ini mengonversi nilai huruf menjadi nilai numerik sesuai skala IP
  double nilaiKeAngka(String nilai) {
    // Menggunakan struktur switch untuk mengonversi nilai huruf ke nilai numerik
    switch (nilai) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      default:
        return 0.0; // untuk nilai yang tidak dikenal atau gagal
    }
  }

  // Menghitung total SKS dan jumlah nilai berdasarkan transkrip mata kuliah
  for (var mataKuliah in transkrip) {
    // Mengambil jumlah SKS dan nilai dari setiap mata kuliah dalam transkrip
    int sks = mataKuliah['sks'];
    String nilai = mataKuliah['nilai'];
    // Menambahkan jumlah SKS ke totalSks dan menghitung jumlah nilai berdasarkan sks
    totalSks += sks;
    jumlahNilai += nilaiKeAngka(nilai) * sks;
  }

  // Menghitung IPK dengan membagi jumlah nilai dengan total SKS
  double ipk = jumlahNilai / totalSks;

  // Mencetak nilai IPK dari mahasiswa
  print(
      "IPK dari ${parsedJson['mahasiswa']['nama']} saat ini adalah ${ipk.toStringAsFixed(2)}");
}