import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'src/widget.dart';
import 'src/pack.dart';
import 'src/file.dart';
import 'src/project.dart';

Builder widgetBuilder(BuilderOptions options) => SharedPartBuilder(
      [
        WidgetGenerator(),
        FileGenerator(),
        PackGenerator(),
        ProjectGenerator(),
      ],
      'widget',
    );
