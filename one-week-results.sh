#!/bin/bash
echo "Running"
seven_days_ago=$(date -v-7d +"%Y-%m-%d %H:%M:%S")

export last_updated_start_date="$seven_days_ago"

# Print the environment variable 
echo "last_updated_start_date is set to: $last_updated_start_date"

echo "{  
  \"policy_sandbox\": \"Policy\",
  \"report_type\": \"findings\",
  \"last_updated_start_date\": \"$last_updated_start_date\",
  \"last_updated_end_date\": \"$(date +"%Y-%m-%d %H:%M:%S")\"
}" > input.json
reporting_id=$(http --auth-type=veracode_hmac POST "https://api.veracode.com/appsec/v1/analytics/report" < input.json)
echo $reporting_id
id=$(echo $reporting_id | cut -d '"' -f6)
echo "pause for 15 seconds"
sleep 15
echo "resuming"
echo $id
# Enter in the ID from the previous method
http --auth-type=veracode_hmac GET "https://api.veracode.com/appsec/v1/analytics/report/$id" | jq . > report.json
echo "Finished processing. Filtered JSON saved to $output_file."
