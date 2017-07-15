# www.borgbackup.org

[![Build Status](https://travis-ci.org/borgbackup/borgbackup.github.io.svg?branch=source)](https://travis-ci.org/borgbackup/borgbackup.github.io)

This is the project web site of Borg.

It is hosted on GitHub pages with the project domain CNAMEd to GitHub pages.

All pages are meant to load very quickly with few/no external resources. All pages are generated from rST.

HTML files are **never** committed to this ("source") branch. Travis automatically updates
the published ("master") branch.

To locally preview changes, update the HTML after editing a rST file, run `make`.
This requires a relatively recent docutils release, since it uses rst2html5.

## Release docs

Release documentation is published on RTD and released as part of the official tarballs,
as well as distributed in most distribution packages. They are only valid for their release.

The *release* docs are managed on http://readthedocs.org/projects/borgbackup and available at https://borgbackup.readthedocs.io/en/latest/ (RTD).

The *borgweb* manual is on RTD as well: https://borgweb.readthedocs.io/

Previously documentation was hosted directly here, before the move to RTD.
There are still redirections (borgbackup/, borgweb/) to the RTD site here
to keep old URLs working for a while, although that doesn't work with sub-pages.

To manage the documentation and releases, see the development guide at:
https://borgbackup.readthedocs.io/en/latest/development.html#building-the-docs-with-sphinx

## Travis setup

Travis builds the "source" branch, generates HTML, commits it and
pushes it to the "master" branch with a GitHub deploy key.

