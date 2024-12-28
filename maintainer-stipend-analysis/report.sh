#!/usr/bin/env bash

set -eu -o pipefail

YEAR="${YEAR:-$(date +%Y)}"

echo "Looking at year ${YEAR}"

rm -f _names.csv _sum.csv

echo "sum" > _sum.csv

for org in brew homebrew; do
    echo "Looking at org ${org}"
    xsv search -s expenseTags 'maintainer-stipend' ${org}.csv | \
    xsv search -s kind EXPENSE | \
    xsv search -s datetime "^${YEAR}" | \
    xsv select amount,oppositeAccountSlug \
    > ${org}__names-amounts.csv

    xsv select oppositeAccountSlug ${org}__names-amounts.csv | tail -n +2 | sort -u >> _names.csv

    xsv select amount ${org}__names-amounts.csv | xsv stats | xsv select sum | tail -n +2 >> _sum.csv
done

echo "Count of people":
sort -u _names.csv | wc -l

echo "Sum of amounts:"
xsv stats _sum.csv | xsv select sum | tail -n +2
