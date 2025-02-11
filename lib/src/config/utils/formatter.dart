String getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return months[month - 1];
}

String getFormattedDate(DateTime date) {
  return '${date.day} ${getMonthName(date.month)}, ${date.year}';
}
