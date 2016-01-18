# Tests on ci.centos.org

This directory contains job configuration files, managed through [Jenkins Job
Builder](http://ci.openstack.org/jenkins-job-builder/) to run tests for each
software collection on the [CentOS CI infrastructure](https://ci.centos.org).

*View all tests at [SCLo on ci.centos.org](https://ci.centos.org/view/SCLo/).*

## Pre-requisites

* `virtualenv` command, supplied through the `python-virtualenv` RPM

JJB will be installed into a virtual environment under this directory, so is
safe to run on any system.

## Testing job modifications

    ./run.sh test -o /tmp/jobs

Check the script exited without any errors, and the XML definitions of the jobs
will be available in /tmp/jobs.

## Updating jobs

The provided script can update the Jenkins jobs over the API by running JJB.

    ./run.sh update

If you haven't run it before, it will fail with an authentication error:

    jenkins.JenkinsException: Error in request. Possibly authentication failed [401]: Invalid password/token for user

Edit the newly created `jenkins_jobs.ini` and add the username/password for
access to Jenkins, then re-run the command.  These credentials can be found in
the home directory on slave01.ci.centos.org.

## Generated jobs

* *Per-collection, per-OS and per-arch tests*: for every SCL/OS/arch
  combination, a job will be generated to run the full test suite, e.g.
  `SCLo-git19-rh-C7-x86_64`.
