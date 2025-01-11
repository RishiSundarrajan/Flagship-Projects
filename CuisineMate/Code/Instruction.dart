import 'package:flutter/material.dart';

class IN extends StatefulWidget {
  const IN({super.key});

  @override
  State<IN> createState() => _INState();
}

class _INState extends State<IN> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Use the App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                'Welcome to the CuisineMate!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'This app allows you to create, manage, and view categories for your platform. Whether you\'re adding a new category, uploading images, or managing your cuisine and subcategory lists, this app has got you covered. Here\'s how to use it:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Getting Started section
              Text(
                'Getting Started:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Create a Category:\n'
                    '- Title: Enter a title for the new category.\n'
                    '- Image Upload: Tap on the image area to upload an image from your gallery. This will represent the category visually.\n'
                    '- Cuisines: Select the cuisines relevant to the category from the available options. You can also add new cuisines if needed.\n'
                    '- Subcategories: Select the subcategories for the category. You can add new subcategories as well.\n\n'
                    'Once you\'ve filled in all the details and uploaded an image, click **Submit Category** to save it.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Adding new cuisines and subcategories section
              Text(
                'Adding New Cuisines and Subcategories:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Add a Cuisine: If the cuisine you want isn’t listed, you can add it by typing it into the "Add Cuisine" field and clicking the add icon (+).\n'
                    '- Add a Subcategory: Similarly, if your subcategory is missing, type it into the "Add Subcategory" field and click the add icon (+).',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Viewing categories section
              Text(
                'Viewing Existing Categories:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'After submitting your category, it will appear under the **Existing Categories** section. You can view details about each category, including the image, title, selected cuisines, and subcategories.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Managing categories section
              Text(
                'Managing Categories:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Delete a Category: If you wish to delete a category, simply click the trash icon next to the category. This will remove the category from the app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Important Notes section
              Text(
                'Important Notes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- Required Fields: Ensure that all required fields (title, image, and at least one cuisine and subcategory) are filled before submitting.\n'
                    '- Image Upload: The image upload feature is optional, but it\'s highly recommended to represent the category visually.\n'
                    '- Cuisines & Subcategories: You must select at least one cuisine and one subcategory when creating a category.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Troubleshooting section
              Text(
                'Troubleshooting:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '- If you face any issues while uploading an image, make sure you have the necessary permissions for accessing your gallery.\n'
                    '- Ensure that your device is connected to the internet for saving changes to the app\'s data.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Need help section
              Text(
                'Need Help?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'If you need further assistance or have any questions, feel free to reach out to our support team.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5,),
              Column(
                children: [
                  Row(
                    children: [
                      Text("Contact: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("rishivignesh03@gmail.com", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}




