import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayer_time_class.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  PrayerTime time = PrayerTime();
  String city = "karachi";
  var cityTextFieldControler = TextEditingController();

  @override
  void initState() {
    getPrayerTime();
    super.initState();
  }

  Future<void> getPrayerTime() async {
    http.Response response = await http
        .get(Uri.parse("https://dailyprayer.abdulrcs.repl.co/api/$city"));
    print(response.statusCode);
    print(response.body);

    setState(() {
      time = PrayerTime.fromJson(jsonDecode(response.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg.png"), fit: BoxFit.fill)),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 50,
          ),
          TextField(
              controller: cityTextFieldControler,
              cursorColor: Colors.white,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                  suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          city = cityTextFieldControler.text;
                          getPrayerTime();
                          cityTextFieldControler.clear();
                        });
                      },
                      icon: const Icon(Icons.send, color: Colors.white)),
                  hintText: "Search for the city...",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15))))),
          Text(
            time.city == null ? "Lodaing" : "${time.city}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            time.date == null ? "Lodaing" : "${time.city}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          _timeCard("Fajr",
              time.today?.fajr == null ? "Lodaing" : "${time.today?.fajr}"),
          _timeCard(
              "Sunrise",
              time.today?.sunrise == null
                  ? "Lodaing"
                  : "${time.today?.sunrise}"),
          _timeCard("Dhuhr",
              time.today?.dhuhr == null ? "Lodaing" : "${time.today?.dhuhr}"),
          _timeCard("Asr",
              time.today?.asr == null ? "Lodaing" : "${time.today?.asr}"),
          _timeCard(
              "Maghrib",
              time.today?.maghrib == null
                  ? "Lodaing"
                  : "${time.today?.maghrib}"),
          _timeCard("Ishak",
              time.today?.ishaA == null ? "Lodaing" : "${time.today?.ishaA}"),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Widget _timeCard(String name, String time) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.4)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 25,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ]),
    );
  }
}
