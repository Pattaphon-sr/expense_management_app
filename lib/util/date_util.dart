class DateUtil {
  /// ถ้า string มี timezone (Z หรือ +/-HH:MM) -> toLocal()
  /// ถ้าไม่มี timezone -> ถือว่าเป็น local อยู่แล้ว
  static String formatDate(String dateStr) {
    try {
      String s = dateStr.trim();
      // ให้ DateTime.parse มั่นใจว่าเป็นรูป ISO (T แทนช่องว่างระหว่างวัน/เวลา)
      if (s.contains(' ') && !s.contains('T')) {
        s = s.replaceFirst(' ', 'T');
      }

      final hasZone = RegExp(r'(Z|[+\-]\d{2}:\d{2})$').hasMatch(s);
      DateTime dt = DateTime.parse(s);
      if (hasZone) dt = dt.toLocal(); // แปลงเป็นเวลาท้องถิ่นเฉพาะกรณีมีโซน

      String y = dt.year.toString().padLeft(4, '0');
      String m = dt.month.toString().padLeft(2, '0');
      String d = dt.day.toString().padLeft(2, '0');
      String h = dt.hour.toString().padLeft(2, '0');
      String min = dt.minute.toString().padLeft(2, '0');
      String s2 = dt.second.toString().padLeft(2, '0');
      String ms = dt.millisecond.toString().padLeft(3, '0');

      return "$y-$m-$d $h:$min:$s2.$ms";
    } catch (_) {
      return dateStr; // parse ไม่ได้ก็คืนค่าเดิม
    }
  }
}
