# www.borgbackup.org

These are the intro pages for Borg. They are hosted on GitHub pages with the project domain
CNAMEd to GitHub pages.

Since they describe multiple release series, they are not in the main docs, which only concern
themselves with *one* specific release.

The docs are managed on http://readthedocs.org/projects/borgbackup and available at https://borgbackup.readthedocs.io/en/latest/ (RTD).

The borgweb manual is on RTD as well: https://borgweb.readthedocs.io/

Previously documentation was hosted directly here, before the move to RTD.
There are still redirections (borgbackup/, borgweb/) to the RTD site here
to keep old URLs working for a while, although that doesn't work with sub-pages.

To manage the documentation and releases, see the development guide at: https://borgbackup.readthedocs.io/en/latest/development.html#building-the-docs-with-sphinx

------

All pages are meant to load very quickly with few/no external resources.

Pages (except index.html) are generated from rST.

To update the HTML after editing a rST file, run `make`.
Run `make commit-rebuild` to automatically rebuild and commit changed HTML files.
This requires a relatively recent docutils release, since it uses rst2html5.
