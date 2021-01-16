import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:objd/annotations.dart';

const nullable = false;

class FileGenerator extends GeneratorForAnnotation<Func> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! TopLevelVariableElement) {
      throw '@Func can only be applied to final Widget variables';
    }
    final e = element as TopLevelVariableElement;

    // if (!e.type.isDynamic && !e.type.toString().contains('Widget')) {
    //   throw '@Func values must be of type Widget';
    // }

    final gen = StringBuffer();

    final pathSegments = e.source.fullName.split('/')..removeLast();

    final name = annotation.read('name').isNull
        ? e.displayName
        : annotation.read('name').literalValue.toString();
    final path = annotation.read('path').isNull
        ? pathSegments.sublist(1).join('/').replaceAll('lib/', '') + '/'
        : annotation.read('path').stringValue;

    final classname = name[0].toUpperCase() + name.substring(1) + 'File';

    if (e.documentationComment != null) gen.writeln(e.documentationComment);

    gen.write(
      'final File $classname = File(\'$path$name\',child: ${e.displayName},',
    );

    if (annotation.read('pack').isString) {
      gen.write('pack: \'${annotation.read('pack').stringValue}\',');
    }
    if (annotation.read('execute').isBool) {
      gen.write('execute: ${annotation.read('execute').boolValue},');
    }
    if (annotation.read('create').isBool) {
      gen.write('create: ${annotation.read('create').boolValue},');
    }

    gen.writeln(');');
    return gen.toString();
  }
}
