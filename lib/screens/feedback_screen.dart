import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'camera_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/review_provider.dart';
import '../widgets/app_bar_widget.dart';

class FeedbackScreen extends StatefulWidget {
  final String orderId;

  const FeedbackScreen({super.key, required this.orderId});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  String? _imagePath;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<String> _convertImageToBase64(String imagePath) async {
    final file = File(imagePath);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> _submitFeedback(BuildContext context) async {
    if (_rating == 0 || _commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please complete the rating and comment.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You need to be logged in to submit feedback.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      String? base64Image;
      if (_imagePath != null) {
        base64Image = await _convertImageToBase64(_imagePath!);
      }

      await Provider.of<ReviewProvider>(context, listen: false).submitFeedback(
        orderId: widget.orderId,
        rating: _rating,
        comment: _commentController.text,
        imagePath: base64Image,
        userId: user.uid,
        context: context,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );

      Navigator.of(context).pushNamedAndRemoveUntil('/menu', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to submit feedback. Please try again.')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFE6D4AA),
        appBar: const CustomAppBar(
          titleText: 'Rate Delivery',
          actions: [],
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rate your delivery:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Center(
                child: RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) => setState(() => _rating = rating),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Leave a comment:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter your comment about the delivery...',
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xBA443015),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text('Open Camera',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                  onPressed: () async {
                    final capturedImagePath = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CameraScreen(camera: firstCamera!)),
                    );

                    if (capturedImagePath != null) {
                      setState(() {
                        _imagePath = capturedImagePath;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (_imagePath != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        Image.file(File(_imagePath!), width: 300, height: 300),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xBA443015),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed:
                      _isSubmitting ? null : () => _submitFeedback(context),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Submit Feedback',
                          style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
