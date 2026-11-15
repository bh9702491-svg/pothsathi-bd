/// একটি SQL স্ক্রিপ্টকে আলাদা আলাদা স্টেটমেন্টে ভাগ করে।
/// নিয়ম: `--` দিয়ে শুরু হওয়া লাইন মন্তব্য; স্টেটমেন্টের ভেতরে স্ট্রিংয়ে `;` রাখা যাবে না।
List<String> splitSqlStatements(String script) {
  final withoutComments = script
      .split('\n')
      .where((line) => !line.trimLeft().startsWith('--'))
      .join('\n');

  return withoutComments
      .split(';')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
}
