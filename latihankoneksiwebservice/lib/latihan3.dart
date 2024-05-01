import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class University {
  // Deklarasi variabel
  final String name;
  final String website;

  University({required this.name, required this.website}); //constructor

  // Factory method untuk membuat objek University dari data JSON
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'][0],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Method build digunakan untuk membuat tampilan aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          // Judul AppBar
          title: const Text('Daftar Universitas di Indonesia'),
        ),
        // Menampilkan daftar universitas
        body: const UniversityList(),
      ),
    );
  }
}

class UniversityList extends StatefulWidget {
  // Constructor untuk membuat instance dari UniversityList
  const UniversityList({Key? key}) : super(key: key);

  // Method createState digunakan untuk membuat dan mengembalikan instance dari _UniversityListState
  @override
  _UniversityListState createState() => _UniversityListState();
}

class _UniversityListState extends State<UniversityList> {
  late Future<List<University>> futureUniversities;

  // Method initState dipanggil saat state pertama kali diinisialisasi
  @override
  void initState() {
    super.initState();
    futureUniversities = fetchUniversities(); // Memuat data universitas saat inisialisasi state
  }

  Future<List<University>> fetchUniversities() async {
    // Mengirimkan permintaan HTTP untuk mendapatkan data universitas
    final response = await http.get(Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'));
    if (response.statusCode == 200) {
      // Jika permintaan berhasil, data JSON diuraikan dan diubah menjadi daftar objek University
      List<dynamic> data = jsonDecode(response.body);
      List<University> universities = [];
      for (var item in data) {
        universities.add(University.fromJson(item));
      }
      return universities; // Mengembalikan daftar universitas
    } else { // Jika permintaan gagal, muncul pesan
      throw Exception('Failed to load universities');
    }
  }

  // Method build digunakan untuk membuat tampilan daftar universitas
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<University>>(
      future: futureUniversities,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(), // Tampilkan indikator loading saat data sedang dimuat
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'), // Tampilkan pesan kesalahan jika terjadi
          );
        } else {
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(); // Menambah garis pemisah di antara setiap item.
            },
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  snapshot.data![index].name,
                  textAlign: TextAlign.center, // Menampilkan teks di tengah.
                ),
                subtitle: InkWell(
                  child: Text(
                    snapshot.data![index].website,
                    textAlign: TextAlign.center, // Menampilkan teks di tengah.
                    style: TextStyle(
                      decoration: TextDecoration.underline, // Membuat teks menjadi underlined.
                      color: Colors.blue, // Mengubah warna teks menjadi biru untuk menunjukkan tautan.
                    ),
                  ),
                  onTap: () async {
                    final url = snapshot.data![index].website;
                    if (await canLaunch(url)) {
                      await launch(url); // Buka URL ketika teks diklik
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
