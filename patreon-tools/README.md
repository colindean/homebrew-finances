# Patreon analysis tools

## Retrieving data

Patreon API doesn't seem to offer membership or financial data for creators.

Get it manually by visiting [`insights/membership`](https://www.patreon.com/insights/membership),
then using the inspector to get the response data for a call to


```
https://www.patreon.com/api/creator-analytics/membership-growth?timezone=America/New_York&aggperiod=MONTH&fetch_percent_change=false&aggregateby=tier_id&json-api-version=1.0&json-api-use-default-includes=false&include=[]
```

and/or

```
https://www.patreon.com/api/creator-analytics/free-membership-growth?timezone=America/New_York&aggperiod=MONTH&fetch_percent_change=false&json-api-version=1.0&json-api-use-default-includes=false&include=[]
```
