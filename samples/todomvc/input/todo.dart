// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#library('todo');

#import('dart:html');

#import('footer.dart');
#import('generic_list.dart');
#import('generic_if.dart');
#import('newform.dart');
#import('item.dart');
#import('toggleall.dart');

#import('model.dart');
#import('watcher.dart');


main() {
  // listen on changes to #hash in the URL
  window.on.popState.add((_) {
    viewmodel.showIncomplete = window.location.hash != '#/completed';
    viewmodel.showDone = window.location.hash != '#/active';
    dispatch();
  });
}
