#!/bin/bash

# Default values
start_ip="192.100.0.0"
end_ip="192.100.255.255"
output_file="output.txt"
add_prefix=false

# Developer information
developer_name="\e[32m@AGNIHACKERS1\e[0m"
personal_website="\e[32;4mhttps://www.zhackx.com/\e[0m"

# Function to display help
display_help() {
    echo -e "\e[38;5;166mDeveloper:\e[0m $developer_name"
    echo -e "\e[38;5;166mPersonal Website:\e[0m $personal_website"
    
    echo -e "\e[38;5;166mUsage:\e[0m \e[33m$0 [-r] [-h] [-s start_ip] [-e end_ip] [-o output_file]\e[0m"
    echo -e "\e[33mOptions:\e[0m"
    echo -e "   \e[34m-r\e[0m                Add http:// and https:// prefixes"
    echo -e "   \e[34m-h\e[0m \e[33m--help\e[0m         Display this help message"
    echo -e "  \e[34m--s\e[0m \e[33mstart_ip\e[0m       Set the start IP address (default: $start_ip)"
    echo -e "  \e[34m--e\e[0m \e[33mend_ip\e[0m         Set the end IP address (default: $end_ip)"
    echo -e "  \e[34m--o\e[0m \e[33moutput_file\e[0m    Set the output file (default: $output_file)"
    exit 0
}

# Loop through the options
while getopts "rhs:e:o:" opt; do
    case $opt in
        r)
            add_prefix=true
            ;;
        h)
            display_help
            ;;
        s)
            start_ip="$OPTARG"
            ;;
        e)
            end_ip="$OPTARG"
            ;;
        o)
            output_file="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# Function to convert IP address to integer
ip_to_int() {
    local ip="$1"
    local a b c d
    IFS=. read -r a b c d <<< "$ip"
    echo "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}

# Function to convert integer to IP address
int_to_ip() {
    local num="$1"
    echo "$((num >> 24 & 255)).$((num >> 16 & 255)).$((num >> 8 & 255)).$((num & 255))"
}

# Loop through the IP range and save to the output file
current_ip=$(ip_to_int "$start_ip")
end_ip_int=$(ip_to_int "$end_ip")

while [ "$current_ip" -le "$end_ip_int" ]; do
    current_ip_address=$(int_to_ip "$current_ip")

    # Add http:// and https:// prefixes if the flag is set
    if $add_prefix; then
        echo "http://$current_ip_address" >> "$output_file"
        echo "https://$current_ip_address" >> "$output_file"
    else
        # Print normal domain name without prefixes
        echo "$current_ip_address" >> "$output_file"
    fi

    current_ip=$((current_ip + 1))
done

# Print developer information
echo -e "Developer: $developer_name"
echo -e "Personal Website: $personal_website"

# Print completion message
echo "IP list generation completed. The list has been saved to $output_file."

# Exit the script
exit 0

