import 'package:flutter/material.dart';

class Answer extends StatefulWidget {
  const Answer({super.key});

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  List<String> options = ['A', 'B', 'C', 'D'];
  String? selected;
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2.5,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemCount: options.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = options[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    NetworkImage('https://picsum.photos/200')),
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                          child: Text(
                            options[index],
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selected = options[index];
                        });
                      },
                      child: CustomPaint(
                        painter: InnerShadowPainter(selected == options[index]),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}

class InnerShadowPainter extends CustomPainter {
  final bool isSelected;

  InnerShadowPainter(this.isSelected);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isSelected ? Colors.orange.withOpacity(0.5) : Colors.transparent
      ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal, 5.0); // Increased blur for smoother shadow

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect outerRRect =
        RRect.fromRectAndRadius(rect, const Radius.circular(12));
    final RRect innerRRect = outerRRect.deflate(10);

    final Path outerPath = Path()..addRRect(outerRRect);
    final Path innerPath = Path()..addRRect(innerRRect);

    final Path combinedPath =
        Path.combine(PathOperation.difference, outerPath, innerPath);

    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
