import 'package:flutter/material.dart';
import 'package:practice/info.dart';
import 'schedule_data.dart';
import 'package:practice/result_page.dart';
import 'package:practice/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherSelectionPage extends StatefulWidget {
  const TeacherSelectionPage({super.key});
  @override
  _TeacherSelectionPageState createState() => _TeacherSelectionPageState();
}

class _TeacherSelectionPageState extends State<TeacherSelectionPage> {
//teacher name and code...for sharedpref
  String? selectedTeacher;
  String? selectedDept;

//teacher name map for dropdown
  Map<String, String> teacherNames = {
    "MAH": "Prof. Dr. Md. Ali Hossain",
    "SUZ": "Prof. Dr. Md. Shahid Uz Zaman",
    "NIM": "Prof. Dr. Md. Nazrul Islam Mondal",
    "MRI": "Prof. Dr. Md. Rabiul Islam",
    "BA": "Prof. Dr. Boshir Ahmed",
    "RT": "Rizoan Toufiq",
    "SA": "Shyla Afroge",
    "JR": "Dr. Julia Rahman",
    "EKH": "Emrana Kabir Hashi",
    "SZM": "Sadia Zaman Mishu",
    "SeN": "Barshon Sen",
    "HsN": "S. M. Mahedy Hasan",
    "SSG": "Suhrid Shakhar Ghosh",
    "NS": "Nahin Ul Sadad",
    "MZI": "Md. Zahirul Islam",
    "MFF": "Md. Farukuzzaman Faruk",
    "MAN": "Mohiuddin Ahmed",
    "AYS": "Md. Azmain Yakin Srijon",
    "AMR": "A. F. M. Minhazur Rahman",
    "FP": "Farjana Parvin",
    "UD": "Utsha Das",
    "MSH": "Md. Sozib Hossain",
    "NOS": "Md. Nasif Osman Khansur",
    "MIT": "Md. Mazharul Islam",
    "FAR": "Md. Farhan Shakib",
  }; // Add more

//filter by teacher code,save sharedpref,schedule notification,move to other page
  void navigateToResults() async {
    if (selectedTeacher != null) {
      // Perform the search
      List<Map<String, String>> results =
          ScheduleData.searchTeacher(selectedTeacher!);

      //notification
      scheduleRoutineNotifications(results);

//shared preff
      var preff = await SharedPreferences.getInstance();
      await preff.setBool('isLogged', true);
      await preff.setString('code', selectedTeacher!);
      await preff.setString('name', teacherNames[selectedTeacher!]!);

      // Navigate to the results page with the search results
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            selectedTeacher: selectedTeacher!,
            name: teacherNames[selectedTeacher!]!,
          ),
        ),
      );
    }
  }

//schedule notification
  void scheduleRoutineNotifications(List<Map<String, String>> results) {
    DateTime now = DateTime.now();

    Map<String, List<Map<String, String>>> teacherRoutine = {};

    // Extract times from results while keeping full class details
    for (var classInfo in results) {
      String day = classInfo["day"]!;

      if (!teacherRoutine.containsKey(day)) {
        teacherRoutine[day] = [];
      }
      teacherRoutine[day]!.add(classInfo); // Store full classInfo map
    }

    // Schedule notifications based on extracted times
    teacherRoutine.forEach((day, classes) {
      int dayOffset = _calculateDayOffset(now, day);

      for (var classInfo in classes) {
        String time = classInfo["time"]!; // e.g., "8.50 am"
        List<String> parts = time.split(' ');
        String timePart = parts[0].replaceAll('.', ':');

        String amPm = parts[1].toUpperCase();

        List<String> timeParts = timePart.split(':');
        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);

        // Convert 12-hour format to 24-hour format
        if (amPm == "PM" && hour != 12) {
          hour += 12;
        }
        if (amPm == "AM" && hour == 12) {
          hour = 0;
        }

        DateTime scheduleTime = DateTime(
          now.year,
          now.month,
          now.day + dayOffset,
          hour,
          minute - 4,
        );

        if (scheduleTime.isAfter(now)) {
          int id = scheduleTime.millisecondsSinceEpoch ~/ 1000;
          String title = "Class Reminder";
          String body =
              "${classInfo['sub']}\nRoom: ${classInfo['room']}\nSec: ${classInfo['sec']}\nTime: ${classInfo['time']}";

          NotificationService().scheduleNotification(
            id: id,
            title: title,
            body: body,
            scheduleTime: scheduleTime,
          );
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Notifications scheduled for selected teacher")),
    );
  }

// Function to calculate how many days ahead the target day is
  int _calculateDayOffset(DateTime now, String targetDay) {
    Map<String, int> weekdays = {
      "Monday": DateTime.monday,
      "Tuesday": DateTime.tuesday,
      "Wednesday": DateTime.wednesday,
      "Thursday": DateTime.thursday,
      "Friday": DateTime.friday,
      "Saturday": DateTime.saturday,
      "Sunday": DateTime.sunday,
    };

    int targetWeekday = weekdays[targetDay]!;
    int todayWeekday = now.weekday;

    return (targetWeekday - todayWeekday + 7) % 7;
  }

//list of dept name
  List<String> dept = [
    'CSE',
    'EEE',
    'ECE',
    'ETE',
    'CE',
    'Arch',
    'URP',
    'BECM',
    'ME',
    'IPE',
    'MSE',
    'GCE',
    'MTE',
    'ChE',
    'Phy',
    'Chem',
    'Math',
    'Hum'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teacher's Aid",
          style: TextStyle(
              fontFamily: 'agoka', fontSize: 30, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 151, 238, 255),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/screen.jpg'),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              //title dept
              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select Department:',
                      style: TextStyle(
                          fontFamily: 'philo',
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),

              //dept dropdown
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 151, 238, 255),
                    border: Border.all(color: Colors.black, width: 2)),
                child: DropdownButton(
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    padding: EdgeInsets.all(5),
                    elevation: 3,
                    focusColor: const Color.fromARGB(255, 189, 201, 207),
                    value: selectedDept,
                    hint: Text(
                      'CSE',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    items: dept.map((dept) {
                      return DropdownMenuItem(
                        value: dept,
                        child: Text(
                          dept,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDept = value;
                      });
                    }),
              ),

              const SizedBox(
                height: 40,
              ),

              //title teacher name
              Container(
                margin: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select Teacher:',
                      style: TextStyle(
                          fontFamily: 'philo',
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              //teacher name dropdown
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 151, 238, 255),
                    border: Border.all(color: Colors.black, width: 2)),
                child: DropdownButton<String>(
                  value: selectedTeacher,
                  hint: Text("Select Teacher"),
                  items: teacherNames.entries.map((entry) {
                    return DropdownMenuItem(
                      value:
                          entry.key, // Store short name as the selected value
                      child: Text(
                        entry.value,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ), // Display full name
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTeacher =
                          value; // Stores short name when selected
                    });
                  },
                ),
              ),

              const SizedBox(
                height: 280,
              ),

              //save button
              Container(
                padding: EdgeInsets.all(35),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 250, 226, 186),
                    elevation: 5,
                  ),
                  onPressed: navigateToResults,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontFamily: 'philo',
                          fontSize: 30,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
