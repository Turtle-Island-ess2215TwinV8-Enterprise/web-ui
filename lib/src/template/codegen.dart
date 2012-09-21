// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/** Collects common snippets of generated code. */
library codegen;

/** Header with common imports, used in every generated .dart file. */
String header(String filename, String libraryName) => """
// Generated Dart class from HTML template $filename.
// DO NOT EDIT.

#library('${libraryName}');

#import('dart:html');
#import('package:web_components/js_polyfill/component.dart');
#import('package:web_components/js_polyfill/web_components.dart');
#import('package:web_components/watcher.dart');
""";

/** The code in .dart files generated for a web component. */
String componentCode(
    String filename,
    String libraryName,
    List<String> extraImports,
    String className,
    String webComponentName,
    String userCode,
    String extraFields,
    String createdBody,
    String insertedBody,
    String removedBody) => """
${header(filename, libraryName)}

${_importList(extraImports)}

class $className extends Component {
  /** User written code associated with '$filename'. */
$userCode
  /** Autogenerated from the template. */

$extraFields

  $className() : super('$webComponentName');

  void created(shadowRoot) {
    root = shadowRoot;
$createdBody
  }

  void inserted() {
$insertedBody
  }

  void removed() {
$removedBody
  }
}
""";

/** The code in the main.html.dart generated file. */
String mainDartCode(
    String filename,
    String libraryName,
    List<String> generatedCodeImports,
    List<String> extraImports,
    String topLevelFields,
    String fieldInitializers,
    String modelBinding,
    String initializationMappings,
    String initialPage,
    String initialCode) => """
${header(filename, libraryName)}
${_importList(generatedCodeImports)}

${_importList(extraImports)}

/** User supplied main page code. */
$initialCode

/** Generated code. */
$topLevelFields

/** Create the views and bind them to models. */
void init() {
  _componentsSetUp();

  // Create view.
  var root = new DocumentFragment.html(_INITIAL_PAGE);
  manager.expandDeclarations(root);

  // Initialize fields.
$fieldInitializers
  // Attach model to views.
$modelBinding

  // Attach view to the document.
  document.body.nodes.add(root);
}

/** Setup components used by application. */
void _componentsSetUp() {
  var map = <Function>{
    $initializationMappings
  };

  initializeComponents((name) => map[name]);
}

final String _INITIAL_PAGE = '''
  $initialPage
''';

WatcherDisposer bind(exp, callback, [debugName]) =>
  watchAndInvoke(exp, callback, debugName);
""";

/** Generate text for a list of imports. */
String _importList(List<String> imports) =>
  Strings.join(imports.map((url) => "#import('$url');"), '\n');
