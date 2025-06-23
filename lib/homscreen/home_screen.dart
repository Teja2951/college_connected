import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:college_connectd/cloud/api.dart';
import 'package:college_connectd/live_att_button.dart';
import 'package:college_connectd/model/user_model.dart';
import 'package:college_connectd/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
    _int();
  }

  void _int() async{
    await Api().initNotification(ref);
    print('added called');
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Routemaster.of(context).push('/oppurtunitiesEdit');
      //   },
      // ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _appbar(user!,ref,context),
                    //SizedBox(height: 10,),
                    SizedBox(height: 10,),
                    mainText(),
                    feauture1(context),
                    feauture2(context),
                    feauture3(context),
                    feauture4(context)
                  ],
                ),
              ),
            );
          }
        ),
      )
    );
  }

}


Widget feauture1(BuildContext context) {
  return FeatureTile(
  title: "ISTE Events",
  subtitle: "Discover upcoming events, workshops, and activities conducted by ISTE",
  lottieAsset: "assets/animations/onboard.json",
  tag: "EVENTS",
  gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
  onTap: () => Routemaster.of(context).push('/events'),
);
}

Widget feauture2(BuildContext context) {
return FeatureTile(
  title: "Hackathons/Internships",
  subtitle: "Get latest information of all Hackathons/Internships at one place",
  lottieAsset: "assets/animations/a_lottie.json", 
  tag: "COMPETE",
  gradientColors: [Color(0xFFf093fb), Color(0xFFf5576c)],
  onTap: () => Routemaster.of(context).push('/oppurtunies'),
);
}

Widget feauture3(BuildContext context) {
return FeatureTile(
  title: "Find your Peers", 
  subtitle: "Create your peerCard and find linkeminded peers",
  lottieAsset: "assets/animations/b_lottie.json",
  tag: "Connect", 
  gradientColors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
  onTap: () => Routemaster.of(context).push('/peers'),
);
}

Widget feauture4(BuildContext context) {
return FeatureTile(
  title: "Coding Arena", 
  subtitle: "ISTE official Codespace compete--Practice--Grow",
  lottieAsset: "assets/animations/d_lottie.json",
  tag: "Coding </>", 
  gradientColors: [Color.fromARGB(255, 12, 136, 231), Color.fromARGB(255, 148, 0, 254)],
  onTap: () {
    const snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'We are Working on it!',
                    message:
                        'Rolling out soon',

                    contentType: ContentType.success,
                  ),
                );

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);

  },
);
}

Widget mainText() {
  return Padding(
    padding: const EdgeInsets.only(right: 2),
    child: Text(
      'Learn, Explore oppurtunities, and connect with your peers!',
      style: TextStyle(
        fontSize: 18,
      ),
    ),
  );
}


class ScribbleLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height / 2);
    path.quadraticBezierTo(size.width * 0.75, 0, size.width, size.height / 2);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Widget _appbar(UserModel user,WidgetRef ref,BuildContext context) {
  final String firstName = user.name.trim().split(' ').last;
  final String formattedName = firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello,',
            style: TextStyle(
              fontSize: 28,
              color: Colors.grey[700],
            ),
          ),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  formattedName,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: CustomPaint(
                  painter: ScribbleLine(),
                  size: Size(100, 10),
                ),
              ),
            ],
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200],
            child: GestureDetector(
              onTap: () {
                Routemaster.of(context).push('/profile');
              },
              child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.photo!,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(strokeWidth: 2),
            errorWidget: (context, url, error) {
              ref.read(authControllerProvider.notifier).refreshUser();
               return Icon(Icons.error);
            }
          ),
              ),
            ),
          ),
          LiveAttendanceBadge(onTap: () {
            Routemaster.of(context).push('/liveAttendence');
          }),
        ],
      ),
    ],
  );
}
