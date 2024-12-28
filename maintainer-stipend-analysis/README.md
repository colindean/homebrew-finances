# Maintainer analysis (quick)

Quick and dirty way to get:

1. Count of maintainers paid
1. Sum of payments

## How to run

Set YEAR envvar, or this will use the current year.

```sh
bash get.sh       # get the CSV data, delete it if errors, won't overwrite
bash find_bad.sh  # find any transactions that have "Quarterly" but aren't labeled
bash report.sh    # generate the report
```
