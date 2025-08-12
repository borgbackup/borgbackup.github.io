# www.borgbackup.org

[![Build Status](https://github.com/borgbackup/borgbackup.github.io/workflows/Update%20pages/badge.svg)](https://github.com/borgbackup/borgbackup.github.io/actions)

This is the project website of BorgBackup.

All pages are meant to load very quickly with few or no external resources. All pages are generated from reStructuredText (reST).

HTML files are **never** committed to this ("source") branch. GitHub Actions automatically updates
the published ("master") branch. **Therefore pull requests should be submitted only to the "source" branch.**

To locally preview changes and update the HTML after editing an .rst file, run `make`. To clean all rendered HTML and remake, run `make clean all`. 
This requires a relatively recent Docutils release, since it uses rst2html5. To install rst2html5, run: `python3 -m pip install rst2html5`.

## Release docs

Release documentation is published on RTD and released as part of the official tarballs,
as well as distributed in most distribution packages. These are only valid for their respective releases.

The *release* docs are managed on https://readthedocs.org/projects/borgbackup and available at https://borgbackup.readthedocs.io/en/latest/ (RTD).

The *borgweb* manual is on RTD as well: https://borgweb.readthedocs.io/

Previously, the documentation was hosted directly here before the move to RTD.
There are still redirects (borgbackup/, borgweb/) to the RTD site here
to keep old URLs working for a while; however, that does not work with subpages.

To manage the documentation and releases, see the development guide at:
https://borgbackup.readthedocs.io/en/latest/development.html#building-the-docs-with-sphinx

## Setup

GitHub Actions builds the "source" branch, generates HTML, commits it, and
pushes it to the "master" branch with a GitHub deploy key.

GitHub Pages is used as the host, and the TLS certificate comes from Let's Encrypt (via GitHub).

More details: https://github.com/borgbackup/borgbackup.github.io/issues/45
