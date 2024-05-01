import 'package:flutter/material.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

// menampung data hasil pemanggilan API
class Activity {
  // Deklarasi variabel
  String aktivitas;
  String jenis;

  Activity({required this.aktivitas, required this.jenis}); //constructor

  //map dari json ke atribut
  // Factory method untuk membuat objek Activity dari JSON.
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      aktivitas: json['activity'],
      jenis: json['type'],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // Method createState() digunakan untuk membuat dan mengembalikan instance dari MyAppState
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  late Future<Activity> futureActivity; //menampung hasil

  //late Future<Activity>? futureActivity;
  String url = "https://www.boredapi.com/api/activity";

  // Fungsi init() digunakan untuk menginisialisasi Future yang akan mengembalikan objek Activity kosong
  Future<Activity> init() async {
    return Activity(aktivitas: "", jenis: "");
  }

  //fetch data
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // jika server mengembalikan 200 OK (berhasil),
      // parse json
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      // jika gagal (bukan  200 OK),
      // lempar exception
      throw Exception('Gagal load');
    }
  }

  // Method initState dipanggil saat widget pertama kali diinisialisasi
  @override
  void initState() {
    super.initState();
    futureActivity = init(); // Menginisialisasi futureActivity dengan nilai default
  }

  // Method build digunakan untuk membangun tampilan aplikasi
  @override
  Widget build(Object context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData();
                });
              },
              child: Text("Saya bosan ..."),
            ),
          ),
          FutureBuilder<Activity>(
            future: futureActivity,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(snapshot.data!.aktivitas),
                      Text("Jenis: ${snapshot.data!.jenis}")
                    ]));
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // Tampilkan indikator loading ketika data sedang dimuat
              return const CircularProgressIndicator();
            },
          ),
        ]),
      ),
    ));
  }
}