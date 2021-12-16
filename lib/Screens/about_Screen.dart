import 'package:autoparts/widgets/simpleAppbar.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(false, "About"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleBody(
              title: "Developers",
            ),
            DeveloperCard(
              image:
                  "https://avatars.githubusercontent.com/u/75200754?s=460&u=9157b54be58ebe2d4e91c3d9be6f1f3aaaeea35f&v=4",
              title: "Saikat Rahman",
              subtitle: "Software Engineer\nID: 171-15-9504",
            ),
            DeveloperCard(
              image:
                  "https://pmiscse.daffodilvarsity.edu.bd/api/media/uDrive/171-15-9513/74250052543465_1161880200641454_7466280295923187712_n_150x150.jpg",
              title: "Biprojit Saha",
              subtitle: "Software Engineer\nID: 171-15-9513",
            ),
            DeveloperCard(
              image:
                  "https://pmiscse.daffodilvarsity.edu.bd/api/media/uDrive/171-15-9537/599931_150x150.jpg",
              title: "Md. Islam Khan",
              subtitle: "Software Engineer\nID: 171-15-9537",
            ),
            TitleBody(
              title: "Supervisors",
            ),
            DeveloperCard(
              image:
                  "https://pmiscse.daffodilvarsity.edu.bd/api/media/uDrive/710001287/375453rsz_81379887_10221185451250556_9058672066961604608_o_150x150.jpg",
              title: "Raja Tariqul Hasan Tusher",
              subtitle: "Sr. Lecturer\nComputer Science & Engineering",
            ),
            TitleBody(
              title: "Co-Supervisors",
            ),
            DeveloperCard(
              image:
                  "https://pmiscse.daffodilvarsity.edu.bd/api/media/uDrive/710002096/680404Pic_Abdus_Sattar_150x150.jpg",
              title: "Mr. Abdus Sattar",
              subtitle: "Assistant Professor\nComputer Science & Engineering",
            ),
          ],
        ),
      ),
    );
  }
}

class TitleBody extends StatelessWidget {
  const TitleBody({
    @required this.title,
    Key key,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          letterSpacing: 0.5,
          fontFamily: "Brand-Regular",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DeveloperCard extends StatelessWidget {
  const DeveloperCard({
    @required this.image,
    @required this.title,
    @required this.subtitle,
    Key key,
  }) : super(key: key);
  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 0.5,
                fontFamily: "Brand-Regular",
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 0.5,
                fontFamily: "Brand-Regular",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
