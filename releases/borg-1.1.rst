Borg 1.1
========

`« back to all releases <.>`_

:Links: `Documentation <https://borgbackup.readthedocs.io/en/stable/>`_ · `Installation <https://borgbackup.readthedocs.io/en/stable/installation.html>`_ · `Downloads <https://github.com/borgbackup/borg/releases/latest>`_
:Date: 7th July 2017

This marks the first stable release in the Borg 1.1 series. Many improvements and new features
were incorporated into Borg 1.1 since the 1.0 release of Borg in early 2016.

More than sixty people contributed code to this release — see Contributors_ on this page —
and 2016-2017 has been a fantastic time for the Borg project.

Since Borg 1.1 is now stable, it will only receive fixes and minor additions,
no larger new features. Principal development continues in the
`Borg 1.2 <https://github.com/borgbackup/borg/wiki/Borg-1.2>`_ series.

Changelog summary
-----------------

This is only a summary of the changes between 1.0 and 1.1.
Check the `full changelog <https://borgbackup.readthedocs.io/en/stable/changelog.html>`_
to see all changes.

Major new features in the 1.1 release series are:

- borg recreate: remove files from existing archives and re-chunk or re-compress them.
  This finally allows deduplication between legacy Attic / Borg 0.xx archives and Borg 1.x archives.
  This is an experimental feature.
- borg diff: show differences between two archives.
- borg mount: show all versions of a file with the "versions view".
- borg list: more formatting options, including generation of hashes and per-file chunk statistics.
- borg create: automatic compression mode (-C auto,zlib/lz4/...), faster handling of many files,
  experimental support for inclusion patterns (--patterns, --patterns-from).
- borg export-tar: streaming export of GNU tar compatible archives.
- Archive comments
- BLAKE2b256-based encryption modes, and "authenticated" modes that provide data integrity without encryption.
  These provide better performance than the existing SHA-256-based modes on most hardware, except where
  the x86 SHA extensions are available (e.g. AMD Ryzen).
- Repository indices and the Borg cache now use checksums to detect bitrot and other corruption.
- A documented JSON API has been added to the most vital commands (borg list, borg info and borg create).
- Structured JSON logging is available for all commands.

Quality of life improvements:

- options that imply output (--show-rc, --show-version, --list, --stats, --progress) don't need -v/--info to have that output displayed any more.
- borg check is silent by default (finally!).
- Automatic removal of stale locks, which should make "borg break-lock" essentially superfluous.
  This is enabled by default, see BORG_HOSTNAME_IS_UNIQUE.
- Answers to prompts like "Accessing previously unknown repository" are now saved immediately.
- Cache synchronization and "borg info" are now faster.
- Reduced space usage of chunks.archive.d in the cache by 30-40 %. Existing caches are migrated during a cache sync.
- The cache used for remote cache syncs and mounting remote repositories does not grow indefinitely any more,
  but adapts to the available space. Good riddance, TMP=/var/tmp!
- BORG_PASSCOMMAND makes using key rings and hardware keys much easier.

Compatibility notes for upgrading from Borg 1.0 to Borg 1.1:

- **No explicit "borg upgrade" is required.**
- Borg 1.1 uses some new data structures which are backwards-compatible with Borg 1.0.4 and newer.
- Borg 1.0 can't make use of Borg 1.1's "compact cache" and will silently ignore it.
- The default compression has been changed from "none" to "lz4".
- Repositories in the "repokey" and "repokey-blake2" modes with an empty passphrase are now treated as
  unencrypted repositories for security checks (e.g. BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK).
- borg init: -e/--encryption is now a mandatory option with no default value.
- borg create: the --exclude-if-present option now supports tagging a folder with any file system
  object type (file, folder, etc.), instead of accepting only files as tags.
- borg init: running "borg init" via a "borg serve --append-only" server will *not* create
  an append-only repository any more. Use "borg init --append-only" to initialize an append-only repository.
- "borg migrate-to-repokey" has been renamed to "borg key migrate-to-repokey" with no deprecation notice,
  since it is rarely and only manually used.

Deprecated options and commands in Borg 1.1, which will be removed in Borg 1.2:

- "borg change-passphrase" is deprecated, use "borg key change-passphrase" instead.
  "borg change-passphrase" will be removed in Borg 1.2.
- borg create: the --keep-tag-files option has been deprecated in favour of the new --keep-exclude-tags option.
  Both options have the same effect. --keep-tag-files will be removed in Borg 1.2.

Contributors
------------

We'd like to thank everyone who contributed to Borg, be it code, bug reports, testing,
documentation, creating packages or spreading the word.

Contributors to the main repository for this release were:

.. git log 1.0.0..master  --format=format:%an | sort | uniq

.. The .contributor spans avoid word-wrapping names, since that's a rude thing to do.

.. container:: contributors

  .. raw:: html

    <span class='contributor'>Abdel-Rahman A. ·</span>
    <span class='contributor'>Aleksander Charatonik ·</span>
    <span class='contributor'>Alexander 'Leo' Bergolth ·</span>
    <span class='contributor'>Alexander Pyhalov ·</span>
    <span class='contributor'>Andrew Engelbrecht ·</span>
    <span class='contributor'>Andrew Skalski ·</span>
    <span class='contributor'>Antoine Beaupré ·</span>
    <span class='contributor'>Ben Creasy ·</span>
    <span class='contributor'>Benedikt Heine ·</span>
    <span class='contributor'>Benedikt Neuffer ·</span>
    <span class='contributor'>Benjamin Pereto ·</span>
    <span class='contributor'>Björn Ketelaars ·</span>
    <span class='contributor'>Brian Johnson ·</span>
    <span class='contributor'>Carlo Teubner ·</span>
    <span class='contributor'>Chris Lamb ·</span>
    <span class='contributor'>Dan Christensen ·</span>
    <span class='contributor'>Dan Helfman ·</span>
    <span class='contributor'>Daniel Reichelt ·</span>
    <span class='contributor'>Danny Edel ·</span>
    <span class='contributor'>Ed Blackman ·</span>
    <span class='contributor'>Florent Hemmi ·</span>
    <span class='contributor'>Florian Klink ·</span>
    <span class='contributor'>Frank Sachsenheim ·</span>
    <span class='contributor'>Fredrik Mikker ·</span>
    <span class='contributor'>Félix Sipma ·</span>
    <span class='contributor'>Hans-Peter Jansen ·</span>
    <span class='contributor'>Hartmut Goebel ·</span>
    <span class='contributor'>infectormp ·</span>
    <span class='contributor'>James Clarke ·</span>
    <span class='contributor'>Janne K ·</span>
    <span class='contributor'>Jens Rantil ·</span>
    <span class='contributor'>Joachim Breitner ·</span>
    <span class='contributor'>Johann Bauer ·</span>
    <span class='contributor'>Johannes Wienke ·</span>
    <span class='contributor'>Jonathan Zacsh ·</span>
    <span class='contributor'>Julian Andres Klode ·</span>
    <span class='contributor'>Klemens ·</span>
    <span class='contributor'>kmq ·</span>
    <span class='contributor'>Lauri Niskanen ·</span>
    <span class='contributor'>Lee Bousfield ·</span>
    <span class='contributor'>Leo Antunes ·</span>
    <span class='contributor'>Leo Famulari ·</span>
    <span class='contributor'>Marian Beermann ·</span>
    <span class='contributor'>Mark Edgington ·</span>
    <span class='contributor'>Martin Hostettler ·</span>
    <span class='contributor'>Michael Gajda ·</span>
    <span class='contributor'>Michael Herold ·</span>
    <span class='contributor'>Milkey Mouse ·</span>
    <span class='contributor'>Mitch Bigelow ·</span>
    <span class='contributor'>Nathan Musoke ·</span>
    <span class='contributor'>Oleg Drokin ·</span>
    <span class='contributor'>ololoru ·</span>
    <span class='contributor'>Pankaj Garg ·</span>
    <span class='contributor'>Patrick Goering ·</span>
    <span class='contributor'>Radu Ciorba ·</span>
    <span class='contributor'>Robert Marcano ·</span>
    <span class='contributor'>Ronny Pfannschmidt ·</span>
    <span class='contributor'>rugk ·</span>
    <span class='contributor'>schuft69 ·</span>
    <span class='contributor'>Simon Heath ·</span>
    <span class='contributor'>Stefan Tatschner ·</span>
    <span class='contributor'>Stefano Probst ·</span>
    <span class='contributor'>Steve Groesz ·</span>
    <span class='contributor'>sven ·</span>
    <span class='contributor'>Thomas Waldmann ·</span>
    <span class='contributor'>TuXicc ·</span>
    <span class='contributor'>wormingdead</span>

Special thanks also go to everyone and every organization donating funds
to support development and maintainers:

.. Manually gathered from BountySource, https://www.bountysource.com/teams/borgbackup/backers

.. container:: contributors

  .. raw:: html

    <span class='contributor'>storcium ·</span>
    <span class='contributor'>IT Service Group of the Department of Computer Science, ETH Zürch ·</span>
    <span class='contributor'>TheVillux ·</span>
    <span class='contributor'>Daniel Parks ·</span>
    <span class='contributor'>Dave Barker ·</span>
    <span class='contributor'>Roland Moriz ·</span>
    <span class='contributor'>alraban ·</span>
    <span class='contributor'>level323 ·</span>
    <span class='contributor'>Magnus Månsson ·</span>
    <span class='contributor'>Bluebeep ·</span>
    <span class='contributor'>William Weiskopf ·</span>
    <span class='contributor'>kleptos ·</span>
    <span class='contributor'>lf ·</span>
    <span class='contributor'>rmiceli ·</span>
    <span class='contributor'>Kirrus ·</span>
    <span class='contributor'>DrTyrell ·</span>
    <span class='contributor'>Thomas Waldmann ·</span>
    <span class='contributor'>stevesbrain ·</span>
    <span class='contributor'>martin ·</span>
    <span class='contributor'>neutrinus ·</span>
    <span class='contributor'>Jeremy Audet (=lchimonji10) ·</span>
    <span class='contributor'>DrupaListo ·</span>
    <span class='contributor'>mario ·</span>
    <span class='contributor'>Jason Harris ·</span>
    <span class='contributor'>iamnumbersix ·</span>
    <span class='contributor'>(unknown) ·</span>
    <span class='contributor'>kwaa ·</span>
    <span class='contributor'>Michael Gajda ·</span>
    <span class='contributor'>Twilek ·</span>
    <span class='contributor'>lazlor ·</span>
    <span class='contributor'>Christopher Lijlenstolpe ·</span>
    <span class='contributor'>Marian Beermann ·</span>
    <span class='contributor'>twink0r ·</span>
    <span class='contributor'>Andreas Schamanek ·</span>
    <span class='contributor'>Abdel-Rahman A. ·</span>
    <span class='contributor'>multikatt ·</span>
    <span class='contributor'>kiz ·</span>
    <span class='contributor'>jgtimm ·</span>
    <span class='contributor'>infectormp ·</span>
    <span class='contributor'>Paolo Dina ·</span>
    <span class='contributor'>Aravindh ·</span>
    <span class='contributor'>Quallenauge ·</span>
    <span class='contributor'>reyman
