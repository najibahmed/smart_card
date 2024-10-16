String createVCard(String fullName, String phoneNumber, String email, String address) {
  return 'BEGIN:VCARD\n'
      'VERSION:3.0\n'
      'FN:$fullName\n'
      'TEL:$phoneNumber\n'
      'EMAIL:$email\n'
      // 'ADR;TYPE=home:;;$street;$city;$state;$postalCode;$country\n
      'END:VCARD';
}