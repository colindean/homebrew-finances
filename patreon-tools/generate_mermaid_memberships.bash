#!/usr/bin/env bash

dates_list="$(jq -f get_dates_members_from_memberships.jq memberships.json | jq -r 'map_values(.date) | join(",")')"
cumulative_members_at_date="$(jq -f get_dates_members_from_memberships.jq memberships.json | jq -r 'map_values(.cumulative_sum_num_active_pledges) | join(",")')"


cat << HERE

xychart-beta
  title "Cumulative Active Patreon Members"
  x-axis [$dates_list]
  y-axis "Members" 0 --> 1000

  line [$cumulative_members_at_date]

HERE
