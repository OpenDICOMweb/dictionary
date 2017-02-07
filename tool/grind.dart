// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> - 
// See the AUTHORS file for other contributors.

// Copyright 2015 Google. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.

import 'package:grinder/grinder.dart';

import 'grind_core.dart';

main(args) => grind(args);

// Uncomment if needed
/* @Task('Initializing...')
init() {
  log("Initializing stuff...");
}
*/

@DefaultTask('Running Default Tasks...')
void myDefault() {
  test();
  testformat();
}

@Task('Testing Dart...')
void test() {
  new PubApp.local('test').run([]);
}

@Task('Cleaning...')
clean() {
  log("Cleaning...");
  delete(buildDir);
  delete(dartDocDir);
}

@Task('Dry Run of Formating Source...')
testformat() {
  log("Formatting Source...");
  DartFmt.dryRun('lib', lineLength: 100);
}

@Task('Formating Source...')
format() {
  log("Formatting Source...");
  DartFmt.dryRun('lib', lineLength: 100);
}

@Task('DartDoc')
dartdoc() {
  log('Generating Documentation...');
  DartDoc.doc();
}

@Task('Build the project.')
build() {
  log("Building...");
  Pub.get();
  Pub.build(mode: "debug");
}

@Task('Building release...')
buildRelease() {
  log("Building release...");
  Pub.upgrade();
  Pub.build(mode: "release");
}

@Task('Compiling...')
//@Depends(init)
compile() {
  log("Compiling...");
}

@Task('Testing JavaScript...')
@Depends(build)
testJavaScript() {
  new PubApp.local('test').run([]);
}

@Task('Deploy...')
@Depends(clean, format, compile, buildRelease, test, testJavaScript)
deploy() {
  log("Deploying...");
  log('Regenerating Documentationfrom scratch...');
  delete(dartDocDir);
  DartDoc.doc();
}