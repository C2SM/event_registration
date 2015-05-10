<?php 
### Harald von Waldow <hvw@env.ethz.ch>
### Part of the Poor Man's Registration System
### This script is a modified version of one that
### has been floating around at ETH, author unknown.

### configuration

# Address to send registration mails to
$strEmpfaenger = "klimarunde2014@env.ethz.ch";

# Content of From: field in header of confirmation mail
$strFrom       = "\"[Klimarunde 2014 Registrierung]\" <$strEmpfaenger>";

# Content of Subject: field in header of confirmation mail
$strSubject    = '[Klimarunde 2014 Registrierung]';

# Page being loaded after registration has completed.
# Should say something like "Thanks for registering for event XY"
$strReturnhtml = 'http://www.c2sm.ethz.ch';

# Delimiter between field name and value
$strDelimiter  = ":  ";

# Contact person named in the confirmation mail
$contactPerson = 'The Manger <mgmt@great.institution.org>';

# Also configure the text of the confirmation mail(s):
# "confirmation_mail_0.txt" and "confirmation_mail_1.txt"
# in this directory. Which of these mails is send depends
# on the content of the file "isfull.txt" in this directory ("0" or "1").

### end of configuration

### creates and sends the registration mail   
if($_POST) {
  $strMailtext = "";
  while(list($strName,$value) = each($_POST)) {
    if($strName=="Submit") {
      break;
    }
    if(is_array($value)) {
      foreach($value as $value_array) {
        $strMailtext .= $strName.$strDelimiter.$value_array."\n";
      }
    }
    else {
      if ($strName == "Email") {
        $participant_email=$value;
      }
      elseif($strName == "Name") {
        $participant_name=$value;
      }
      $strMailtext .= $strName.$strDelimiter.$value."\n";
    }
  }

  if(get_magic_quotes_gpc()) {
    $strMailtext = stripslashes($strMailtext);
  }

  mail($strEmpfaenger, $strSubject, $strMailtext, "From: ".$strFrom, "Return-Path: ".$strEmpfaenger)
  or die("Die Mail konnte nicht versendet werden.");

header("Location: $strReturnhtml");

### creates and sends the confirmation mail

## switch between two versions of the body of the confirmationmail,
## depending on contents of the file "isfull.txt".
## Here this can take two values, 0 and 1.

$isfullhandle = fopen("isfull.txt","r");
$isfull=intval(fgets($isfullhandle));
fclose($isfullhandle);
if($isfull == 0) {
  $confirmtext=file_get_contents('confirmation_mail_0.txt');
} else {
  $confirmtext=file_get_contents('confirmation_mail_1.txt');
}
$confirmtext=strtr($confirmtext, array('$participant_name' => $participant_name,
  				       '$strMailtext' => $strMailtext,
                                       '$contactPerson' => $contactPerson));
$res=mail($participant_email, $strSubject, $confirmtext, "From: ".$strFrom)
    or die("Die Mail konnte nicht versendet werden.");
exit;
}
?>
