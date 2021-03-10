import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeGerador extends StatefulWidget {
  @override
  _HomeGeradorState createState() => _HomeGeradorState();
}

class _HomeGeradorState extends State<HomeGerador> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController numberController = TextEditingController();
  TextEditingController messengerController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  var maskFormatterPhone = new MaskTextInputFormatter(
      mask: "+55###########", filter: {"#": RegExp(r'[0-9]')});
  var maskFormatterMessenger =
      new MaskTextInputFormatter(mask: "", filter: {"#": RegExp(r'[0-9]')});

  var phoneNumber;
  var phoneNumberLink;
  var phoneMessenger;

  openWhatsapp() async {
    var whatsappUrl = "whatsapp://send?phone=$phoneNumber&text=$phoneMessenger";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, top: 10),
        child: ListView(
          children: [
            Expanded(
              child: Center(
                  child: Icon(
                FontAwesomeIcons.whatsappSquare,
                size: MediaQuery.of(context).size.height / 3,
                color: Colors.black,
              )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'WhatsApp Link',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            textfield(numberController, maskFormatterPhone, 'Número: ',
                'Digite o número aqui', 1, TextInputType.number),
            textfield(messengerController, maskFormatterMessenger, ' ',
                'Digite sua mensagem aqui', 4, TextInputType.text),
            button(
              'Enviar',
              () {
                if (numberController.text != '') {
                  setState(() {
                    phoneNumber = numberController.text;
                    phoneMessenger = messengerController.text;
                  });

                  openWhatsapp();

                  numberController.text = '';
                  messengerController.text = '';
                }else{
                  _onFail('Há campos em branco, por favor verifique!');
                }
                
              },
            ),
            button(
              'Gerar Link',
              () {
                if (numberController.text != '') {
                  setState(() {
                    phoneNumber = numberController.text;
                    linkController.text =
                        "https://api.whatsapp.com/send?phone=$phoneNumber";
                  });
                  alertLink();
                }else{
                  _onFail('O telefone não está preenchido. Por favor verifique.');
                }
                
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Text('by: JhonDev')],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textfield(controller, formatter, String _prefixText, String _labelText,
      int _linhas, _type) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20, left: 5, right: 5),
      child: TextField(
        inputFormatters: [formatter],
        maxLines: _linhas,
        controller: controller,
        keyboardType: _type,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12),
          prefixText: _prefixText,
          prefixStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          labelText: _labelText,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget button(String _text, onpressed) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.black,
                  Colors.grey[700],
                ],
              )),
          child: FlatButton(
            onPressed: onpressed,
            child: Text(
              _text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void alertLink() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              backgroundColor: Colors.grey[200],
              title: Text(
                "Link Whatsapp!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              content: textfield(linkController, maskFormatterMessenger, ' ',
                  'Link: ', 1, TextInputType.text),
              actions: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();

                        linkController.text = '';
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 30, 0),
                            child: Text(
                              "Voltar",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      )),
                ),
                IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: () async {
                      await FlutterClipboard.copy(linkController.text);

                      _onSuccess();

                      Navigator.of(context).pop();

                      linkController.text = '';
                    }),
              ],
            ));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          '✔ Link Copiado!',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onFail(String _text) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          _text,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
