// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Original author: Jim Philbin <jfphilbin@gmail.edu> -
// See the AUTHORS file for other contributors.

// Copyright 2015 Google. All rights reserved. Use of this source code is
// governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:grinder/grinder.dart';

Future main(List<String> args) => grind(args);

Directory dartDocDir = new Directory('C:/odw/sdk/doc/dictionary');

const bool runAsync = false;

@DefaultTask('Running Default Tasks...')
void myDefault() {
  test();
 // testformat();
}

@Task('Pre-Commit')
@Depends(unittest, analyze, format)
void precommit(){

}

@Task('Analyzing Sources...')
void analyze() {
  log('Analyzing Common...');
  Analyzer.analyze(['lib', 'test', 'tool'], fatalWarnings: true);
}

@Task('Unit Testing...')
Future unittest() async {
  if (runAsync) {
    log('Unit Tests (running asynchronously)...');
    await new TestRunner().testAsync();
  } else {
    log('Unit Tests (running synchronously)...');
    new PubApp.local('test').run([]);
    // new TestRunner();
  }
}

@Task('Testing Dart...')
@Depends(unittest)
void test() {
  new PubApp.local('test').run([]);
}

@Task('Cleaning...')
void clean() {
  log("Cleaning...");
  delete(buildDir);
  delete(dartDocDir);
}

@Task('Dry Run of Formating Source...')
void testformat() {
  log("Formatting Source...");
  DartFmt.dryRun('lib', lineLength: 100);
}

@Task('Formating Source...')
void format() {
  log("Formatting Source...");
  DartFmt.dryRun('lib', lineLength: 100);
}

@Task('DartDoc')
void dartdoc() {
  log('Generating Documentation...');
  DartDoc.doc();
}

@Task('Build the project.')
void build() {
  log("Building...");
  Pub.get();
  Pub.build(mode: "debug");
}

@Task('Building release...')
void buildRelease() {
  log("Building release...");
  Pub.upgrade();
  Pub.build(mode: "release");
}

@Task('Compiling...')
void compile() {
  log("Compiling...");
}

@Task('Testing JavaScript...')
@Depends(build)
void testJavaScript() {
  new PubApp.local('test').run([]);
}

@Task('Deploy...')
@Depends(clean, format, compile, buildRelease, test, testJavaScript)
void deploy() {
  log("Deploying...");
  log('Regenerating Documentationfrom scratch...');
  delete(dartDocDir);
  DartDoc.doc();
}
