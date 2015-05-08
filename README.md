# Poor Man's Registration System

This is a very pedestrian collection of scripts to handle
registrations for events.  It is very simple and very fast to set up.
It was born out of the need for a registration
mechanism that dynamically changes state (with reaching
certain thresholds of the number of registrations for sub-events).

The design is also determined by an institutional CMS that is very
limiting.  The only requirement for the CMS that presents the
registration is that you can include iFrames. The Silva CMS used by
ETH offers this. The new Adobe AEM CMS to which ETH is transitioning
should also offer this, but practical experience is unavailable so far.

We have successfuly used this setup for
[Klimarunde 2013](http://www.c2sm.ethz.ch/events/past-events/klimarunde-2013.html)
and
[Klimarunde 2014](http://www.c2sm.ethz.ch/events/past-events/eth-klimarunde-2014.html)
with more than 400 participants each.

The systems (ab)uses an IMAP mail account, to which registration mails
are automatically send, as a database of registrations. This may seem
weird, but it saved us from implementing a server-side database of
registrations. IMAP is good enough as a database, you can easily
remove spurious registrations by simply deleting an email, manually
register people by sending an email, and also your IT-department takes care of
the backup ;).

## Requirements

+ Ability to include iFrames in the institutional CMS
+ A webserver that can serve PHP
+ An IMAP email account
+ A machine running the system ("exec_host") that has bash, cron, sed, awk, R and [OfflineIMAP](http://offlineimap.org/) installed.
+ Passwordless ssh login from exec_host to the webserver

## Alternatives

IT Services at ETH Zurich offers the
[Evento Booking System](https://www1.ethz.ch/id/services/list/evento/index_EN). This
is a very useful service, in particular if you need credit card
processing. "Evento Light" is cheap, but limted to ca. 150
participants and you'll need quite some time in advance to have it
ready.

There are commercial offers such as
[Eventbrite](https://www.eventbrite.com). However, your potential
participants might take issue if you require them to give their
personal data to the advertising industry. Also using such tools
might be in violation of both, ETH guidelines and Swiss data
protection law.

## Setup

1. clone the git repository
2. make a directory on the webserver ("WEBSERVER\_REGISTRATION\_PATH") that holds the registration form.
3. make a directory on the webserver ("RESULTPATH") from which info about the state of registrations are presented
    (this can be also on a different webserver).
4. copy the files in "webserver" into WEBSERVER\_REGISTRATION\_PATH.
5. copy the files in exec\_machine to exec\_host.
6. Carry out the configurations described below ([webserver](#webserver) and [exec_machine](#exec_machine)), **that refer to hostnames and paths**.
7. Do a test-registration, run `getregistrations.sh`, check whether the webpage at http://{WEBSERVER}/{RESULTPATH}/kr_registrations.html shows up as expected and
    the "download table" link lets you download, well, the table.
8. Customize the variables that are specific for your event as described  below ([webserver](#webserver) and [exec_machine](#exec_machine)).
7. Run getregistrations.sh via cron job.

## Files

### webserver

**`registration_form.php`**:<br /> The registration form proper. You
might want to translate the error messages in the function
`validate_form()`. Change the input form (lines 49-53) according to your requirements.

**`register.php`**:<br />
Customize the values in the configuration section on top of the file.

**`confirmation_mail_0.txt`** and **`confirmation_mail_1.txt`**:<br/>
Mailtext send in confirmation mails to registrands. The system
switches from one to the other upon reaching a threshold that can be
set in `exec_machine/graphit.R`.  Modify the text; make use of the
placeholders ("$participant\name", ...).

**`isfull.txt`**<br />
Initially contains "0". Is overwritten with "1" once participant limit is reached.

### exec_machine

**`offlineimaprc`**:<br />
Configuration for offlineimap. Edit to include your mail specifications in the "[DEFAULT]" section.

**`getregistrations.sh`**:<br />
The main script being run by cron. Customize the various hostnames and paths defined at the top of the file.

**`sedextract.sh`**<br />
Filters registration emails into a csv -file. Depending on the contents of your registration form you will have to customize
the part that extracts the data (below line 33).

**`graphit.R`**:<br />
Checks whether the participation limit is reached, in
which case it modifies "isfull.txt" on the webserver. Produces a graph
that shows the current registration data. Customize the variables set
in the CONFIGURE section at the top of the file.


## Feedback

If you use this setup, you will likely extend & improve the scripts. I
would be glad if you could contribute back via email or pull-request. 

