import 'package:flutter_test/flutter_test.dart';
import 'package:pothsathi_bd/core/db/sql_script.dart';

void main() {
  test('মন্তব্য বাদ দিয়ে স্টেটমেন্ট ভাগ করে', () {
    const script = '''
-- মন্তব্য; এখানে সেমিকোলন আছে
CREATE TABLE a (id INTEGER);

-- আরেকটি মন্তব্য
INSERT INTO a VALUES (1);
''';
    final result = splitSqlStatements(script);
    expect(result.length, 2);
    expect(result[0], startsWith('CREATE TABLE a'));
    expect(result[1], startsWith('INSERT INTO a'));
  });
}
