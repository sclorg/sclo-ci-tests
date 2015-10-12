# Software Collections Package Lists

In order to make sure all required rpm packages are included in
the Software Collections and no additional rpms are pulled in we
need to review the package list for each collection so that some
CI is able to verify.

Here you can find the list of packages which are expected to be
pulled into the system by installing the meta package (main) and
the full list of rpms available for the software collection (all).

Please note that *-debuginfo & *-build packages are intentionally
omitted from the lists. Packages which are not present across all
supported distros are marked with the relevant distro names. E.g.

    python33-suitesparse    rhel-6

Use whitespace for separating the distro names from the package or
multiple distros. Packages available across all RHELs should have
no distro specified.
