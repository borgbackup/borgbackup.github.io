Borg 2.0 (preliminary infos)
============================

:Links: `Documentation <https://borgbackup.readthedocs.io/en/master/>`_ · `Downloads <https://github.com/borgbackup/borg/releases/latest>`_
:Date: (testing releases out, no final release yet)

Changelog summary
-----------------

This is only a summary of the changes between 1.2/1.4 and 2.0.
Check the `full changelog <https://borgbackup.readthedocs.io/en/master/changes.html>`_
to see all changes as well as important compatibility and upgrade notes.

Breaking compatibility
~~~~~~~~~~~~~~~~~~~~~~

**The "bad" news first:**

This is a breaking release, it is not directly compatible with borg 1.x repos
and thus not a quick upgrade.

Also, there were cli changes, thus you will need to review/edit your scripts.
Wrappers and GUIs for borg also need to get adapted.

**The good news are:**

- if you like, you can efficiently copy your existing archives from old borg
  1.x repos to new borg 2 repos using "borg transfer" (you will need space
  and time for this, though).
- by doing a breaking release, we could:

  - fix a lot of long-term issues that could not (easily) be fixed in a non-
    breaking release
  - make the code cleaner and simpler, get rid of cruft and legacy
  - improve security, speed and parallelism
  - open doors for new features and applications that were not possible yet
  - make the docs shorter and using borg easier
- this is the first breaking release since many years and we do not plan
  another one anytime soon.

Major new features
~~~~~~~~~~~~~~~~~~

- archive series

  Archives do not need to have unique names anymore, they may have the same
  name and we strongly recommend using this when appropriate as it simplifies
  and optimizes working with archives (caching, pruning, repo-list output).

  An archives series is now simply all the archives in a repository that have
  the same name. OTOH, the unique identifier for a single archive is now its ID
  (the hash, it can be shortened as long as it is unique).

- new repository and locking implementation based on borgstore project

  - borgstore is a key/value store in python, currently supporting file:, sftp:
    and rclone: backends.
    borgstore backends are easy to implement, so there might be even more in
    future.
  - borg uses these to implement file: and ssh: repos and (new) sftp: and
    rclone: repos. Via rclone, borg can use cloud repositories now!
  - additionally to ssh: repos, we also have socket: repos now.
  - concurrent parallel access to a repository is now possible for most borg
    commands (except check and compact).
  - a "repository index" is not needed anymore because objects are directly
    found by their ID. the memory needs of this index were proportional to
    the object count in the repository, thus borg now needs less RAM.
  - stale repository locks get auto-removed if they don't get refreshed or if
    their owner process is known-dead.
  - borg compact does much less I/O because it doesn't need to compact large
    "segment files" to free space, each repo object is now stored separately
    and thus can be deleted individually also.
  - borg delete and prune are much faster now.
  - the repository works very differently now:

    - borg 1.x: transaction-based (commit or roll back), log-like, append-only
      segment files, precise refcounting, repo index needed, exclusive lock
      needed, checkpointing and .part files needed.
    - borg 2: convergence, write-order, separate objects, no refcounting,
      garbage collection, no repo index needed, simplicity, mostly works with
      a shared lock, no need for checkpointing or .part files.

- multi-repo improvements

  - borg 1.x only could deal with 1 repository per borg invocation. borg 2.0
    now also knows about another repo (see --other-repo option) for some
    commands, like borg transfer, borg repo-create, ...
  - borg repo-create can create "related repositories" of an existing repo,
    e.g. to use them for efficient archive transfers using borg transfer.
  - borg transfer can copy and convert archives from a borg 1.x repo to a
    related borg 2 repo. to save time, it will transfer the compressed file
    content chunks without recompressing. but, to make your repo more secure,
    it will decrypt / re-encrypt all the chunks.
  - borg transfer can copy archives from one borg 2 repo to a related other
    borg 2 repo, without doing any conversion.
  - borg transfer usually transfers compressed chunks (avoids recompression),
    but there is also the option to recompress them using a specific
    compressor.

- better, more modern, faster crypto

  - new keys/repos only use new crypto: AEAD, AES-OCB, chacha20-poly1305,
    argon2.
  - using session keys: more secure and easier to manage, especially in multi-
    client or multi-repo contexts. doing this, we could get rid of problematic
    long term nonce/counter management.
  - the old crypto code will get removed in borg 2.1 (currently we still need
    it to read from your old borg 1.x repos). removing AES-CTR, pbkdf2,
    encrypt-and-mac, counter/nonce management will make borg more secure,
    easier to use and develop.

- command line interface cleanups

  - no scp style repo parameters any more (parsing ambiguity issues, no
    :port possible), just use the better ssh://user@host:port/path .
  - separated repo and archive, no "::" any more
  - split some commands that worked on archives and repos into 2 separate
    commands (makes the code/docs/help easier)
  - renamed borg init to borg repo-create for better consistency
  - BORG_EXIT_CODES=modern is the default now to get more specific process
    exit codes

- added commands / options:

  - you will usually need to give either -r (aka --repo) or BORG_REPO env var.
  - --match-archives now has support for regex or glob/shell style matching
  - extract --continue: continue a previously interrupted extraction
  - new borg repo-compress command can do a repo-wide efficient recompression.
  - borg key change-location: usable for repokey <-> keyfile location change
  - borg benchmark cpu (so you can actually see what's fastest for your CPU)
  - borg import/export-tar --tar-format=GNU/PAX/BORG, support ctime/atime PAX
    headers. GNU and PAX are standard formats, while BORG is a very low-level
    custom format only for borg usage.
  - borg create: add the "slashdot hack" to strip path prefixes in created
    archives
  - borg repo-space: optionally, you can allocate some reserved space in the
    repo to free in "file system full" conditions.
  - borg version: show local/remote borg version

- removed commands / options:

  - removed -P (aka --prefix) option, use -a (aka --match-archives) instead,
    e.g.: -a 'PREFIX*'
  - borg upgrade (was only relevant for attic / old borg)
  - removed deprecated cli options
  - remove recreate --recompress option, the repo-wide "repo-compress" is
    more efficient.
  - remove borg config command (it only worked locally anyway)
  - repository storage quota limit (might come back if we find a more useful
    implementation)
  - repository append-only mode (might come back later, likely implemented
    very differently)

Other changes
~~~~~~~~~~~~~

- create: added retries for input files (e.g. if there is a read error or
  file changed while reading)
- new cache implementation, using a chunks cache stored in the repository and
  a files cache per archive series. the files cache now stores ctime AND mtime
  and also updates both from the filesystem. the files cache can be rebuilt by
  reading the latest archive in the series from the repository.
- improve acl_get / acl_set error handling, refactor acl code
- crypto: use a one-step kdf for session keys
- use less setup.py, use pip, build and make.py
- using platformdirs python package to determine locations for configs and
  caches
- show files / archives with local timezone offsets, store archive timestamps
  with tz offset
- make user/group/uid/gid optional in archived files
- make sure archive name/comment, stuff that get into JSON is pure valid
  utf-8 (no surrogate escapes)
- new remote and progress logging (tunneled through RPC result channel)
- internal data format / processing changes

  - using msgpack spec 2.0 now, cleanly differentiating between text and
    binary bytes. the older msgpack spec attic and borg < 2.0 used did not
    have the binary type, so it was not pretty...
    also using the msgpack Timestamp data type instead of self-made bigint
    stuff.
  - archives: simpler, more symmetric handling of hardlinks ("hlid", all
    hardlinks have same chunks list, if any). the old way was just a big
    pain (e.g. for partial extracting), ugly and spread all over the code.
    the new way simplified the code a lot.
  - item metadata: clean up, remove, rename, fix, precompute stuff
  - chunks have separate encrypted metadata (size, csize, ctype, clevel).
    this saves time for borg repo-compress/recreate when recompressing to same
    compressor, but other level. this also makes it possible to query size or
    csize without reading/transmitting/decompressing the chunk.
  - remove legacy zlib compression header hack, so zlib works like all the
    other compressors. that hack was something we had to do back in the days
    because attic backup did not have a compression header at all (because it
    only supported zlib).
  - got rid of "csize" (compressed size of a chunk) in chunks index and
    archives. this often was just "in the way" and blocked the implementation
    of other (re)compression related features.
  - massively increase the archive metadata stream size limitation (so it is
    practically not relevant any more)

- source code changes

  - borg 1.x borg.archiver (and also the related tests) monster modules got
    split into packages of modules, now usually 1 module per borg cli command.
  - using "black" (automated pep8 source code formatting), this reformatted
    ALL the code
  - added infrastructure so we can use "mypy" for type checking

- python, packaging and library changes

  - minimum requirement: Python 3.9
  - we unbundled all 3rd party code and require the respective libraries to
    be available and installed. this makes packaging easier for dist package
    maintainers.
  - discovery is done via pkg-config or (if that does not work) BORG_*_PREFIX
    env vars.
  - our setup*.py is now much simpler, a lot moved to pyproject.toml now.
  - we had to stop supporting LibreSSL (e.g. on OpenBSD) due to their
    different API. borg on OpenBSD now also uses OpenSSL.

- getting rid of legacy stuff

  - removed some code only needed to deal with very old attic or borg repos.
    users are expected to first upgrade to borg 1.2 before jumping to borg
    2.0, thus we do not have to deal with any ancient stuff any more.
  - removed archive and manifest TAMs, using simpler approach with typed repo
    objects.
