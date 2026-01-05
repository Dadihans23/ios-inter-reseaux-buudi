import 'package:flutter/material.dart';
import 'package:six_cash/util/images.dart';

class CreditCardsPage extends StatefulWidget {
  @override
  _CreditCardsPageState createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  bool _isCardNumberVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal:16 , vertical: 20 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildTitleSection(
                title: "Votre virtuel buudi",
                subTitle: "Vous pourrez faire vos differents achats avec cette carte ",
              ),
              _buildCreditCard(
                color: Color(0xFF000000),
                cardExpiration: "05/2024",
                cardHolder: "HOUSSEM SELMI",
                cardNumber: _isCardNumberVisible ? "9874 4785 XXXX 6548" : "**** **** **** ****", // Afficher le numéro de carte ou un texte de remplacement
              ),
             
            ],
          ),
          ),
Padding(
  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
  child: Container(
    color: Colors.black,
    child: Center( // Ajoutez le widget Center ici
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Ajoutez cette ligne pour centrer le contenu de la Row
        children: [
          Text(
            'voir les info',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 8), // Ajoutez un espacement entre le texte et l'icône
          IconButton(
            icon: Icon(
              _isCardNumberVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isCardNumberVisible = !_isCardNumberVisible;
              });
            },
          ),
        ],
      ),
    ),
  ),
)

           
          ],

      ),
    )
    );
  }

  // Le reste du code reste inchangé

  // Build the title section
  Column _buildTitleSection({@required title, @required subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 16.0),
          child: Text(
            '$title',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            '$subTitle',
            textAlign: TextAlign.center ,
            style: TextStyle(fontSize: 15, color: Colors.black45),
          ),
        )
      ],
    );
  }

  // Build the credit card widget
  Card _buildCreditCard({
    required Color color,
    required String cardNumber,
    required String cardHolder,
    required String cardExpiration,
  }) {
    return Card(
      elevation: 4.0,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        height: 200,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildLogosBlock(),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                '$cardNumber',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontFamily: 'CourrierPrime',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildDetailsBlock(
                  label: 'CARDHOLDER',
                  value: cardHolder,
                ),
                _buildDetailsBlock(label: 'VALID THRU', value: cardExpiration),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build the top row containing logos
  Row _buildLogosBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(
          Images.logo,
          height: 50,
          width: 18,
        ),
        Image.asset(
          Images.mastercard,
          height: 50,
          width: 25,
        ),
      ],
    );
  }

  // Build Column containing the cardholder and expiration information
  Column _buildDetailsBlock({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$value',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  
}
