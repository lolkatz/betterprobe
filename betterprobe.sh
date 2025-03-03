#!/bin/bash

while IFS= read -r url; do
	url="https://$url"
        # Check if the site is up and get HTTP status code
        http_status=$(curl -o /dev/null -s -L -w "%{http_code}" "$url")

        if [ "$http_status" -eq "000" ]; then
                echo "Error connecting"
                echo "$url"
                wget --spider --https-only --timeout=15 --tries=1 $url -o error.txt
                cat error.txt | grep -E "ERROR|failed"
                echo ""
		echo "$url" >> invalidCertificate.txt
        elif [ "$http_status" -ne "200" ]; then
                echo "Not OK"
                echo "$url"
                echo "$http_status"
                echo ""
        fi
done < "$1"
echo "$SECONDS seconds"
