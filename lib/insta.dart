import 'package:flutter/material.dart';

class Instagram extends StatelessWidget {
  const Instagram({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        leading: const Icon(Icons.add, color: Colors.black),
        title: const Text(
          'instagram',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.favorite_border, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < 16; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: i == 0
                          ? Stack(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                    'assets/images/profile1.png',
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                'assets/images/post.jpg',
                              ),
                            ),
                    ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage('assets/images/profile1.png'),
                ),
                SizedBox(width: 5),
                Text(
                  'momen Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          Container(
            height: 200,
            width: double.infinity,
            child: Image.asset('assets/images/profile1.png', fit: BoxFit.cover),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: const [
                Icon(Icons.favorite_border),
                SizedBox(width: 15),
                Icon(Icons.chat_bubble_outline),
                SizedBox(width: 15),
                Icon(Icons.send_outlined),
                Spacer(),
                Icon(Icons.bookmark_border),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
