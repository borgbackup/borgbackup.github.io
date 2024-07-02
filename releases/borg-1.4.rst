Borg 1.4
========

:Links: `Documentation <https://borgbackup.readthedocs.io/en/1.4-maint/>`_ · `Installation <https://borgbackup.readthedocs.io/en/1.4-maint/installation.html>`_ · `Downloads <https://github.com/borgbackup/borg/releases/>`_
:Date: 2024-07-03

This marks the first stable release in the Borg 1.4 series, which is a refreshed / modernised
continuation of the borg 1.2 codebase with a few bigger new features, but otherwise proven,
stable code and quite similar to use as Borg 1.2.

Thanks to everybody who contributed to development or maintenance, either by their time or by funding!

Since Borg 1.4 is now stable, it will primarily receive fixes and minor additions,
but not potentially problematic code changes. Principal development continues in the master branch.

Changelog summary
-----------------

This is only a summary of the changes between 1.2.7 and 1.4.
Check the `full changelog <https://borgbackup.readthedocs.io/en/1.4-maint/changes.html>`_
to see all changes as well as important compatibility and upgrade notes.

Major new features in the 1.4 release series are:

- BORG_EXIT_CODES=modern: optional more specific return codes (for errors and warnings)
- borg create: add the "slashdot hack" to strip recursion root prefixes
- borg version REPO: show version of borg client and server

Other bigger changes:

- ACL code: refactor, improve acl_get / acl_set error handling
- require Python >= 3.9, Cython >= 3.0.3, msgpack >= 1.0.3
- removed bundled 3rd party code (lz4/zstd/xxhash)
- modernised python packaging (use pyproject.toml, use less setup.py)
- use pyinstaller 6.7.0 and python 3.11 for the binary builds
- new naming convention for fat binaries (include glibc version for linux)
