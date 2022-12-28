import 'package:flutter/material.dart';
import 'package:task_app/inner_screens/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class AllWorkersWidget extends StatefulWidget {
  final String userID;
  final String userName;
  final String userEmail;
  final String position;
  final String userImageUrl;
  final String phoneNumber;

  const AllWorkersWidget({
    super.key,
    required this.userID,
    required this.userName,
    required this.userEmail,
    required this.position,
    required this.userImageUrl,
    required this.phoneNumber,
  });

  @override
  State<AllWorkersWidget> createState() => _AllWorkersWidgetState();
}

class _AllWorkersWidgetState extends State<AllWorkersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfileScreen(userID: widget.userID),
            ),
          );
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius:
                20, // https://cdn-icons-png.flaticon.com/512/4140/4140047.png
            child: Image.network(
              widget.userImageUrl == null
                  ? 'https://cdn-icons-png.flaticon.com/512/4140/4140074.png'
                  : widget.userImageUrl,
            ),
          ),
        ),
        title: Text(
          widget.userName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.pink.shade800,
            ),
            Text(
              '${widget.position}/${widget.phoneNumber}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            _mailTo();
          },
          icon: const Icon(
            Icons.mail_outlined,
            size: 30,
          ),
          color: Colors.pink.shade800,
        ),
      ),
    );
  }

  Future _mailTo() async {
    // print('widget.userEmail:${widget.userEmail}');
    var url = Uri.parse('mailto:${widget.userEmail}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'we face an issue';
    }
  }
}
