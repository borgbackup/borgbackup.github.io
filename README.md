# www.borgbackup.org

[![Build Status](https://github.com/borgbackup/borgbackup.github.io/workflows/Update%20pages/badge.svg)](https://github.com/borgbackup/borgbackup.github.io/actions)

This is the project web site of BorgBackup.

All pages are meant to load very quickly with few/no external resources. All pages are generated from rST.

HTML files are **never** committed to this ("source") branch. Github Actions automatically updates
the published ("master") branch. **Therefore pull requests should be submitted only to the "source" branch.**

To locally preview changes, update the HTML after editing a rST file, run `make`.
This requires a relatively recent docutils release, since it uses rst2html5.

## Release docs

Release documentation is published on RTD and released as part of the official tarballs,
as well as distributed in most distribution packages. They are only valid for their release.

The *release* docs are managed on https://readthedocs.org/projects/borgbackup and available at https://borgbackup.readthedocs.io/en/latest/ (RTD).

The *borgweb* manual is on RTD as well: https://borgweb.readthedocs.io/

Previously documentation was hosted directly here, before the move to RTD.
There are still redirections (borgbackup/, borgweb/) to the RTD site here
to keep old URLs working for a while, although that doesn't work with sub-pages.

To manage the documentation and releases, see the development guide at:
https://borgbackup.readthedocs.io/en/latest/development.html#building-the-docs-with-sphinx

## Setup

Github Actions builds the "source" branch, generates HTML, commits it and
pushes it to the "master" branch with a GitHub deploy key.

GitHub Pages is used as the host, TLS cert comes from LetsEncrypt (via GitHub).

More details: https://github.com/borgbackup/borgbackup.github.io/issues/45
