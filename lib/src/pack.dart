import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:objd/annotations.dart';

const nullable = false;

class PackGenerator extends GeneratorForAnnotation<Pck> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! TopLevelVariableElement) {
      throw '@Pck can only be applied to List<File> variables';
    }

    final e = element as TopLevelVariableElement;

    if (!e.type.isDynamic && !e.type.toString().contains('List<')) {
      throw '@Pck values must be of type List<File>';
    }

    final gen = StringBuffer();

    final name = annotation.read('name').isNull
        ? e.displayName
        : annotation.read('name').literalValue.toString();

    final classname =
        name[0].toUpperCase() + name.substring(1).replaceAll('_', '') + 'Pack';

    if (e.documentationComment != null) gen.writeln(e.documentationComment);

    gen.writeln('class $classname extends Widget {');
    gen.writeln('@override');
    gen.write(
      'Widget generate(Context context) => Pack(name: \'$name\',files: ${e.displayName},',
    );

    if (annotation.read('main').isString) {
      gen.write(
          'main: File(\'${annotation.read('main').stringValue}\',create: false),');
    }
    if (annotation.read('load').isString) {
      gen.write(
          'load: File(\'${annotation.read('load').stringValue}\',create: false),');
    }

    gen.writeln(');');
    gen.writeln('}');

    return gen.toString();
  }
}