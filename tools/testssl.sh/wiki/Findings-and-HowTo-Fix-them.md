## Bugs, Findings and Small Debugging HowTo

Found a bug. Good -- yes, seriously! In the end it'll make testssl.sh better. You have three choices if you want to help.

* file a simple bug report
* provide extended debugging info for others
* debug yourself

### file a proper bug report

Needed is to reproduce the error:

* server ip address, 
* command line
* testssl.sh version, 
* openssl version and operating system, 

If you're hesitant to publicly advertise the IP address, use my mail address in the script.
Without those information I'll likely close the issue.

If the server is internal you should at least provide the info in one of the next section:


### provide extended debugging output for others

Two options here:

* Run the whole script with ``--debug=1 --log``. Then ``tar -cvzf mydebug.tgz /tmp/ssltester.<randomstring> <nameoflogfile>``
* Run the section where the problem is (see ``--help``): ``script -c "bash -vx testssl.sh optionfortherightsection>"``


### debug yourself

YMMV, this is just a hint.

* spot the section where the bug is 
* edit the script and put **after** the section an ``exit 0``
* switch on debugging either by 
  * editing the program and add before a ``set -x``, run the section of the script
  * run the script with ``bash -vx testssl.sh <<optionfortherightsection>>``

If you spotted a problem the easiest thing is 