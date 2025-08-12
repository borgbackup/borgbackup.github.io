Borg 2.0 (preliminary information)
==================================

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

This is a breaking release; it is not directly compatible with Borg 1.x repositories
and thus not a quick upgrade.

Also, there were CLI changes; thus, you will need to review/edit your scripts.
Wrappers and GUIs for Borg also need to be adapted.

**The good news is:**

- If you like, you can efficiently copy your existing archives from old Borg
  1.x repositories to new Borg 2 repositories using "borg transfer" (you will need space
  and time for this, though).
- by doing a breaking release, we could:

  - fix a lot of long-term issues that could not (easily) be fixed in a non-
    breaking release
  - make the code cleaner and simpler, get rid of cruft and legacy
  - improve security, speed and parallelism
  - open doors for new features and applications that were not possible yet
  - make the docs shorter and make using Borg easier
- This is the first breaking release in many years, and we do not plan
  another one anytime soon.

Major new features
~~~~~~~~~~~~~~~~~~

- archive series

  Archives do not need to have unique names anymore, they may have the same
  name and we strongly recommend using this when appropriate as it simplifies
  and optimizes working with archives (caching, pruning, repo-list output).

  An archive series is now simply all the archives in a repository that have
  the same name. On the other hand, the unique identifier for a single archive is now its ID
  (the hash, which can be shortened as long as it is unique).

- separation of archive metadata: name, tags, user, host, timestamp

  To support having a simple, clean archive (series) name, Borg now tracks and
  displays name, tags, user, host, and timestamp separately (so you don't need to
  put everything into the archive name as when using Borg 1.x).

  It's now possible to tag (label) archives. There is a special tag for
  protecting archives against delete/prune/recreate.

  Matching can be done on archive (series) name, tags, user, host, and archive ID.

- new repository and locking implementation based on the borgstore project

  - borgstore is a key/value store in Python, currently supporting file:, sftp:,
    rclone:, and s3:/b2: backends.
    Borgstore backends are easy to implement, so there might be even more in
    the future.
  - Borg uses these to implement file: and ssh: repositories and (new) sftp: and
    rclone: repositories. Via rclone, Borg can use cloud repositories now!
  - In addition to ssh: repositories, we also have socket: repositories now.
  - Concurrent parallel access to a repository is now possible for most Borg
    commands (except check and compact).
  - A "repository index" is no longer needed because objects are directly
    found by their ID. The memory requirements of this index were proportional to
    the object count in the repository. Thus, Borg now needs less RAM.
  - Stale repository locks get auto-removed if they don't get refreshed or if
    their owner process is known dead.
  - Borg compact does much less I/O because it does not need to compact large
    "segment files" to free space; each repository object is now stored separately
    and thus can also be deleted individually.
  - Borg delete and prune are much faster now.
  - The repository works very differently now:

    - borg 1.x: transaction-based (commit or roll back), log-like, append-only
      segment files, precise refcounting, repo index needed, exclusive lock
      needed, checkpointing and .part files needed.
    - borg 2: convergence, write order, separate objects, no refcounting,
      garbage collection, no repo index needed, simplicity, mostly works with
      a shared lock, no need for checkpointing or .part files.

- uses a new hashtable (used for indexes, caches) based on the borghash project

  - chunks index: less memory overhead, lower memory usage spikes when resizing
    the hashtable.
  - files cache: less memory usage by referring to data already stored in the
    chunk index.
  - optimizes borg operations (e.g. create, compact, repo-compress) without
    needing any additional memory.
  - pure Cython implementation, easier to maintain than the previous C code.

- multi-repo improvements

  - Borg 1.x could only deal with one repository per Borg invocation. Borg 2.0
    now also knows about another repository (see --other-repo option) for some
    commands, like borg transfer, borg repo-create, ...
  - borg repo-create can create "related repositories" of an existing repo,
    e.g. to use them for efficient archive transfers using borg transfer.
  - borg transfer can copy and convert archives from a Borg 1.x repository to a
    related Borg 2 repository. To save time, it will transfer the compressed file
    content chunks without recompressing, but to make your repository more secure,
    it will decrypt/re-encrypt all the chunks.
  - borg transfer can copy archives from one Borg 2 repository to another related
    Borg 2 repository, without doing any conversion.
  - borg transfer usually transfers compressed chunks (avoids recompression),
    but there is also the option to recompress them using a specific
    compressor or re-chunk them with other chunker parameters.

- better, more modern, faster crypto

  - New keys/repos only use new crypto: AEAD, AES-OCB, ChaCha20-Poly1305,
    Argon2.
  - Using session keys: more secure and easier to manage, especially in multi-
    client or multi-repo contexts. By doing this, we could get rid of problematic
    long-term nonce/counter management.
  - The old crypto code will be removed in Borg 2.1 (currently we still need
    it to read from your old Borg 1.x repositories). Removing AES-CTR, PBKDF2,
    encrypt-and-mac, counter/nonce management will make Borg more secure,
    easier to use and develop.

- chunker improvements

  - New and improved "buzhash64" chunker
  - All chunker code is now in Cython (the buzhash chunker used to be a big,
    hard-to-maintain piece of C code that included file reading and buffer
    management). The file reading and buffer management code has been moved
    to a separate module.
  - All chunkers now use the same input file reading code that supports
    sparse files (and fmaps), posix_fadvise, and buffer management.

- Command-line interface cleanups

  - remote repository URLs default to relative paths, using an absolute path
    is possible.
  - no longer supports SCP-style repo parameters (parsing ambiguity issues; no
    :port possible); just use ssh://user@host:port/path.
  - Separated repo and archive; no "::" anymore
  - Split some commands that worked on archives and repositories into two separate
    commands (makes the code/docs/help easier).
  - Renamed Borg init to Borg repo-create for better consistency
  - BORG_EXIT_CODES=modern is the default now to get more specific process
    exit codes

- added commands/options:

  - you will usually need to give either -r (aka --repo) or BORG_REPO env var.
  - --match-archives now has support for:

    - identical, regex, or glob/shell-style matching on the archive name
    - matching on archive tags, user, host, and ID (prefix)
    - giving the option multiple times (logical AND)
  - extract --continue: continue a previously interrupted extraction
  - new borg repo-compress command can do a repo-wide efficient recompression.
  - borg analyze: list changed chunks' sizes per directory.
  - borg key change-location: usable for repokey <-> keyfile location change
  - borg benchmark cpu (so you can actually see what's fastest for your CPU)
  - borg import/export-tar --tar-format=GNU/PAX/BORG, support ctime/atime PAX
    headers, support for PAX xattr headers. GNU and PAX are standard formats,
    while BORG is a very low-level custom format only for borg usage. PAX is
    now the default format.
  - borg create: add the "slashdot hack" to strip path prefixes in created
    archives
  - borg repo-space: optionally, you can allocate some reserved space in the
    repo to free in "file system full" conditions.
  - borg version: show local/remote Borg version
  - borg prune: add quarterly pruning strategies (3M and 13W)
  - borg delete: it now SOFT-deletes archives and there is "borg undelete"
    to undo that. "borg compact" will free all space in the repository that
    belongs to soft-deleted archives, thus undelete only works for soft-deleted
    archives until you run the compaction.
  - borg prune: also only SOFT-deletes archives, see previous item.

- removed commands/options:

  - removed -P (aka --prefix) option; use -a (aka --match-archives) instead,
    e.g., -a 'PREFIX*'
  - borg upgrade (was only relevant for Attic/old Borg)
  - removed deprecated CLI options
  - Remove recreate --recompress option; the repo-wide "repo-compress" is
    more efficient.
  - Remove borg config command (it only worked locally anyway)
  - repository storage quota limit
  - repository append-only mode (was replaced by borgstore posixfs backend
    permissions [all, read-only, write-only, no-delete])

Other changes
~~~~~~~~~~~~~

- create: added retries for input files (e.g., if there is a read error or
  a file changes while reading)
- create: auto-exclude items based on xattrs or NODUMP
- new cache implementation, using a chunks cache stored in the repository and
  a files cache per archive series. The files cache now stores ctime AND mtime
  and also updates both from the filesystem. The files cache can be rebuilt by
  reading the latest archive in the series from the repository.
- Improve acl_get/acl_set error handling, refactor ACL code
- crypto: use a one-step KDF for session keys
- use setup.py less; use pip, build, and make.py
- using the platformdirs Python package to determine locations for configs and
  caches
- show files/archives with local timezone offsets, store archive timestamps
  with TZ offset
- make user/group/uid/gid optional in archived files
- make sure archive name/comment and other data that get into JSON are valid
  UTF-8 (no surrogate escapes)
- new remote and progress logging (tunneled through the RPC result channel)
- internal data format/processing changes

  - Using msgpack spec 2.0 now, cleanly differentiating between text and
    binary bytes. The older msgpack spec that Attic and Borg < 2.0 used did not
    have the binary type, so it was not pretty...
    Also using the msgpack Timestamp data type instead of self-made bigint
    stuff.
  - Archives: simpler, more symmetric handling of hard links ("hlid", all
    hard links have the same chunks list, if any). The old way was just a big
    pain (e.g., for partial extracting), ugly, and spread all over the code.
    The new way simplified the code a lot.
  - Item metadata: clean up, remove, rename, fix, precompute stuff
  - Chunks have separate encrypted metadata (size, csize, ctype, clevel).
    This saves time for borg repo-compress/recreate when recompressing to the same
    compressor, but another level. This also makes it possible to query size or
    csize without reading/transmitting/decompressing the chunk.
  - Remove legacy zlib compression header hack, so zlib works like all the
    other compressors. That hack was something we had to do back in the days
    because Attic backup did not have a compression header at all (because it
    only supported zlib).
  - Got rid of "csize" (compressed size of a chunk) in chunks index and
    archives. This often was just "in the way" and blocked the implementation
    of other (re)compression-related features.
  - Massively increase the archive metadata stream size limitation (so it is
    practically not relevant anymore)
  - Dynamic handling of missing (or reappearing) chunks replaces the Borg 1.x
    "chunks_healthy" metadata approach.

- source code changes

  - Borg 1.x borg.archiver and borg.helpers (and also the related tests)
    monster modules got split into packages of modules.
  - using "black" (automated PEP 8 source code formatting), this reformatted
    ALL the code
  - added infrastructure so we can use "mypy" for type checking

- python, packaging and library changes

  - minimum requirement: Python 3.10
  - we unbundled all third-party code and require the respective libraries to
    be available and installed. This makes packaging easier for distribution package
    maintainers.
  - discovery is done via pkg-config or (if that does not work) BORG_*_PREFIX
    env vars.
  - our setup*.py is now much simpler; a lot moved to pyproject.toml now.
  - we had to stop supporting LibreSSL (e.g., on OpenBSD) due to their
    different API. Borg on OpenBSD now also uses OpenSSL.

- getting rid of legacy stuff

  - removed some code only needed to deal with very old Attic or Borg repositories.
    Users are expected to first upgrade to Borg 1.2 before jumping to Borg
    2.0, thus we do not have to deal with any ancient stuff anymore.
  - removed archive and manifest TAMs, using a simpler approach with typed repo
    objects.
