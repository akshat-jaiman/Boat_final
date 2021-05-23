int getDate(DateTime selectedDate) {
  int index = 0;
  switch (selectedDate.month) {
    case 1:
      index = 0;
      break;
    case 2:
      index += 31;
      break;
    case 3:
      index += 59;
      break;
    case 4:
      index += 90;
      break;
    case 5:
      index += 120;
      break;
    case 6:
      index += 151;
      break;
    case 7:
      index += 181;
      break;
    case 8:
      index += 212;
      break;
    case 9:
      index += 243;
      break;
    case 10:
      index += 273;
      break;
    case 11:
      index += 304;
      break;
    case 12:
      index += 334;
      break;
  }
  index += selectedDate.day;
  return index;
}
