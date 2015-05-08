<?php require('register.php'); ?>
<!DOCTYPE html>
<html>
<head>
<title>Registration</title>

<script type="text/javascript">
  function validateEmail(e) {
    var atpos=e.indexOf("@");
    var dotpos=e.lastIndexOf(".");
    if (atpos<1 || dotpos<atpos+2 || dotpos+2>=e.length) {
      return("Bitte geben Sie Ihre richtige Emailadresse an!\n");
    } else {
      return(false);
    }
  }
 
  function validateForm() {
    var errmsg="";
    var name=document.forms["REGISTER"]["Name"].value;
    var email=document.forms["REGISTER"]["Email"].value;
    var part = document.querySelectorAll('#REGISTER input[type="checkbox"]');
    var partok=false;  
    for(i=0; i<part.length; i++) {
      partok = partok || part[i].checked;
    }
    if (name == "") {
      errmsg="Bitte geben Sie Ihren Namen an!\n";
    }
    var emailval=validateEmail(email);
    if (emailval) {
      errmsg = errmsg + emailval;
    }
    if (!partok) {
      errmsg = errmsg + unescape("Bitte w%E4hlen Sie mindestens einen Teil des Programms aus!\n")
    }
    if(errmsg != "") {
      alert(errmsg);
      return(false);
    } else {
      return(true);
    }
  }
</script>
</head>
<body>
<form id="REGISTER" onsubmit="return validateForm()" action="<?php print $_SERVER['PHP_SELF']; ?>"
	method="post" name="REGISTER" enctype="Default" target="_parent">
    <p><label>Ihr Name:</label> <input type="text" name="Name" size="55"></p>
    <p><label>Ihre Email:</label> <input type="text" name="Email" size="55"></p>
    <p><label>Ich komme zu Teil 1<br /> (15:30-16:30: Tischgespr&auml;che):</label> <input type="checkbox" name="Teil 1"></p>
    <p><label>Ich komme zu Teil 2<br /> (17:00-19:00: Referate und Podiumsdiskussion):</label> <input type="checkbox" name="Teil 2"></p>
    <p><label>Ich komme zum Apero: (19:00)</label> <input type="checkbox" name="Apero"></p>    
    <p><input type="reset"> <input type="submit" name="Submit" value="Absenden"></p>
   </form>
</body>
</html>
