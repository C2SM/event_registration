<?php require('register.php'); ?>
<!DOCTYPE html>
<html>

<head>

<!-- copyright, author, e-mail address -->    
<meta name="copyright" content="ETH Zuerich" />
<meta name="author" content="Richard Wartenburger" />
<meta name="Description" content="ETH Zuerich" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="http://www.ethz.ch/" rel="home" />
<link rel="SHORTCUT ICON" href="http://www.iac.ethz.ch/icons_site/kuppel_icon_c010.ico" />
<!-- <base href="http://www.iac.ethz.ch/groups/seneviratne/" /> -->

<!-- supervision header -->
<meta name="Systemueberwachung" content="ETHZ" />

<!-- charset, home, base -->
<link href="http://www.ethz.ch/" rel="home" />
<link rel="SHORTCUT ICON" href="http://www.iac.ethz.ch/icons_site/kuppel_icon_c010.ico" />
<!-- <base href="http://www.iac.ethz.ch/groups/seneviratne/" /> -->

<!-- style sheet --> 
<link rel="stylesheet" href="http://www.iac.ethz.ch/css/colors_c010.css" type="text/css" />
<link rel="stylesheet" href="http://www.iac.ethz.ch/css/ns4.css" type="text/css" />
<style type="text/css">
<!--
@import url("http://www.iac.ethz.ch/css/modernbrowsers.css");
@import url("http://www.iac.ethz.ch/css/colors_c010.css");
@import url("http://www.iac.ethz.ch/css/silva.css");
@import url("http://www.iac.ethz.ch/groups/seneviratne/customstyles.css");
-->
</style>
<link rel="stylesheet" media="print" href="http://www.iac.ethz.ch/css/print.css" type="text/css" />
<style type="text/css">
.logo-bg, .logo-bg-alt { background-image: url(http://www.iac.ethz.ch/images/head_bg_logo_home_c010.jpg); background-repeat: no-repeat; }
.identity-image { background-image: url(http://www.iac.ethz.ch/images/head_bg_home_c010.jpg); background-repeat: repeat; }
.mainnav, .screenhead, .color5-back, .color4-back, .color3-back, .color2-back, .color1-back,  .servicenav, .transparent {background-image: url(http://www.iac.ethz.ch/icons_site/transparent.gif); }
h3 { margin:0; }
</style>
<style type="text/css">div.navblock, .margins div.contentblock-1col { margin-bottom:199px; }</style>

<!-- extra stylesheet for ie7 -->
<!--[if lte IE 6]>
<link rel='stylesheet' href='http://www.iac.ethz.ch/css//ie6.css' type='text/css' />
<![endif]-->
<!--[if IE 7]>
<link rel='stylesheet' href='http://www.iac.ethz.ch/css//ie7.css' type='text/css' />
<![endif]-->

<!-- scripts -->
<script src="http://www.iac.ethz.ch/scripts/scripts_en.js" type="text/JavaScript"></script>
<script src="http://www.iac.ethz.ch/scripts/jquery-1.6.4.min.js" type="text/JavaScript"></script>
<script src="http://www.iac.ethz.ch/scripts/scripts.js" type="text/JavaScript"></script>
<script type="text/javascript">
  function validateEmail(e) {
    var atpos=e.indexOf("@");
    var dotpos=e.lastIndexOf(".");
    if (atpos<1 || dotpos<atpos+2 || dotpos+2>=e.length) {
      return("Please provide a correct email address!\n");
    } else {
      return(false);
    }
  }

  function validateForm() {
    var errmsg="";
    var email=document.forms["REGISTER"]["Email"].value;
    var day = document.querySelectorAll('#REGISTER input[type="checkbox"]');
    var dayok=false;
    var vegok=false;
    var firstname=document.forms["REGISTER"]["FirstName"].value;
    var lastname=document.forms["REGISTER"]["LastName"].value;
    var affiliation=document.forms["REGISTER"]["Affiliation"].value;
    var remarks=document.forms["REGISTER"]["Remarks"].value;
    if (firstname == "") {
      errmsg = "Please provide your first name!\n";
    }
    if (lastname == "") {
      errmsg = errmsg + unescape("Please provide your last name!\n");
    }
    if (affiliation == "") {
      errmsg = errmsg + unescape("Please provide your affiliation!\n");
    }
    for(i=0; i<3; i++) { <!-- 3 days -->
      dayok = dayok || day[i].checked;
    }
    if (day[5].checked) { <!-- vegetarian -->
      if (!day[3].checked && !day[4].checked) {
        errmsg=errmsg + "You choose to eat vegetarian, but did not choose to attend either lunch or dinner."
      }
    }
    var emailval=validateEmail(email);
    if (emailval) {
      errmsg = errmsg + emailval;
    }
    if (!dayok) {
      errmsg = errmsg + unescape("Please choose at least one day of the programme!\n")
    }
    if(errmsg != "") {
      alert(errmsg);
      return(false);
    } else {
      return(true);
    }
  }

</script>

<title>Registration</title>

</head>

<body>
<div id="contentblock-3col" class="contentblock-3col" style="width:auto">
<table>
	<tr>
	<td colspan="6"><img src="images/banner.png" style="width:846px"/></td>
	</tr>
	<tr align="center">
	<td valign="middle"><a href="http://www.climate-cryosphere.org/" target="_blank"><img src="images/clic.jpg" style="width:85px"/></a></td>
	<td valign="middle"><a href="https://www.ethz.ch/" target="_blank"><img src="images/eth.jpg" style="width:115px"/></a></td>
	<td valign="middle"><a href="http://www.drought-heat.ethz.ch/" target="_blank"><img src="images/landclim.png" style="width:80px"/></a></td>
	<td valign="middle"><a href="http://www.gewex.org/" target="_blank"><img src="images/gewex.png" style="width:115px"/></a></td>
	<td valign="middle"><a href="https://www.pik-potsdam.de/research/climate-impacts-and-vulnerabilities/research/rd2-cross-cutting-activities/isi-mip" target="_blank"><img src="images/isimip.png" style="width:110px"/></a></td>
	<td valign="middle"><a href="http://wcrp-climate.org/" target="_blank"><img src="images/wcrp.jpg" style="width:115px"/></a></td>
	</tr>
</table>
<h2>LandMIP Workshop Registration (2015-10-26 &ndash; 2015-10-28)</h2>
<p class="p">
<a href="http://www.climate-cryosphere.org/activities/targeted/ls3mip/meetings/landmodelling" target="_blank">View the meeting agenda</a>
</p>
<p class="p">
<form id="REGISTER" onsubmit="return validateForm()" action="<?php print $_SERVER['PHP_SELF']; ?>" method="post" name="REGISTER" enctype="Default" target="_parent">
      <table><tr>

      <td colspan="2"><h3>Personal information (required)</h3></td>
      </tr><tr>
      <td><label>First name</label></td>
      <td><input type="text" name="FirstName" size="45"></td>
      </tr><tr>
      <td><label>Last name</label></td>
      <td><input type="text" name="LastName" size="45"></td>
      </tr><tr>
      <td><label>Affiliation</label></td>
      <td><input type="text" name="Affiliation" size="45"></td>
      </tr><tr>
      <td><label>Email address</label></td>
      <td><input type="text" name="Email" size="45"></td>
      </tr><tr>

      <td colspan="2"><h3>Select the session(s) that you wish to attend</h3></td>
      </tr><tr>
      <td><label>Monday, October 26: <b>LS3MIP/LUMIP: Coupled simulations</b></label></td>
      <td><input type="checkbox" name="Day1"></td>
      </tr><tr>
      <td><label>Tuesday, October 27: <b>LMIP, GSWP: Offline simulations</b></label></td>
      <td><input type="checkbox" name="Day2"></td>
      </tr><tr>
      <td><label>Wednesday, October 28 (until 2pm): <b>Open joint LandMIP/ISIMIP session</b></label></td>
      <td><input type="checkbox" name="Day3"></td>
      </tr><tr>

      <td colspan="2"><h3>Lunch and dinner preferences</h3></td>
      </tr><tr>

      <td><label>I wish to attend the dinner <b>on Tuesday, October 27</b></label></td>
      <td><input type="checkbox" name="Day2Dinner"></td>
      </tr><tr>

      <td><label>I wish to attend the lunch <b>on Wednesday, October 28</b></label></td>
      <td><input type="checkbox" name="Day3Lunch"></td>
      </tr><tr>

      <td><label>I am vegetarian</label></td>
      <td><input type="checkbox" name="Vegetarian"></td>
      </tr><tr>

      <td colspan="2">&nbsp;</td>
      </tr><tr>

      <td><label>Other remarks (max. 200 characters)</label></td>
      <td><input type="text" name="Remarks" size="45"></td>
      </tr><tr>

      <td colspan="2">&nbsp;</td>
      </tr><tr>

      <td colspan="2"><input type="reset" value="Reset Form">&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" name="Submit" value="Register Now!"></td>
      </tr></table>
</form>
</p>
</div>
</body>

</html>
