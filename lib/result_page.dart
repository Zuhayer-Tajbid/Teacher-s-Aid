import 'package:flutter/material.dart';
import 'package:practice/info.dart';
import 'package:practice/schedule_data.dart';
import 'package:practice/teacher_selection.dart';

class ResultsPage extends StatefulWidget {
  // final List<Map<String, String>> results;
  final String name;
  final String selectedTeacher;

  const ResultsPage(
      {super.key, required this.selectedTeacher, required this.name});

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Map<String, String>> results = [];

  @override
  void initState() {
    super.initState();
    filterByname();
  }

  void filterByname() {
    results = ScheduleData.searchTeacher(widget.selectedTeacher!);
  }

  List<Map<String, String>> filteredResults = [];
  String? selectedDay = '';

//timeslots for card routine
  List<String> fixedTimeSlots = [
    "8.00 am",
    "8.50 am",
    "9.40 am",
    "10.50 am",
    "11.40 am",
    "12.30 pm",
    "2.30 pm",
    "3.20 pm",
    "4.10 pm"
  ];

//filter routine show for day
  void filterByDay(String day) {
    setState(() {
      selectedDay = day;
      filteredResults =
          results.where((classInfo) => classInfo["day"] == day).toList();
    });
  }

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

        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeacherSelectionPage(),
                  ));
            },
            icon: Icon(Icons.arrow_back)),
        //info button
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Info(),
                    ));
              },
              icon: Icon(Icons.info_outline)),
        ],
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
                height: 10,
              ),

              //teacher name show text
              Text(
                'Welcome\n${widget.name}',
                style: TextStyle(
                    fontFamily: 'stn',
                    fontSize: 23,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: 30,
              ),

              //day button
              Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                runSpacing: 8,
                children: [
                  "Saturday",
                  "Sunday",
                  "Monday",
                  "Tuesday",
                  "Wednesday"
                ].map((day) {
                  return Container(
                    width: 170,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 151, 238, 255),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => filterByDay(day),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          day,
                          style: TextStyle(
                              fontFamily: 'philo',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(
                height: 40,
              ),

              //selected day show
              Text(
                selectedDay!,
                style: TextStyle(
                  fontFamily: 'sauda',
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              //card routine show
              Expanded(
                child: ListView.builder(
                  itemCount: fixedTimeSlots.length,
                  itemBuilder: (context, index) {
                    String currentTime = fixedTimeSlots[index];

                    // Check if a class exists for the current time slot
                    var matchingClass = filteredResults.firstWhere(
                      (classInfo) => classInfo["time"] == currentTime,
                      orElse: () => {}, // Returns empty map if no class found
                    );

                    // Show empty tile if no class exists
                    if (matchingClass.isEmpty) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Card(
                          color: const Color.fromARGB(255, 242, 241, 241),
                          child: ListTile(
                            leading: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            title: Text(
                              "No class",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(""),
                            trailing: Text(""),
                          ),
                        ),
                      );
                    }

                    // Show class details if a class exists
                    return Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Card(
                        color: const Color.fromARGB(255, 151, 238, 255),
                        child: ListTile(
                          leading: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          title: Text(
                            "${matchingClass['sub']} (${matchingClass['time']})",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${matchingClass['year']} - Section ${matchingClass['sec']}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Text(
                            "Room: ${matchingClass['room']}",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
