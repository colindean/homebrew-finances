.data.attributes.data["-1"] as $dataroot |
$dataroot._keys | map(
{
    date: . | tonumber | gmtime | strftime("%Y-%m"),
    cumulative_sum_num_active_pledges: $dataroot[.].cumulative_sum_num_active_pledges
}
)
