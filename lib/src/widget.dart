import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:objd/annotations.dart';

const nullable = true;

class WidgetGenerator extends GeneratorForAnnotation<WidgetAnnotation> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! FunctionElement) {
      throw '@Wdg can only be applied to Functions that return a Widget';
    }
    final e = element;

    final useList = e.returnType.toString().contains('List<');

    if (!useList && !e.returnType.toString().contains('Widget')) {
      throw 'The @Wdg Funtion has to return another Widget!';
    }

    final gen = StringBuffer();
    final name = e.displayName;

    final params = e.parameters;
    final classname = name[0].toUpperCase() + name.substring(1);
    if (name == classname) throw 'Make sure your function is lowercase!';

    if (e.documentationComment != null) gen.writeln(e.documentationComment);

    final isRestAction = annotation.read('restAction').boolValue;
    gen.writeln(
      'class $classname extends ${isRestAction ? 'RestActionAble' : 'Widget'} {',
    );

    var requird = <ParameterElement>[];
    var positional = <ParameterElement>[];
    var optional = <ParameterElement>[];
    var named = <ParameterElement>[];
    ParameterElement? context;

    // Find param categories and generate class members
    for (var param in params) {
      if (param.isNamed) named.add(param);
      // If some argument is context, dont add it to arguments of Widget
      if (param.type.toString().contains('Context')) {
        context = param;
        continue;
      }

      if (param.isRequiredNamed || param.isRequiredPositional) {
        requird.add(param);
      }
      if (param.isRequiredPositional) {
        positional.add(param);
      } else if (param.isOptionalPositional) {
        optional.add(param);
      }

      gen.writeln(
        'final ${param.type.getDisplayString(withNullability: nullable)} ${param.displayName};',
      );
    }

    gen.writeln('');
    if (e.documentationComment != null) gen.writeln(e.documentationComment);

    // Contructor

    gen.writeln('$classname (');
    for (var param in positional) {
      gen.writeln(
        'this.${param.displayName},',
      );
    }
    if (optional.isNotEmpty) {
      gen.write('[');
      for (var param in optional) {
        gen.writeln(
          'this.${param.displayName}' +
              (param.hasDefaultValue ? '= ${param.defaultValueCode},' : ','),
        );
      }
      gen.write(']');
    }
    if (named.isNotEmpty) {
      gen.write('{');
      for (var param in named) {
        if (param == context) continue;
        gen.writeln(
          'this.${param.displayName}' +
              (param.hasDefaultValue ? '= ${param.defaultValueCode},' : ','),
        );
      }
      gen.write('}');
    }

    gen.write(')');

    // Assertions

    if (requird.isNotEmpty && annotation.read('assertions').boolValue) {
      gen.write(':');
      for (var param in requird) {
        gen.write(
          'assert(${param.displayName} != null)',
        );
        if (param != requird.last) gen.write(',');
      }
    }
    gen.writeln(';');
    gen.writeln('');

    // Generate method
    gen.writeln('@override');
    gen.write('Widget generate(Context context) => ');
    if (useList) gen.write('For.of(');
    gen.write('$name(');
    for (var param in params) {
      if (named.contains(param)) gen.write('${param.displayName}:');
      // if it is context use given context
      gen.write('${param == context ? 'context' : param.displayName},');
    }

    if (useList) gen.write(')');
    gen.writeln(');');

    gen.writeln('}');

    return gen.toString();
  }
}
