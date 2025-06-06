import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> popularDestinations = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPopularDestinations();
  }

  Future<void> fetchPopularDestinations() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    // Sử dụng localhost cho iOS và 10.0.2.2 cho Android
    final String baseUrl = Platform.isAndroid ? 'http://10.0.2.2:8081' : 'http://localhost:8081';
    final String apiUrl = '$baseUrl/api/places'; // Thay đổi lại endpoint để show dữ liệu
    
    print('Fetching data from: $apiUrl');

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Kết nối quá thời gian chờ');
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = json.decode(response.body);
          print('Parsed data: $data');
          
          if (data.isEmpty) {
            setState(() {
              errorMessage = 'Không có dữ liệu';
              isLoading = false;
            });
            return;
          }

          setState(() {
            popularDestinations = data;
            isLoading = false;
          });
        } catch (e) {
          print('Error parsing JSON: $e');
          setState(() {
            errorMessage = 'Lỗi xử lý dữ liệu: $e';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Lỗi server: ${response.statusCode}\n${response.body}';
          isLoading = false;
        });
      }
    } on SocketException catch (e) {
      print('Network error: $e');
      setState(() {
        errorMessage = 'Không thể kết nối đến server. Vui lòng kiểm tra lại kết nối mạng.';
        isLoading = false;
      });
    } on TimeoutException catch (e) {
      print('Timeout error: $e');
      setState(() {
        errorMessage = 'Kết nối quá thời gian chờ. Vui lòng thử lại.';
        isLoading = false;
      });
    } catch (e) {
      print('Unexpected error: $e');
      setState(() {
        errorMessage = 'Có lỗi xảy ra: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient container
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF673AB7), Color(0xFF9C27B0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Hi Guy!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Where are you going next?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 24),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search your destination',
                          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20)
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFDAB9), // Approximate light orange
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12)
                            ),
                            child: Text('Hotels'),
                          )),
                          SizedBox(width: 10),
                          Expanded(child: ElevatedButton(
                            onPressed: () {},
                             style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFB6C1), // Approximate light pink
                              foregroundColor: Colors.black87,
                               shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                               padding: EdgeInsets.symmetric(vertical: 12)
                            ),
                            child: Text('Flights'),
                          )),
                           SizedBox(width: 10),
                          Expanded(child: ElevatedButton(
                            onPressed: () {},
                             style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFE0FFFF), // Approximate light teal
                              foregroundColor: Colors.black87,
                               shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                               padding: EdgeInsets.symmetric(vertical: 12)
                            ),
                            child: Text('All'),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Destinations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (errorMessage.isNotEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red),
                          SizedBox(height: 8),
                          Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: fetchPopularDestinations,
                            child: Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.count(
                      shrinkWrap: true, // Important for nesting in SingleChildScrollView
                      physics: NeverScrollableScrollPhysics(), // Disable grid's own scrolling
                      crossAxisCount: 2, // Two columns
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.75, // Adjust aspect ratio as needed
                      children: popularDestinations.map<Widget>((destination) {
                        final String? imageUrl = destination['imageUrl'];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Stack(
                              children: [
                                // Image widget filling the entire space
                                Positioned.fill(
                                  child: imageUrl != null
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[300],
                                              child: Icon(
                                                Icons.error_outline,
                                                size: 50,
                                                color: Colors.grey[600],
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                ),
                                // Gradient Overlay filling the entire space
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Text and Rating positioned over the image
                                Positioned(
                                  bottom: 15,
                                  left: 15,
                                  right: 15,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        destination['name'] ?? 'N/A',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            destination['rating']?.toString() ?? 'N/A',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
       bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon changes to purple when active
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined), // Placeholder icon
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline), // Placeholder icon
            label: 'Bookings',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), // Placeholder icon
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.deepPurple, // Active color
        unselectedItemColor: Colors.grey, // Inactive color
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
} 