#!/usr/bin/env bash

for org in brew homebrew; do
    xsv search -s description '.*Quarterly.*' $org.csv | \
    xsv search -v -s expenseTags 'maintainer-stipend'
done
