import 'package:flutter/material.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Partners',
            style: TextStyle(
              color: Color.fromRGBO(143, 150, 158, 1),
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'default',
            ),
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('Assets/Images/Itpec.png'),
              width: 100,
              height: 100,
            ),
            SizedBox(
              width: 20,
            ),
            Image(
              image: AssetImage('Assets/Images/Jica.png'),
              width: 70,
              height: 70,
            ),
          ],
        )
      ],
    );
  }
}
