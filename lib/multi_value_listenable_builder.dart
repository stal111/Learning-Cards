import 'package:fluent_ui/fluent_ui.dart';

class MultiValueListenableBuilder extends StatelessWidget {
  final List<ValueNotifier> valueListenables;
  final Widget Function(BuildContext, List values) builder;

  const MultiValueListenableBuilder({
    Key? key,
    required this.valueListenables,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _create(valueListenables, context);
  }

  Widget _create(List<ValueNotifier> notifiers, BuildContext context) {
    if (notifiers.isEmpty) {
      return builder(context, valueListenables.map((e) => e.value).toList());
    }
    final copy = [...notifiers];
    final notifier = copy.removeAt(0);

    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (_, __, ___) => _create(copy, _),
      child: _create(copy, context),
    );
  }
}
