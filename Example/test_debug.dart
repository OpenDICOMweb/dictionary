import 'package:test/test.dart';
import 'package:dictionary/src/vr/vr.dart';
import 'package:test/test.dart';
import 'package:dictionary/src/person_name.dart';
import 'package:dictionary/src/uid/well_known/transfer_syntax.dart';
import 'package:dictionary/src/uid/well_known/wk_uid.dart';
import 'package:dictionary/dictionary.dart';
import 'package:dictionary/src/vr/string.dart';
import 'package:dictionary/src/vr/integer.dart';
void main(){
  //validateTest();
  //privatedatatag();
  //testPerson();
  uidtest();
 }

/*
void validateTest(){

  String str = "DART";
  String str1 = "dartDD434 ";
  String str2 = "0123456789";
  String str3 = "DDD_545 ";

  print(VR.kCS.isValidValue(str));

}
void privatedatatag()
{
  int code=0x00190010;
  PrivateDataTag pdt=new PrivateDataTag.unknown(code);
  print(pdt.toString());
}*/

void testPerson(){
  print(PersonName.isValidString("goodday"));
  //print(PersonName.isValidList(["anc","xya","ert"]));
}

void uidtest() {
 /* Uid uid = Uid.parse("1.2.840.10008.1.2");
  print(uid);
  print(uid == WKUid.kImplicitVRLittleEndian);
  print(uid.asString=="1.2.840.10008.1.2");
  //expect(uid.asString, equals("1.2.840.10008.1.2"));
  uid = Uid.parse("1.2.840.10008.1.2.1");
  print(uid == WKUid.kExplicitVRLittleEndian);*/

  /* Uid uid = Uid.parse("1.2.8z0.10008.1.2");
  print(uid == null);
  //TODO: this should return null or
  uid = Uid.parse("4.2.840.10008.1.2");
  print('uid: $uid');
  print(uid == null);
}// skip: "TODO: fix Uid.parse to detect bad values");*/

  //Uid uid = TransferSyntax.lookup("1.2.840.10008.1.2");
  //print(uid == TransferSyntax.kImplicitVRLittleEndian);

  //print(Uid.isValid("1.2.840.10008.1.2"));//true
  //print(Uid.isValid("1.2.t40.10008.1.2"));//false

  //print(Uid.validate("1.2.840.10008.1.2"));

  //print(Uid.check("1.2.840.10008.1.2"));

  //print(Uid.lookup("1.2.840.10008.1.2.4.61"));

  //print(Uid.randomList(3));

   //print(Uid.validateStrings(["1.2.840.10008.1.2.4.61","1.2.840.10008.1.2"]));//true
   //print(Uid.validateStrings(["1.2.840.10008.1.2.4.61","y.2.840.10008.1.2"]));//false

    //print(Uid.validate("1.2.840.10008.1.2.4.61"));

  //print(Uid.validRoot("1.2.840.10008.1.2.4.61"));

  /*var uidstring=new UidString("1.2.840.10008.1.2.4.61");
  print(uidstring.asString);
  print(uidstring.isWellKnown);
  uidstring.isEncapsulated;*/

 /* WKUid uids=new WKUid("1.2.840.10008.1.2.4.61",UidType.kApplicationContextName,false,"Application Context Name");
  print(uids.toString());
  print(uids.asString);
  print(uids.isRetired);
  print(uids.type);
  print(uids.name);
  print(uids.isNotRetired);
  print(uids.info);
  print(uids.isWellKnown);
  print(uids.runtimeType);
  print(uids.isTransferSyntax);
  print(uids.isSOPClass);
  print(uids.hashCode);
  print(uids.isFrameOfReference);
  print(uids.isMetaSOPClass);
  print(uids.isEncapsulated);
  print(uids.isCodingScheme);*/

 /*var uiduids=UidUuid.uidRoot;
 var string = 'dartlang';
 var string1='  dart lang  ';
       string.substring(1);    // 'artlang'
       string.substring(1, 4); // 'art'
  print(string.substring(2,4));//rt
  print(string.toUpperCase());//DARTLANG
  print(string.indexOf('g'));//7
  print(string.contains('lang'));//true
  print(string.lastIndexOf('a')); //5
  print(string.codeUnitAt(0));//100
  print(string.length);// 8
  print(string.split('lang'));// [dart, ]
  print(string.startsWith('d'));// true
  print(string.endsWith('g'));// true
  print(string.replaceAll('lang',"language")); //dartlanguage
  print(string.toLowerCase());//dartlang
  print(string.isEmpty);// false
  print(string1.trim().toString());//dart lang
  print(string.codeUnits);//[100, 97, 114, 116, 108, 97, 110, 103]
  print(string.replaceFirst('d','c'));//cartlang
  print(string.padLeft(9));//  dartlang
  print(string.padRight(5));//padding right
  print(string.runes);//(100, 97, 114, 116, 108, 97, 110, 103)
  print(string1.trimLeft());//remove the spaces from leftside
  print(string1.trimRight());//remove the spaces from rightside
  print(string.compareTo("dartlangs"));//if given string is same then, compareTo returns '0' other wiese returns '-1'
  print(string.replaceRange(0,4,'abc'));//abclang (it repalce a range of the string and and new string)
  //print(string.replaceAllMapped(5));
  print(string.allMatches("dartlang"));//given string match with allmathches string then it show the result otherwise retult empty.
*/
  //print(VR.kFD.hasShortVF);
  //print(VR.kFD.hasLongVF);
 // print(VR.kOB.hasLongVF);
  //print(VR.kAE.isValid("abc_789789A"));
 // print(VR.kCS.check("W06 _"));//good
 // print(VR.kCS.check("dart"));//bad
 // print(VR.kSS.check(678));


  //print(VRDcmString.kLO.isValid("d_78tlaNg"));

 /* String string = "Helloertert sdfsdfworld!";
  print(string.split(""));
  print(string.substring(3));
  //print(string);*/

  /*var groupperson="abcde^fhgij^klmno^pqrst^uvwxy=zabcd^efghi^jklmn^opqrs^tuvwx=yzabc^defgh^ijklm^nopqr^stuvw";
  PersonName personNames=new PersonName.fromString(groupperson);
  //print(personName);
  //print(PersonName.isValidString(groupperson));

  var groupperson1="abcde^fhgij^klmno^pqrst^uvwxy=zabcd^efghi^jklmn^opqrs^tuvwx=yzabc^defgh^ijklm^nopqr^stuvw";
  //var groupPerson2="abcde^fhgij^klmno^pqrst^uvwxy=zabcd^efghi^jklmn^opqrs^tuvwx=yzabc^defgh^ijklm^nopqr^stuvw";
  //var groupPerson3="abcde^fhgij^klmno^pqrst^uvwxy=zabcd^efghi^jklmn^opqrs^tuvwx=yzabc^defgh^ijklm^nopqr^stuvw";
  List<String> liststring=groupperson1.split("=");
  print(PersonName.isValidList(liststring));
  print(PersonName.parse(groupperson));*/

 /* var gn = "abcde^fhgij^klmno^pqrst^uvwxy=zabcd^efghi^jklmn^opqrs^tuvwx=yzabc^defgh^ijklm^nopqr^stuvw";
  PersonName pn = PersonName.parse(gn);
  print(pn.alphabetic);*/

  //print(VRInt.kUN.issue(Uint8.maxValue+1));
  print(VRInt.kUN.fix(Uint8.maxValue+1));

}

