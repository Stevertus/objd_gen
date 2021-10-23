import 'package:objd/core.dart';

part 'example.g.dart';

@Wdg
Widget helloWorld() => Log('Hello World!');

@Wdg
Widget helloName(
  String name, {
  String lastname = '',
  required Context context,
}) =>
    For.of([
      Comment('This was generated by HelloName on version ${context.version}'),
      Log('Hello $name $lastname!'),
    ]);

@Func()
final Widget load = HelloWorld();

@Func(
  name: 'main',
  path: '/folder/',
  execute: false,
  create: true,
)
final Widget main_widget = Comment('main file');

@Pck(name: 'namespace', main: 'folder/main', load: 'load')
final List<File> myPack = [LoadFile, MainFile];

@Prj(
  name: 'My awesome Datapack',
  target: './datapacks/',
  version: 17,
  description: 'A simple dp for demonstrating annotations',
)
final myProject = NamespacePack();
