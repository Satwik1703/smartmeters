import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/data.dart';
import 'package:smart_meter/screens/splashscreen.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 2, child: Container(),),
          (MediaQuery.of(context).size.height < 600) ? SizedBox(height: 50,) : Container(height: 0,),
          Expanded(
            flex: 8,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15, left: 15, right: 15, bottom: 15),
                    child: Column(
                      children: [
                        RawMaterialButton(
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/my_home_settings.svg', height: 50, width: 50,),
                                    SizedBox(width: 10,),
                                    Text('My Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),)
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, size: 20, color: Colors.orange,),
                              ],
                            )
                          ),
                          onPressed: (){
                            var data = Provider.of<Data>(context, listen:false).data['customerflatData'];
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(30.0),
                              ),
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return DraggableScrollableSheet(
                                  initialChildSize: 0.4, //set this as you want
                                  maxChildSize: 0.8, //set this as you want
                                  minChildSize: 0.3, //set this as you want
                                  expand: false,
                                  builder: (context, scrollController) {
                                    return Container(
                                      padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                                      child: ListView.builder(
                                        controller: scrollController,
                                        itemCount: data.length,
                                        itemBuilder: (context, index){
                                          return Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                                                child: RawMaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  onPressed: (){
                                                    Provider.of<Data>(context, listen: false).setFlatIndex(index);
                                                    Navigator.pop(context);
                                                  },
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: MediaQuery.of(context).size.height * 0.09,
                                                    child: Row(
                                                      children: [
                                                        ClipOval(
                                                          child: Material(
                                                            color: Colors.white, // button color
                                                            child: InkWell(
                                                              splashColor: Colors.red, // inkwell color
                                                              child: SizedBox(
                                                                width: 65,
                                                                height: 65,
                                                                child: Image.network('${Provider.of<Data>(context, listen: false).url}${Provider.of<Data>(context, listen: false).data['customerflatData'][index]['projectData']['image']}', fit: BoxFit.cover,),
                                                              ),
                                                              onTap: () {},
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.0,),
                                                        Expanded(
                                                          flex: 6,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              (Provider.of<Data>(context).data['customerflatData'][index]['projectData']['builderName'] != null)
                                                              ? Text("${Provider.of<Data>(context).data['customerflatData'][index]['projectData']['builderName']}", style: TextStyle(fontSize: 10.0, color: Colors.grey),) : Text(' ', style: TextStyle(fontSize: 10.0),),
                                                              AutoSizeText("${Provider.of<Data>(context).data['customerflatData'][index]['projectData']['name']}", style: TextStyle(color: Color(0xFFF77C25), fontWeight: FontWeight.bold), minFontSize: 15.0, maxLines: 1,)
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                            children: [
                                                              Text("Home", style: TextStyle(fontSize: 10.0, color: Colors.grey), textAlign: TextAlign.end,),
                                                              AutoSizeText("${Provider.of<Data>(context).data['customerflatData'][index]['blockData']['name']} ${Provider.of<Data>(context).data['customerflatData'][index]['flatData']['name']}", style: TextStyle(color: Color(0xFFF77C25), fontWeight: FontWeight.bold), maxLines: 1, minFontSize: 2, textAlign: TextAlign.end,)
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                child: Divider(
                                                  color: Colors.grey,
                                                  thickness: 0.2,
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      )
                                    );
                                  }
                                );
                              }
                            );


                          },
                        ),
                        RawMaterialButton(
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/settings.svg', height: 50, width: 50,),
                                    SizedBox(width: 10,),
                                    Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),)
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios, size: 20, color: Colors.orange,),
                              ],
                            )
                          ),
                          onPressed: () async{
                            await Provider.of<Data>(context, listen: false).logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => SplashScreen()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                        ),

                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -80.0,
                  left: 0.0,
                  right: 0.0,
                  child: SettingsCard(),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

class SettingsCard extends StatefulWidget {
  @override
  _SettingsCardState createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  var editProfile = false;
  var email = '';
  var phoneNo = '';
  var name = '';
  var nameFocus = FocusNode();
  var phFocus = FocusNode();
  var mailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    editProfile = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.of(context).size.height > 600) ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.28,
      child: Card(
        margin: EdgeInsets.only(left: 10.0, right: 10.0),
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0)
        ),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 22.0),
                child: Row(
                  children: [
                    (Provider.of<Data>(context, listen: false).data['imageUrl'] == "")
                    ? Icon(Icons.photo_album_rounded, size: MediaQuery.of(context).size.width * 0.15, color: Colors.orange,)
                    : Container(height: MediaQuery.of(context).size.width * 0.15, width: MediaQuery.of(context).size.width * 0.15, child: Image.network('${Provider.of<Data>(context, listen: false).url}/containers/project/download/${Provider.of<Data>(context, listen: false).data['imageUrl']}', fit: BoxFit.cover,)),
                    SizedBox(width: 20.0,),
                    Expanded(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3 ,
                            child:
                              (editProfile)
                              ? TextFormField(
                                autofocus: true,
                                focusNode: nameFocus,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange
                                    )
                                  ),
                                  focusColor: Colors.orange,
                                  counterText: "",
                                ),
                                cursorColor: Colors.orange,
                                maxLength: 25,
                                maxLines: 1,
                                initialValue: '${Provider.of<Data>(context).data['firstName']} ${Provider.of<Data>(context).data['lastName']}',
                                style: TextStyle(fontSize: 20.0, ),
                                onChanged: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                                onFieldSubmitted: (value){
                                  FocusScope.of(context).requestFocus(phFocus);
                                },
                              )
                              : AutoSizeText('${Provider.of<Data>(context).data['firstName']} ${Provider.of<Data>(context).data['lastName']}', minFontSize: 15.0, maxLines: 1, style: TextStyle(fontWeight: FontWeight.bold),)),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Icon(Icons.phone, color: Colors.orange, size: 15.0,),
                                SizedBox(width: 15.0,),
                                (editProfile)
                                ? Expanded(
                                  child: TextFormField(
                                    focusNode: phFocus,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.orange
                                        )
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.orange
                                        )
                                      ),
                                      focusColor: Colors.orange,
                                      counterText: "",
                                    ),
                                    cursorColor: Colors.orange,
                                    maxLength: 25,
                                    maxLines: 1,
                                    initialValue: '${Provider.of<Data>(context).data['mobileNo']}',
                                    style: TextStyle(fontSize: 13.0, ),
                                    onChanged: (value) {
                                      setState(() {
                                        phoneNo = value;
                                      });
                                    },
                                    onFieldSubmitted: (value){
                                      FocusScope.of(context).requestFocus(mailFocus);
                                    },
                                  ),
                                )
                                : Expanded(child: AutoSizeText('+91 ${Provider.of<Data>(context).data['mobileNo']}', maxLines: 1, minFontSize: 2,)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Icon(Icons.email_outlined, color: Colors.orange, size: 15.0,),
                                SizedBox(width: 15.0,),
                                (editProfile)
                                ? Expanded(
                                  child: TextFormField(
                                    focusNode: mailFocus,
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.orange
                                        )
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.orange
                                        )
                                      ),
                                      focusColor: Colors.orange,
                                      counterText: "",
                                    ),
                                    cursorColor: Colors.orange,
                                    maxLength: 25,
                                    maxLines: 1,
                                    initialValue: '${Provider.of<Data>(context).data['email']}',
                                    style: TextStyle(fontSize: 13.0, ),
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },
                                    onFieldSubmitted: (value){
                                      FocusScope.of(context).requestFocus(nameFocus);
                                    },
                                  ),
                                )
                                : Expanded(child: AutoSizeText('${Provider.of<Data>(context).data['email']}', maxLines: 1, minFontSize: 2,)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                color: Color.fromRGBO(247, 124, 37, 0.1),
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: AutoSizeText('Member since ', maxLines: 1, minFontSize: 2,),
                    ),
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async{
                          if(!editProfile){
                            setState(() {
                              editProfile = true;
                            });
                          }
                          else{
                            await Provider.of<Data>(context, listen: false).editProfile(name, phoneNo, email);
                            setState(() {
                              editProfile = false;
                            });
                          }
                        },
                        child: AutoSizeText((editProfile) ? 'Confirm' : 'Edit Profile', style: TextStyle(color: Color(0xFFF77C25)), maxLines: 1, minFontSize: 10.0, textAlign: TextAlign.end,),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

