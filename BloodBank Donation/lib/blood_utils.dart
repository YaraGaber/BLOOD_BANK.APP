

String determineAppropriateBloodType(String enteredBloodType) {
  String appropriateBloodType = '';

  // Perform the appropriate checks based on entered blood type
  if (enteredBloodType == 'A+') {
    appropriateBloodType = 'O-, O+, A-, A+';
  } else if (enteredBloodType == 'A-') {
    appropriateBloodType = 'O-, A-';
  } else if (enteredBloodType == 'B+') {
    appropriateBloodType = 'O-, O+, B-, B+';
  } else if (enteredBloodType == 'B-') {
    appropriateBloodType = 'O-, B-';
  } else if (enteredBloodType == 'AB+') {
    appropriateBloodType = 'O-, O+, A-, A+, B-, B+, AB-, AB+';
  } else if (enteredBloodType == 'AB-') {
    appropriateBloodType = 'O-, A-, B-, AB-';
  } else if (enteredBloodType == 'O+') {
    appropriateBloodType = 'O-, O+';
  } else if (enteredBloodType == 'O-') {
    appropriateBloodType = 'O-';
  }

  return appropriateBloodType;
}
