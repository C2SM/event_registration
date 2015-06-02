<?php 
### Harald von Waldow <hvw@env.ethz.ch>
### Part of the Poor Man's Registration System
### This script is a modified version of one that
### has been floating around at ETH, author unknown.

### configuration

# Address to send registration mails to
$strReceiver = "landclim-event@env.ethz.ch";

# Content of From: field in header of confirmation mail
$strFrom = "\"[LandMIP 2015 Registration]\" <$strReceiver>";

# Content of Subject: field in header of confirmation mail
$strSubject = '[LandMIP 2015 Registration]';

# Page being loaded after registration has completed.
# Should say something like "Thanks for registering for event XY"
$strReturnhtml = 'thankyou.html';

# Delimiter between field name and value
$strDelimiter  = ":  ";

# Contact person named in the confirmation mail
$contactPerson = 'Barbara Aellig <barbara.aellig@env.ethz.ch>';

# Also configure the text of the confirmation mail(s):
# "confirmation_mail_0.txt" and "confirmation_mail_1.txt"
# in this directory. Which of these mails is send depends
# on the content of the file "isfull?.txt" in this directory ("0" or "1").

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
      elseif($strName == "FirstName") {
        $participant_firstname=$value;
      }
      elseif($strName == "LastName") {
        $participant_lastname=$value;
      }
      elseif($strName == "Affiliation") {
        $participant_affiliation=$value;
      }
      elseif($strName == "Remarks") {
        $participant_remarks=$value;
      }
      $strMailtext .= $strName.$strDelimiter.$value."\n";
    }
  }

  if(get_magic_quotes_gpc()) {
    $strMailtext = stripslashes($strMailtext);
  }

  mail($strReceiver, $strSubject, $strMailtext, "From: ".$strFrom, "Return-Path: ".$strReceiver)
  or die("The e-mail could not be sent.");

  header("Location: $strReturnhtml");

  ### creates and sends the confirmation mail

  ### switch between two versions of the body of the confirmationmail,
  ### depending on contents of the file "isfull?.txt".
  ### Here this can take two values, 0 and 1.

  $isfullhandle1 = fopen("isfull1.txt","r");
  $isfullhandle2 = fopen("isfull2.txt","r");
  $isfullhandle3 = fopen("isfull3.txt","r");
  $isfull1=intval(fgets($isfullhandle1));
  $isfull2=intval(fgets($isfullhandle2));
  $isfull3=intval(fgets($isfullhandle3));
  fclose($isfullhandle1);
  fclose($isfullhandle2);
  fclose($isfullhandle3);

  $isfull = "";
  $confirmtext=file_get_contents('confirmation_mail_0.txt');
  if($isfull1 == 0 && $isfull2 == 0 && $isfull3 == 0) {
    $confirmtext=file_get_contents('confirmation_mail_0.txt');
  } else {
    $confirmtext=file_get_contents('confirmation_mail_1.txt');
    if($isfull1 == 1) {
      $isfull = $isfull + "1";
      if($isfull2 == 1) {
      	if($isfull3 == 1) {
  	  $isfull = $isfull + ", 2 and 3.";
  	} else {
  	  $isfull = $isfull + " and 2. Please contact $contactPerson to indicate if you still wish to attend the meeting at day 3.";
      	}
      } else {
      	if($isfull3 == 1) {
          $isfull = $isfull + " and 3. Please contact $contactPerson to indicate if you still wish to attend the meeting at day 2.";
  	} else {
          $isfull = $isfull + ". Please contact $contactPerson to indicate if you still wish to attend the meeting at days 2 and/or 3.";
  	}
      }
    }
    elseif($isfull2 == 1) {
      $isfull = $isfull + "2";
      if($isfull3 == 1) {
        $isfull = $isfull + " and 3. Please contact $contactPerson to indicate if you still wish to attend the meeting at day 1.";
      } else {
        $isfull = $isfull + ". Please contact $contactPerson to indicate if you still wish to attend the meeting at days 1 and/or 3.";
      }
    }
    elseif($isfull3 == 1) {
      $isfull = $isfull + "3. Please contact $contactPerson to indicate if you still wish to attend the meeting at days 1 and/or 2.";
    }
  }

  $confirmtext=strtr($confirmtext, array('$participant_firstname' => $participant_firstname,
  				       '$participant_lastname' => $participant_lastname,
				       '$participant_affiliation' => $participant_affiliation,
				       '$participant_remarks' => $participant_remarks,
  				       '$strMailtext' => $strMailtext,
                                       '$contactPerson' => $contactPerson,
  				       '$isfull' => $isfull,));
  $res=mail($participant_email, $strSubject, $confirmtext, "From: ".$strFrom)
  or die("The e-mail could not be sent!");
  exit;
}

?>
