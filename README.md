# Homebrew OpenCollective financial analysis

**:warning: VERY WIP as of January 2024. Don't rely on this for anything.**

This project is an analysis of Homebrew's public accounting through OpenCollective.

It is a hasty fork of [hledger_finance](https://github.com/simonmichael/hledger_finance),
the public bookkeeping of the hledger project.

## Regenerating data

Run:

    make csvs journals accounts check


_TODO: make one command, check, work._

## Reports
<!--
We most often get new transactions on the 23rd and 24th and for a few days around start of month.
To update:
1. `make update` to gather the csv, regenerate and check journal, update reports, and commit
2. Review commits, investigate/resolve any hledger version-related changes
3. Check latest calculated OC balance against the one reported on the website
   (hledger -f oc.journal bs, https://opencollective.com/homebrew#category-BUDGET > TODAY'S BALANCE)
   (hledger -f oc.journal bs, https://opencollective.com/brew#category-BUDGET > TODAY'S BALANCE)
-->
(Last column dates are an approximation, read them as "most recent report date".)
<!-- REPORTS: -->
