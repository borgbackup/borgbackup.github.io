Borg 1.4
========

:Links: `Documentation <https://borgbackup.readthedocs.io/en/1.4-maint/>`_ · `Installation <https://borgbackup.readthedocs.io/en/1.4-maint/installation.html>`_ · `Downloads <https://github.com/borgbackup/borg/releases/>`_
:Date: 2024-01-08

Borg 1.4 will become the next stable release in the near future.

It is quite similar to borg 1.2 (it was forked from 1.2-maint branch at 1.2.7 release),
but has a few bigger changes that needed alpha/beta/rc testing before it can be released.

Changelog summary
-----------------

This is only a summary of the changes between 1.2.7 and 1.4.
Check the `full changelog <https://borgbackup.readthedocs.io/en/1.4-maint/changes.html>`_
to see all changes as well as important compatibility and upgrade notes.


Major new features in the 1.4 release series are:

- BORG_EXIT_CODES=modern: optional more specific return codes (for errors and warnings).

Fixes:

- PATH: do not accept empty strings ("")

Other changes:

- require Python >= 3.9, Cython >= 3.0, msgpack >= 1.0.3
- modernize python packaging (use pyproject.toml)
- use pyinstaller 6.3.0 and python 3.11 for binary build
- new naming convention for fat binaries (include glibc version for linux)
