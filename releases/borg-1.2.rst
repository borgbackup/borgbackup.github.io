Borg 1.2
========

`« back to all releases <.>`_

:Links: `Documentation <https://borgbackup.readthedocs.io/en/1.2-maint/>`_ · `Installation <https://borgbackup.readthedocs.io/en/1.2-maint/installation.html>`_ · `Downloads <https://github.com/borgbackup/borg/releases/latest>`_
:Date: 2022-02-22

This marks the first stable release in the Borg 1.2 series. Many improvements and new features
were incorporated into Borg 1.2 since the 1.1 release of Borg in early 2017. Even more changes
were made "under the hood": cleanups and refactors.

Many people contributed to this release — see the AUTHORS file in the git repo and the
git history for details. Even more people contributed otherwise, e.g. by giving feedback
or helping with testing.

Special thanks also go to everyone and every organization donating funds to support development
and maintenance!

Since Borg 1.2 is now stable, it will primarily receive fixes and minor additions,
but not potentially problematic code changes. Principal development continues in master branch.

Changelog summary
-----------------

This is only a summary of the changes between 1.1 and 1.2.
Check the `full changelog <https://borgbackup.readthedocs.io/en/1.2-maint/changes.html>`_
to see all changes as well as important compatibility and upgrade notes.


Major new features in the 1.2 release series are:

- create: Internally use file descriptors rather than file names (as much as
  possible) to avoid race conditions on active file systems.
- create: Externalize file discovery via --paths-from-stdin and --paths-from-command.
  Using this, you can just feed a list of full path/filenames into borg and borg
  will create a backup archive with the corresponding files (no more, no less).
- create: --content-from-command: Create archive using stdout of given command.
- create: --compression: New 'obfuscate' pseudo compressor obfuscates compressed
  chunk sizes in the repository. You can use this to make chunk size fingerprinting
  attacks against your repo much harder. It will use more storage space for
  better privacy (and you can decide how much it is worth to you).
- create: --chunker-params: New, very fast 'fixed' block size chunker (also
  puts less load on the CPU compared to the buzhash chunker). Recommended for
  everything with a fixed block size, like disk devices, raw disk images,
  files with fixed record sizes (header record can be of different size).
- create: Improve sparse file support, much faster, especially when used
  together with the 'fixed' chunker.
- compact: Separate "borg compact" needs to be used to free repository space.
  Borg < 1.2 always compacted at the end of repo-writing commands, so these
  will be faster now. Also, you get kind of a "temporary append-only" behaviour
  until you invoke borg compact. For some users, less stuff moving around in
  the repo directory also might make rclones or rsyncs of their borg repo faster.
  "borg compact" can be invoked from the repo server, borg hosting providers can
  offer to use off-peak-hours for compaction.
- repository: Other optimizations for better speed and less stuff moving around.
- check: --max-duration: Incremental, time-limited repo check (crc32 check only).
  Users with huge repositories can use this to distribute their repo checks
  over multiple free time slots (for example, do a partial check each Sunday,
  resulting in a full check after multiple weeks).
- mount: Support new/maintained pyfuse3 as an alternative to the old llfuse lib.
- import-tar: New complement to export-tar. Import existing tar files or
  (together with export-tar) move archives from one borg repo to another.
  Please note that currently export-tar + import-tar is a lossy conversion as
  it does not support all metadata that borg create/extract supports (like
  ACLs, xattrs, flags).
- Minimal native Windows support, see Windows readme (WIP).

Other changes:

- create/recreate: Showing the current file name **before** starting to back it
  up makes life easier, especially for very big files which take a while...
- create: First ctrl-c (SIGINT) triggers checkpoint creation and then aborts.
- create: --remote-buffer: Use an upload buffer for remote repos.
- prune: Show which rule was applied to keep archive (kind of self-explanatory).
- check: Much faster when recovering data from corrupted segment files.
- New BORG_WORKAROUNDS mechanism.
- Works with recent Python, msgpack, PyInstaller, etc. versions.
- Major setup code refactoring (especially library handling), needs pypi "pkgconfig".
- Other major internal refactors / cleanups.
- Internal AEAD-style crypto API (not all you see in there is used already).
- Internal msgpack-wrapper to avoid current and future compatibility issues.
- Improved C code portability / basic MSC compatibility.
- Improved documentation (a lot of this was also backported to 1.1.x though).
