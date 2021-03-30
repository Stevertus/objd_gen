import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:objd/annotations.dart';

class ProjectGenerator extends GeneratorForAnnotation<Prj> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element e,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (e is! TopLevelVariableElement) {
      throw '@Prj can only be applied to Widget variables';
    }

    // if (!e.type.isDynamic && !e.type.toString().contains('Widget')) {
    //   throw '@Prj values must be of type Widget';
    // }

    final gen = StringBuffer();

    final fnname = annotation.read('genMain').boolValue
        ? 'main'
        : 'create_' + e.displayName;
    final name = annotation.read('name').isString
        ? annotation.read('name').stringValue
        : e.displayName;

    if (e.documentationComment != null) gen.writeln(e.documentationComment);

    gen.write(
      'void $fnname([List<String> args = const []]) => createProject(Project(name: \'$name\',generate: ${e.displayName},',
    );

    if (annotation.read('version').isInt) {
      gen.write('version: ${annotation.read('version').intValue},');
    }
    if (annotation.read('target').isString) {
      gen.write('target: \'${annotation.read('target').stringValue}\',');
    }
    if (annotation.read('description').isString) {
      gen.write(
          'description: \'${annotation.read('description').stringValue}\',');
    }

    gen.writeln('), args,);');

    return gen.toString();
  }
}
