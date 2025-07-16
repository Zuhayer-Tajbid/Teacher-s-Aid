import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({super.key});

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
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image/screen.jpg'),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),

              //headline text
              Text(
                'About App',
                style: TextStyle(
                  fontFamily: 'sauda',
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              //logo
              Image.asset(
                'assets/image/logo.png',
                height: 300,
              ),

              //description
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  'The "Teacher’s Aid" app is a practical and impactful solution for managing teaching schedules effectively. With its intuitive design, robust functionality, and direct relevance to educators, the app has the potential to make a meaningful difference in the teaching community. ',
                  style: TextStyle(
                      fontFamily: 'philo',
                      color: Colors.black,
                      wordSpacing: 5,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //subject name
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  color: const Color.fromARGB(255, 255, 193, 113),
                  child: ListTile(
                    leading: Icon(Icons.laptop_chromebook),
                    title: Text(
                      'CSE 2100',
                      style: TextStyle(
                          fontFamily: 'stin',
                          fontSize: 15,
                          color: const Color.fromARGB(255, 15, 34, 142),
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Software Development Project 1',
                      style: TextStyle(
                        fontFamily: 'transformer',
                        fontSize: 25,
                        color: Colors.black,
                        //fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //submitted from
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  color: const Color.fromARGB(255, 151, 238, 255),
                  child: ListTile(
                      leading: Icon(Icons.account_circle_rounded),
                      title: Text(
                        'Submitted From:',
                        style: TextStyle(
                            fontFamily: 'stin',
                            fontSize: 15,
                            color: const Color.fromARGB(255, 15, 34, 142),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Zuhayer Tajbid',
                            style: TextStyle(
                              fontFamily: 'transformer',
                              fontSize: 30,
                              color: Colors.black,
                              //fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Roll: 2203015',
                            style: TextStyle(
                              fontFamily: 'transformer',
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //submitted to
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Card(
                  color: const Color.fromARGB(255, 248, 188, 255),
                  child: ListTile(
                      leading: Icon(Icons.account_circle_rounded),
                      title: Text(
                        'Submitted To:',
                        style: TextStyle(
                            fontFamily: 'stin',
                            fontSize: 15,
                            color: const Color.fromARGB(255, 15, 34, 142),
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Md. Farukuzzaman Faruk',
                            style: TextStyle(
                              fontFamily: 'transformer',
                              fontSize: 25,
                              color: Colors.black,
                              //fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Assistant Professor',
                            style: TextStyle(
                              fontFamily: 'transformer',
                              fontSize: 18,
                              color: Colors.black,
                              //fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Dept of CSE, RUET',
                            style: TextStyle(
                              fontFamily: 'transformer',
                              fontSize: 18,
                              color: Colors.black,
                              //fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
