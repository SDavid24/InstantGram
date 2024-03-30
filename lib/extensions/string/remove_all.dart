//Remove all occurrences of "##" and replace it with null
extension RemoveAll on String {
  String removeAll(Iterable<String> values) => values.fold(
    this,
        (result, value) => result.replaceAll(
          value,
          '',
    ),
  );
}