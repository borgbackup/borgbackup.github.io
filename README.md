# www.borgbackup.org

These are the intro pages for Borg. They are hosted on GitHub pages with the project domain
CNAMEd to GitHub pages.

Since they describe multiple release series, they is not in the main docs, which only concern
themselves with *one* specific release.

The docs are managed on http://readthedocs.org/projects/borgbackup and available at https://borgbackup.readthedocs.io/en/latest/ (RTD).

The borgweb manual is on RTD as well: https://borgweb.readthedocs.io/

Previously documetation was hosted directly here, before the move to RTD.
There are still redirections (borgbackup/, borgweb/) to the RTD site here
to keep old URLs working for a while, although that doesn't work with sub-pages.

To manage the documentation and releases, see the development guide at: https://borgbackup.readthedocs.io/en/latest/development.html#building-the-docs-with-sphinx

------

The splash page (index.html) is meant to load very quickly with few external resources.
Other pages are generated from rST and rely on external resources (mostly CSS in _assets).

To update the HTML after editing a rST file, run `make`. Run `make commit-rebuild` to automatically
rebuild and commit changed HTML files.
