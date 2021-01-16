// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// WidgetGenerator
// **************************************************************************

class HelloWorld extends Widget {
  HelloWorld();

  @override
  Widget generate(Context context) => helloWorld();
}

class HelloName extends Widget {
  final String name;
  final String lastname;

  HelloName(
    this.name, {
    this.lastname = '',
  });

  @override
  Widget generate(Context context) => helloName(
        name,
        lastname: lastname,
        context: context,
      );
}

// **************************************************************************
// FileGenerator
// **************************************************************************

final File LoadFile = File(
  'objd/example/load',
  child: load,
);

final File MainFile = File(
  'foldermain',
  child: main_widget,
  execute: false,
  create: true,
);

// **************************************************************************
// PackGenerator
// **************************************************************************

class NamespacePack extends Widget {
  @override
  Widget generate(Context context) => Pack(
        name: 'namespace',
        files: myPack,
        main: File('main', create: false),
        load: File('load', create: false),
      );
}

// **************************************************************************
// ProjectGenerator
// **************************************************************************

void main([List<String> args = const []]) => createProject(
      Project(
        name: 'My awesome Datapack',
        generate: myProject,
        version: 17,
        target: './datapacks/',
        description: 'A simple dp for demonstrating annotations',
      ),
      args,
    );
