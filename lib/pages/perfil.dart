import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:proyecto_final/Control/Singleton.dart';
import 'package:proyecto_final/Resources/user.dart';
import 'package:http/http.dart' as http;

TextEditingController _ifdc = new TextEditingController();
String _fecha = "";

class PerfilPage extends StatefulWidget {
  // final void Function() parentAction;
  final ValueChanged<String> parentAction;

  PerfilPage({Key key,this.parentAction}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  String _nom,_ape,_doc,_tel,_dir;
  FocusNode _fn,_fa,_fd,_ft,_ff,_fdir;
  ProgressDialog pr;

  @override
  void initState() { 
    super.initState();
    _fn = FocusNode();
    _fa = FocusNode();
    _fd = FocusNode();
    _ft = FocusNode();
    _ff = FocusNode();
    _fdir = FocusNode();
  }

  @override
  void dispose() { 
    _fn.dispose();
    _fa.dispose();
    _fd.dispose();
    _ft.dispose();
    _ff.dispose();
    _fdir.dispose();
    _ifdc.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(   
      textAlign: TextAlign.center,
      messageTextStyle: TextStyle(
        color: Color.fromRGBO(16,200,112,1),
      ),
      message: 'Cargando...',
      progressWidgetAlignment: Alignment.center,
      borderRadius: 10.0,
      backgroundColor: Color.fromRGBO(13, 34, 71, 1),  
      progressWidget: CircularProgressIndicator(
        backgroundColor: Color.fromRGBO(16,200,112,1),
        strokeWidth: 1,
      ),
      progress: 0.0,
      maxProgress: 1000.0,
    );

    return SingleChildScrollView(
      
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5,top: 20,left: 50,right: 50),
              child: TextField(
                keyboardAppearance: Brightness.dark,
                textInputAction: TextInputAction.next,
                focusNode: _fn,
                cursorColor: Color.fromRGBO(13, 232, 129, 1),
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                style: TextStyle(
                  color: Color.fromRGBO(13, 232, 129, 1),
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: "Nombres",
                  hintStyle: TextStyle(color: _fn.hasFocus ? Color.fromRGBO(13, 232, 129, 1) : Colors.white,fontSize: 15),
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromRGBO(13, 232, 129, 1),)
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Color.fromRGBO(13, 232, 129, 1),
                  icon: Icon(
                    Icons.account_box,
                    color: Colors.white,
                  ),
                ),
                onChanged: (String value) async {
                  setState(() {
                    this._nom=value;
                    print(this._nom);
                    // FocusScope.of(context).nextFocus();
                  });
                },
                onTap: (){
                  setState(() {
                    FocusScope.of(context).requestFocus(_fn);
                  });
                },
                onSubmitted: (value){
                  setState(() {
                    _fn.unfocus();
                    FocusScope.of(context).requestFocus(_fa);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              child: TextField(
                keyboardAppearance: Brightness.dark,
                textInputAction: TextInputAction.next,
                focusNode: _fa,
                cursorColor: Color.fromRGBO(13, 232, 129, 1),
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                style: TextStyle(
                  color: Color.fromRGBO(13, 232, 129, 1),
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  focusColor: Color.fromRGBO(13, 232, 129, 1),
                  hintText: "Apellidos",
                  hintStyle: TextStyle(color: _fa.hasFocus ? Color.fromRGBO(13, 232, 129, 1) : Colors.white,fontSize: 15),
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromRGBO(13, 232, 129, 1),)
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Color.fromRGBO(13, 232, 129, 1),
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  ),
                ),
                onChanged: (String value) async {
                  setState(() {
                    this._ape=value;
                    print(this._ape);
                  });
                },
                onTap: (){
                  setState(() {
                    FocusScope.of(context).requestFocus(_fa);
                  });
                },
                onSubmitted: (value){
                  setState(() {
                    _fa.unfocus();
                    FocusScope.of(context).requestFocus(_fd);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              child: TextField(
                keyboardAppearance: Brightness.dark,
                textInputAction: TextInputAction.next,
                focusNode: _fd,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                cursorColor: Color.fromRGBO(13, 232, 129, 1),
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Color.fromRGBO(13, 232, 129, 1),
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  focusColor: Color.fromRGBO(13, 232, 129, 1),
                  hintText: "Documento",
                  hintStyle: TextStyle(color: _fd.hasFocus ? Color.fromRGBO(13, 232, 129, 1) : Colors.white,fontSize: 15),
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromRGBO(13, 232, 129, 1),)
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Color.fromRGBO(13, 232, 129, 1),
                  icon: Icon(
                    Icons.portrait_rounded,
                    color: Colors.white,
                  ),
                ),
                onChanged: (String value) async {
                  setState(() {
                    this._doc=value;
                    print(this._doc);
                  });
                },
                onTap: (){
                  setState(() {
                    FocusScope.of(context).requestFocus(_fd);
                  });
                },
                onSubmitted: (value){
                  setState(() {
                    _fd.unfocus();
                    FocusScope.of(context).requestFocus(_ff);
                    _selectDate(context);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              child: TextField(
                textInputAction: TextInputAction.next,
                readOnly: true,
                focusNode: _ff,
                controller: _ifdc,
                enableInteractiveSelection: false,
                cursorColor: Color.fromRGBO(13, 232, 129, 1),
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.center,
                // keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Color.fromRGBO(13, 232, 129, 1),
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  focusColor: Color.fromRGBO(13, 232, 129, 1),
                  hintText: "Fecha",
                  hintStyle: TextStyle(color: _ff.hasFocus ? Color.fromRGBO(13, 232, 129, 1) : Colors.white,fontSize: 15),
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromRGBO(13, 232, 129, 1),)
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Color.fromRGBO(13, 232, 129, 1),
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                ),
                onChanged: (String value) async {
                  setState(() {
                  });
                },
                onTap: (){
                  setState(() {
                    FocusScope.of(context).requestFocus(_ff);
                    _selectDate(context);
                  });
                },
                onSubmitted: (value){
                  setState(() {
                    // _fn.unfocus();
                    FocusScope.of(context).requestFocus(_fa);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              child: TextField(
                keyboardAppearance: Brightness.dark,
                textInputAction: TextInputAction.next,
                focusNode: _ft,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                cursorColor: Color.fromRGBO(13, 232, 129, 1),
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Color.fromRGBO(13, 232, 129, 1),
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  focusColor: Color.fromRGBO(13, 232, 129, 1),
                  hintText: "Telefono",
                  hintStyle: TextStyle(color: _ft.hasFocus ? Color.fromRGBO(13, 232, 129, 1) : Colors.white,fontSize: 15),
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromRGBO(13, 232, 129, 1),)
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Color.fromRGBO(13, 232, 129, 1),
                  icon: Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                ),
                onChanged: (String value) async {
                  setState(() {
                    this._tel=value;
                    print(this._tel); 
                    print(_ifdc.text); 
                  });
                },
                onTap: (){
                  setState(() {
                    FocusScope.of(context).requestFocus(_ft);
                  });
                },
                onSubmitted: (value){
                  setState(() {
                    _ft.unfocus();
                    FocusScope.of(context).requestFocus(_fdir);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 5),
              child: TextField(
                keyboardAppearance: Brightness.dark,
                textInputAction: TextInputAction.done,
                focusNode: _fdir,
                cursorColor: Color.fromRGBO(13, 232, 129, 1),
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Color.fromRGBO(13, 232, 129, 1),
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  focusColor: Color.fromRGBO(13, 232, 129, 1),
                  hintText: "Direccion",
                  hintStyle: TextStyle(color: _fdir.hasFocus ? Color.fromRGBO(13, 232, 129, 1) : Colors.white,fontSize: 15),
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromRGBO(13, 232, 129, 1),)
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Color.fromRGBO(13, 232, 129, 1),
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
                onChanged: (String value) async {
                  setState(() {
                    this._dir=value;
                    print(this._dir);
                  });
                },
                onTap: (){
                  setState(() {
                    FocusScope.of(context).requestFocus(_fdir);
                  });
                },
                onSubmitted: (value){
                  setState(() {
                    _fdir.unfocus();
                    // FocusScope.of(context).requestFocus(_fn);
                  });
                },
              ),
            ),
            //_crearFecha(context)
            _guardarRegistro(),
          ],
        ),
      ),
    );
  }
  
  Widget _guardarRegistro() {
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 10),
        width: 170,
        height: 80,
        child: RaisedButton(
          child: Text('Guardar',style: TextStyle(fontSize: 16),),
          color: Color.fromRGBO(6,190,102,1),
          textColor: Colors.white,
          shape: StadiumBorder(),
          onPressed: () async {
            pr.show();
            Future<User> actual = peticionRegistrar();
            actual.then((a) {
              pr.hide();
              print(a.key);
              print(a.correo);
              double llave = a.key;
              if(llave==0){
                _loginBad(context);
              }else{
                Singleton control = Singleton();
                control.key=llave;
                control.estado="guardado";
                control.correoll=a.correo;
                _registroExitoso(context);
                // setState(() {
                  
                // });
              }
            });
          },
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1940),
      lastDate: new DateTime(2040),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Color.fromRGBO(13, 34, 71, 1),
            accentColor: Color.fromRGBO(13, 34, 71, 1),
            colorScheme: ColorScheme.light(
              primary: Color.fromRGBO(13, 34, 71, 1),
              background: Colors.black,
            ),
            backgroundColor: Colors.black,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fecha = formatDate(picked, [dd, '-', mm, '-', yyyy]).toString();
        _ifdc.text = _fecha;
        _ff.unfocus();
        FocusScope.of(context).requestFocus(_ft);
      });
    }
  }

  Future<User> peticionRegistrar() async{
    Singleton control = Singleton();
    final respon = await http.get('https://radiant-dusk-69671.herokuapp.com/Regisusu?nombre=${ this._nom }&apellido=${ this._ape }&documento=${ this._doc }&fecha=${ _ifdc.text }&telefono=${ this._tel }&direccion=${ this._dir }&correo=${ control.correor }&password=${ control.passwordr }');
    if(respon.statusCode==200){
      final body = jsonDecode(respon.body);
      return User.fromJson(body);
    }else{
      print('conexion con el server fallida');
      throw Exception('failed to load');
    }
  }

  void _loginBad(BuildContext context) {
    showDialog(
      // barrierColor: Colors.black,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(13, 34, 71, 1),
          title: Text(
            "Error registrando",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(16,200,112,1),
            ),
          ),
          content: Text(
            "Parece que alguno de tus datos fueron digitados de manera erronea.",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          
          actions: [
            FlatButton(
              // color: Color.fromRGBO(13, 34, 71, 1),
              onPressed: (){
                 Navigator.of(context).pop(); 

              }, 
              child: Text(
                "Volver",
                style: TextStyle(
                  color:  Color.fromRGBO(16,200,112,1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  void _registroExitoso(BuildContext context) {
    showDialog(
      // barrierColor: Colors.black,
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(13, 34, 71, 1),
          title: Text(
            "Registro completado exitosamente",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromRGBO(16,200,112,1),
            ),
          ),
          content: Text(
            "Gracias por unirte a movelo, ahora puedes ayudar al planeta con tus recorridos e ir con mas seguridad en las vias.",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          
          actions: [
            FlatButton(
              // color: Color.fromRGBO(13, 34, 71, 1),
              onPressed: (){ 
                widget.parentAction("guardado");
                Navigator.of(context).pop();
                // this.dispose();
              }, 
              child: Text(
                "Continuar",
                style: TextStyle(
                  color:  Color.fromRGBO(16,200,112,1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
