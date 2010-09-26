What's this
===========

ossec-tests is a set of scripts to test your ossec rules by given testcases. It helps you find the effection from rules modification. Gives you confidence that changing or adding rules won't break the original logic.


Running OSSEC Testing Script
============================

Prepare testing environment
---------------------------

Please first prepare your testing environment acorrding to http://www.ossec.net/main/manual/creating-a-separated-directory-for-testing-ossec-rulesconfig/

Then, make a new directory named 'tests'. Later, it will be used to put testcases. Then extract ossec-tests scripts into your testing environment base directory.

Writing a testcase
------------------

Open your favorite editor to add a new testcase like 'vim tests/newuser.t'. As you can see that a testcase is a normal file with extension '.t'. Add the following lines to it:

    rules=(101030 101035)
    levels=(8 13)
    __LOG__
    Sep 26 15:10:52 nby sudo: jianingy : TTY=pts/3 ; PWD=/home/jianingy ; USER=root ; COMMAND=/usr/sbin/groupadd hello
    Sep 26 15:10:52 nby groupadd[27485]: new group: name=hello, GID=1000

Below the mark '__LOG__' comes the log snippet. The 'rules' above __LOG__ indicates that there will be two rules been matched, one is rule id #101030 and the other is rule id #101035. The 'levels' means that first rule will be level #8 and the second will be level #13.


Run Them All
------------

Under your base directory run:

    ./run-all.sh

Or

    ./run-single.sh newuser

The script 'run-all.sh' will run all the testcases and print a summary. The 'run-single.sh' only run the case with given name and print all detail information.
