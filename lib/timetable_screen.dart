import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timetable_screen/theme/app_text_styles.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  final Set<String> _playedTimes = {};

  final List<Map<String, dynamic>> schedule = [
    {
      "class": "1-сабак",
      "start": "08:00",
      "end": "08:45",
      "enterSound": "first_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "2-сабак",
      "start": "08:55",
      "end": "09:40",
      "enterSound": "second_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "3-сабак",
      "start": "09:50",
      "end": "10:35",
      "enterSound": "third_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "4-сабак",
      "start": "10:45",
      "end": "11:30",
      "enterSound": "fourth_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "5-сабак",
      "start": "11:40",
      "end": "12:25",
      "enterSound": "fifth_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "6-сабак",
      "start": "12:35",
      "end": "13:20",
      "enterSound": "sixth_lesson.mp3",
      "exitSound": "exit_last_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "1-сабак",
      "start": "13:00",
      "end": "13:45",
      "enterSound": "first_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "2-сабак",
      "start": "13:50",
      "end": "14:35",
      "enterSound": "second_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "3-сабак",
      "start": "14:40",
      "end": "15:25",
      "enterSound": "third_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "4-сабак",
      "start": "15:35",
      "end": "16:20",
      "enterSound": "fourth_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "5-сабак",
      "start": "16:25",
      "end": "17:10",
      "enterSound": "fifth_lesson.mp3",
      "exitSound": "exit_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
    {
      "class": "6-сабак",
      "start": "17:15",
      "end": "18:00",
      "enterSound": "sixth_lesson.mp3",
      "exitSound": "exit_last_lesson.mp3",
      "startController": TextEditingController(),
      "endController": TextEditingController(),
    },
  ];

  @override
  void initState() {
    super.initState();
    // Контроллерлерди баштапкы баалуулуктар менен толтуруу
    for (var item in schedule) {
      item["startController"]?.text = item["start"] as String;
      item["endController"]?.text = item["end"] as String;
    }
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
      _checkSchedule();
    });
    _checkSchedule();
  }

  DateTime _parseTime(String time) {
    final parts = time.split(":");
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  void _checkSchedule() {
    final currentTimeInMinutes = _currentTime.hour * 60 + _currentTime.minute;
    for (var schedule in schedule) {
      if (schedule["startController"]?.text.isEmpty ?? true ?? true) continue;
      final startTime = _parseTime(schedule["startController"]!.text);
      final endTime = _parseTime(schedule["endController"]!.text);
      final startTimeInMinutes = startTime.hour * 60 + startTime.minute;
      final endTimeInMinutes = endTime.hour * 60 + endTime.minute;
      if (currentTimeInMinutes >= startTimeInMinutes &&
          currentTimeInMinutes <= startTimeInMinutes + 1) {
        final key =
            "${schedule["class"]}-start-${schedule["startController"]!.text}";
        if (!_playedTimes.contains(key)) {
          _playSound(schedule["enterSound"]!);
          _playedTimes.add(key);
        }
      }
      if (currentTimeInMinutes >= endTimeInMinutes &&
          currentTimeInMinutes <= endTimeInMinutes + 1) {
        final key =
            "${schedule["class"]}-end-${schedule["endController"]!.text}";
        if (!_playedTimes.contains(key)) {
          _playSound(schedule["exitSound"]!);
          _playedTimes.add(key);
        }
      }
    }
  }

  Future<void> _playSound(String soundPath) async {
    await _audioPlayer.play(AssetSource('audio/$soundPath'));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    for (var item in schedule) {
      item["startController"]?.dispose();
      item["endController"]?.dispose();
    }
    super.dispose();
  }

  Widget _buildHeader() {
    final formattedDate = DateFormat('dd-MM-yyyy').format(_currentTime);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 50,
            fit: BoxFit.contain,
          ),
          Text('АКЫЛДУУ КОҢГУРОО', style: AppTextStyle.size40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'А. Сулайманов атындагы орто мектеби',
                style: AppTextStyle.size16W600,
              ),
              Text(formattedDate, style: AppTextStyle.size16W600),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    TextStyle? style,
    bool isHeader = false,
  }) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(
            isHeader ? 12.0 : 12.0,
          ).copyWith(top: isHeader ? 12.0 : 20.0),
          child: Text(
            text,
            style: style ?? TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTableTextField(
    TextEditingController controller, {
    String? label,
  }) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: SizedBox(
            width: 80,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              onChanged: (value) => setState(() => _checkSchedule()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableIconCell(String soundPath) {
    return TableCell(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: IconButton(
            icon: Icon(Icons.music_note, size: 28),
            onPressed: () => _playSound(soundPath),
          ),
        ),
      ),
    );
  }

  Widget _buildTimetableSection(
    String title,
    List<Map<String, dynamic>> scheduleItems,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tableWidth = screenWidth < 1004 ? screenWidth - 32 : 1004.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: tableWidth,
          color: Colors.white,
          child: Table(
            border: TableBorder.all(color: Colors.green, width: 1),
            columnWidths: {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              TableRow(
                children: [
                  _buildTableCell(
                    "Сабактардын ирети",
                    style: AppTextStyle.size20bold,
                    isHeader: true,
                  ),
                  _buildTableCell(
                    "Кирүү",
                    style: AppTextStyle.size20bold,
                    isHeader: true,
                  ),
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/images/bell.png',
                          width: 27,
                          height: 22,
                        ),
                      ),
                    ),
                  ),
                  _buildTableCell(
                    "Чыгуу",
                    style: AppTextStyle.size20bold,
                    isHeader: true,
                  ),
                  TableCell(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Image.asset(
                          'assets/images/bell.png',
                          width: 27,
                          height: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (var item in scheduleItems)
                TableRow(
                  children: [
                    _buildTableCell(item["class"] ?? ""),
                    _buildTableTextField(
                      item["startController"]!,
                      label: "Start",
                    ),
                    _buildTableIconCell(item["enterSound"]!),
                    _buildTableTextField(item["endController"]!, label: "End"),
                    _buildTableIconCell(item["exitSound"]!),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final morning = schedule.sublist(0, 6);
    final afternoon = schedule.sublist(6);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/konguroo.png"),
            fit: BoxFit.fill,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              _buildTimetableSection("Түшкө чейинки сабактар", morning),
              SizedBox(height: 20),
              _buildTimetableSection("Түштөн кийинки сабактар", afternoon),
            ],
          ),
        ),
      ),
    );
  }
}
