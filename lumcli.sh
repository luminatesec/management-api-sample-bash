#! /bin/bash
# Luminate CLI Prototype - Sample for using Luminate Management REST API using Bash
# https://github.com/luminatesec/management-api-sample-bash
#
# Based on Bash shell script template for readability CLI
# https://github.com/vorachet/bash-cli-template
#  
# Tested with GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin15)

BASH_CLI_ALL_ARGS=${@:2}
BASH_CLI_CURRENT_CMD_INDEX=0
BASH_CLI_SCRIPT_NAME="lumcli.sh"



BASH_CLI_OPT_NAME[0]="connect"
BASH_CLI_OPT_NAME[1]="sites-list"
BASH_CLI_OPT_NAME[2]="apps-list"
BASH_CLI_OPT_NAME[3]="-c"
BASH_CLI_OPT_NAME[4]="-s"
BASH_CLI_OPT_NAME[5]="-t"
BASH_CLI_OPT_NAME[6]="apps-details"
BASH_CLI_OPT_NAME[7]="-o"
BASH_CLI_OPT_NAME[8]="-n"
BASH_CLI_OPT_NAME[9]="ssh-connect"
BASH_CLI_OPT_NAME[10]="-i"
BASH_CLI_OPT_NAME[11]="tcp-connect"
BASH_CLI_OPT_NAME[12]="-U"


BASH_CLI_OPT_ALT_NAME[0]="Connect"
BASH_CLI_OPT_ALT_NAME[1]="ListSites"
BASH_CLI_OPT_ALT_NAME[2]="ListApps"
BASH_CLI_OPT_ALT_NAME[3]="--client_id"
BASH_CLI_OPT_ALT_NAME[4]="--client_secret"
BASH_CLI_OPT_ALT_NAME[5]="--access_token"
BASH_CLI_OPT_ALT_NAME[6]="AppDetails"
BASH_CLI_OPT_ALT_NAME[7]="--object_id"
BASH_CLI_OPT_ALT_NAME[8]="--object_name"
BASH_CLI_OPT_ALT_NAME[9]="SshConnect"
BASH_CLI_OPT_ALT_NAME[10]="--identity"
BASH_CLI_OPT_ALT_NAME[11]="TcpConnect"
BASH_CLI_OPT_ALT_NAME[12]="--env_url"


BASH_CLI_OPT_DATA_TYPE[0]="cmd"
BASH_CLI_OPT_DATA_TYPE[1]="cmd"
BASH_CLI_OPT_DATA_TYPE[2]="cmd"
BASH_CLI_OPT_DATA_TYPE[3]="string"
BASH_CLI_OPT_DATA_TYPE[4]="string"
BASH_CLI_OPT_DATA_TYPE[5]="string"
BASH_CLI_OPT_DATA_TYPE[6]="cmd"
BASH_CLI_OPT_DATA_TYPE[7]="string"
BASH_CLI_OPT_DATA_TYPE[8]="string"
BASH_CLI_OPT_DATA_TYPE[9]="cmd"
BASH_CLI_OPT_DATA_TYPE[10]="string"
BASH_CLI_OPT_DATA_TYPE[11]="cmd"
BASH_CLI_OPT_DATA_TYPE[12]="string"




BASH_CLI_OPT_DESC[0]="Connect to Luminate Management API and generate a session token\n\n\t\t\t\t\tRequired flags:\n\t\t\t\t\t-c <Client ID> or LUMINATE_CLIENT_ID environment variable\n\t\t\t\t\t-s <Client Secret> or LUMINATE_CLIENT_SECRET environment variable\n\t\t\t\t\t-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable"
BASH_CLI_OPT_DESC[1]="Retrieve list of all sites\n\n\t\t\t\t\tRequired flags:\n\t\t\t\t\t-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable\n\t\t\t\t\t-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable"
BASH_CLI_OPT_DESC[2]="Retrieve list of all applicatons\n\n\t\t\t\t\tRequired flags:\n\t\t\t\t\t-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable\n\t\t\t\t\t-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable"
BASH_CLI_OPT_DESC[3]="Luminate Management API Client ID"
BASH_CLI_OPT_DESC[4]="Luminate Management API Client Secret"
BASH_CLI_OPT_DESC[5]="Luminate Management API Access Token"
BASH_CLI_OPT_DESC[6]="Get application details\n\n\t\t\t\t\tRequired flags:\n\t\t\t\t\t-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable\n\t\t\t\t\t-n <Application Name> or -o <Application ID>\n\t\t\t\t\t-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable"
BASH_CLI_OPT_DESC[7]="ID of the relevant object"
BASH_CLI_OPT_DESC[8]="Name of the relevant object"
BASH_CLI_OPT_DESC[9]="Connect to an SSH Server\n\n\t\t\t\t\tRequired flags:\n\t\t\t\t\t-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable\n\t\t\t\t\t-n <Application Name> or -o <Application ID>\n\t\t\t\t\t-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable\n\n\t\t\t\t\tOptional flags:\n\t\t\t\t\t-i <Path to Luminate SSH Key in PEM format>"
BASH_CLI_OPT_DESC[10]="Path to identity file (private key) for public key authentication"
BASH_CLI_OPT_DESC[11]="Connect to TCP Port maps\n\n\t\t\t\t\tRequired flags:\n\t\t\t\t\t-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable\n\t\t\t\t\t-n <Application Name> or -o <Application ID>\n\t\t\t\t\t-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable\n\n\t\t\t\t\tOptional flags:\n\t\t\t\t\t-i <Path to Luminate SSH Key in PEM format>"
BASH_CLI_OPT_DESC[12]="Luminate environment URL (such as company.luminatesec.com)"




# Create an API session with Luminate Management API
# Returns a session token
connect() {
      #echo "Creating a new Luminate Management API Session"

      # -c | --client_id
      local client_id=${BASH_CLI_OPT_VALUE[3]}

      # -s | --client_secret
      local client_secret=${BASH_CLI_OPT_VALUE[4]}

      if [ "$client_id" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_CLIENT_ID}" ]]; then
                  echo Error: -c argument or LUMINATE_CLIENT_ID environment variable are required
                  exit 1
            else
                  client_id="${LUMINATE_CLIENT_ID}"
            fi   
      fi


      if [ "$client_secret" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_CLIENT_SECRET}" ]]; then
                  echo Error: -s argument or LUMINATE_CLIENT_SECRET environment variable are required
                  exit 1
            else
                  client_secret="${LUMINATE_CLIENT_SECRET}"
            fi   
      fi


      local luminate_url=${BASH_CLI_OPT_VALUE[12]}
      if [ "$luminate_url" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_ENVIRONMENT_URL}" ]]; then
                  echo Error: -U argument or LUMINATE_ENVIRONMENT_URL environment variable are required
                  exit 1
            else
                  luminate_url="${LUMINATE_ENVIRONMENT_URL}"
            fi   
      fi


      local curl_output=$(curl -s -X POST --write-out "HTTPSTATUS:%{http_code}" -u "$client_id:$client_secret" "https://api.$luminate_url/v1/oauth/token")
      #local curl_output='{"access_token":"4a7acefc-f574-49f6-9f0a-d02fa350f551","expires_in":3600,"scope":"sample-scope","token_type":"Bearer","error":"","error_description":""}HTTPSTATUS:200'
    
      # extract the body
      local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

      # extract the status
      local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

      #echo $curl_output
      #echo $response_body
      
      local response_body_no_whitespace=$(echo -e "${response_body}" | tr -d '[:space:]')

      # Retrieve the content of the access token from JSON response
      local access_token_temp=$(echo $response_body_no_whitespace | jq '.access_token')

      # Remove quotes to get the clean GUID
      local access_token_final=$(sed -e 's/^"//' -e 's/"$//' <<<"$access_token_temp")

      echo $access_token_final

      #echo $http_status
}

# Get the list of applications defined in the environment
# For each application, return its ID, Type (HTTP, SSH, TCP, RDP, ...) and its name
apps-list() {


      local client_token=${BASH_CLI_OPT_VALUE[5]}

      if [ "$client_token" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_SESSION_TOKEN}" ]]; then
                  echo Error: -t argument or LUMINATE_SESSION_TOKEN environment variable are required
                  exit 1
            else
                  client_token="${LUMINATE_SESSION_TOKEN}"
            fi   
      fi

      local luminate_url=${BASH_CLI_OPT_VALUE[12]}
      if [ "$luminate_url" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_ENVIRONMENT_URL}" ]]; then
                  echo Error: -U argument or LUMINATE_ENVIRONMENT_URL environment variable are required
                  exit 1
            else
                  luminate_url="${LUMINATE_ENVIRONMENT_URL}"
            fi   
      fi      

      # Please note that the return page size is set at 500 applications and we are only checking the first page
      local curl_output=$(curl -s -X GET --write-out "HTTPSTATUS:%{http_code}" --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer $client_token"  https://api.$luminate_url/v2/applications/?size=500)

      # extract the body
      local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

      # extract the status
      local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

      
      if [ "$http_status" -eq "403" ]; then
            echo Error: session expired or access denied. Please refresh session token.
            exit 1
      fi
      

      echo $response_body | jq '."content" | map([.id, .type, .name] | join("    "))'
      #local list=$(echo $response_body | jq '."content" | map([.id, .name] | join("        "))')
      
}

# Get the list of sites defined in the environment
# For each site return its name and its ID
sites-list() {

      local client_token=${BASH_CLI_OPT_VALUE[5]}

      if [ "$client_token" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_SESSION_TOKEN}" ]]; then
                  echo Error: -t argument or LUMINATE_SESSION_TOKEN environment variable are required
                  exit 1
            else
                  client_token="${LUMINATE_SESSION_TOKEN}"
            fi   
      fi

      local luminate_url=${BASH_CLI_OPT_VALUE[12]}
      if [ "$luminate_url" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_ENVIRONMENT_URL}" ]]; then
                  echo Error: -U argument or LUMINATE_ENVIRONMENT_URL environment variable are required
                  exit 1
            else
                  luminate_url="${LUMINATE_ENVIRONMENT_URL}"
            fi   
      fi      

      local curl_output=$(curl -s -X GET --write-out "HTTPSTATUS:%{http_code}" --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer $client_token"  https://api.$luminate_url/v2/sites/)

      # extract the body
      local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

      # extract the status
      local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

      if [ "$http_status" -eq "403" ]; then
            echo Error: session expired or access denied. Please refresh session token.
            exit 1
      fi
      

      #echo $response_body > /c/Work/test.json

      echo $response_body  | jq ' map([.id, .name] | join("        "))' 
}

# Retrieve details for a sepcified application (by name or by ID) in JSON format
apps-details() {

      local client_token=${BASH_CLI_OPT_VALUE[5]}

      if [ "$client_token" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_SESSION_TOKEN}" ]]; then
                  echo Error: -t argument or LUMINATE_SESSION_TOKEN environment variable are required
                  exit 1
            else
                  client_token="${LUMINATE_SESSION_TOKEN}"
            fi   
      fi

      local luminate_url=${BASH_CLI_OPT_VALUE[12]}
      if [ "$luminate_url" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_ENVIRONMENT_URL}" ]]; then
                  echo Error: -U argument or LUMINATE_ENVIRONMENT_URL environment variable are required
                  exit 1
            else
                  luminate_url="${LUMINATE_ENVIRONMENT_URL}"
            fi   
      fi      
      
      local app_id=${BASH_CLI_OPT_VALUE[7]}
      local app_name=${BASH_CLI_OPT_VALUE[8]}

      if [ "$app_name" != "<undefined>" ]; then

            # Start by filtering for applications by name, and then reducing to exact name

            local curl_output=$(curl -s -X GET --write-out "HTTPSTATUS:%{http_code}" --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer $client_token"  https://api.$luminate_url/v2/applications/?filter=$app_name)

            # extract the body
            local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

            # extract the status
            local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

            if [ "$http_status" -eq "403" ]; then
                  echo Error: session expired or access denied. Please refresh session token.
                  exit 1
            fi
      

            local app_query_response=$(echo $response_body | jq '."content" | map([.id, .type, .name] | join("    "))' | grep  -w " $app_name\"")

            if [ -z "$app_query_response" ]; then
                  echo Application named $app_name not found!
            else

                  # Retrieve the application ID
                  local retrieved_app_id=$(echo $app_query_response  | awk '{print $1;}' | cut -d "\"" -f 2)
                  
                  local curl_output=$(curl -s -X GET --write-out "HTTPSTATUS:%{http_code}" --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer $client_token"  https://api.$luminate_url/v2/applications/$retrieved_app_id)

                  # extract the body
                  local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

                  # extract the status
                  local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

                  echo $response_body | python -m json.tool                   

            fi

      elif [ "$app_id" != "<undefined>" ]; then      

            local curl_output=$(curl -s -X GET --write-out "HTTPSTATUS:%{http_code}" --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer $client_token"  https://api.$luminate_url/v2/applications/$app_id)

            # extract the body
            local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

            # extract the status
            local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

            if [ "$http_status" -eq "403" ]; then
                  echo Error: session expired or access denied. Please refresh session token.
                  exit 1
            fi

            echo $response_body | python -m json.tool  

      else
            echo Error: Application ID or Application Name should be provided

      fi
}

# Connect to an SSH application using specified Unix user account (using openssh cli)
# Requires application name and user account. Can, optionally, take identity file and pass it to the ssh client
ssh-connect() {


      local client_token=${BASH_CLI_OPT_VALUE[5]}

      if [ "$client_token" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_SESSION_TOKEN}" ]]; then
                  echo Error: -t argument or LUMINATE_SESSION_TOKEN environment variable are required
                  exit 1
            else
                  client_token="${LUMINATE_SESSION_TOKEN}"
            fi   
      fi

      local luminate_url=${BASH_CLI_OPT_VALUE[12]}
      if [ "$luminate_url" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_ENVIRONMENT_URL}" ]]; then
                  echo Error: -U argument or LUMINATE_ENVIRONMENT_URL environment variable are required
                  exit 1
            else
                  luminate_url="${LUMINATE_ENVIRONMENT_URL}"
            fi   
      fi

      local app_name=${BASH_CLI_OPT_VALUE[8]}

      if [ "$app_name" != "<undefined>" ]; then

            # Start by filtering for applications by name, and then reducing to exact name
            local curl_output=$(curl -s -X GET --write-out "HTTPSTATUS:%{http_code}" --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer $client_token"  https://api.$luminate_url/v2/applications/?filter=$app_name)

            # extract the body
            local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

            # extract the status
            local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

            if [ "$http_status" -eq "403" ]; then
                  echo Error: session expired or access denied. Please refresh session token.
                  exit 1
            fi
                  
            local app_query_response=$(echo $response_body | jq '."content" | map([.id, .type, .name] | join("    "))' | grep  -w " $app_name\"")

            if [ -z "$app_query_response" ]; then
                  echo Application named $app_name not found!
            else

                  # Retrieve the application ID
                  local retrieved_app_id=$(echo $app_query_response  | awk '{print $1;}' | cut -d "\"" -f 2)

                  local curl_output=$(curl -s -X GET --write-out "HTTPSTATUS:%{http_code}" --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer $client_token"  https://api.staging.luminatesite.com/v2/applications/$retrieved_app_id)

                  # extract the body
                  local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

                  # extract the status
                  local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

                  if [ "$http_status" -eq "403" ]; then
                        echo Error: session expired or access denied. Please refresh session token.
                        exit 1
                  fi
      
                  local application_json=$(echo $response_body | python -m json.tool)

                  local ssh_user_name=$(echo $application_json | jq ' .sshSettings | .userAccounts | .[0] | .name' | cut -d "\"" -f 2)
                  local ssh_external_host_name=$(echo $application_json |  jq '.connectionSettings | .externalAddress' | cut -d "\"" -f 2)

                  
		      local app_name_lowercase=$(echo $app_name | awk '{print tolower($0)}')
		      
                  local identity_file=${BASH_CLI_OPT_VALUE[10]}

                  if [ "$identity_file" != "<undefined>" ]; then
                        ssh $ssh_user_name@$app_name_lowercase@$ssh_external_host_name -i $identity_file
                  else
                        ssh $ssh_user_name@$app_name_lowercase@$ssh_external_host_name
                  fi
                  
            fi

      else
            echo Error: Application named required
            exit 1
      fi

}

# Create local port maps to ports defined in a TCP Tunnel application
# Requires application name and local binding IP. Can, optionally, take identity file and pass it to the ssh client
tcp-connect() {


      local client_token=${BASH_CLI_OPT_VALUE[5]}

      if [ "$client_token" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_SESSION_TOKEN}" ]]; then
                  echo Error: -t argument or LUMINATE_SESSION_TOKEN environment variable are required
                  exit 1
            else
                  client_token="${LUMINATE_SESSION_TOKEN}"
            fi   
      fi
      
      local luminate_url=${BASH_CLI_OPT_VALUE[12]}
      if [ "$luminate_url" == "<undefined>" ]; then
            if [[ -z "${LUMINATE_ENVIRONMENT_URL}" ]]; then
                  echo Error: -U argument or LUMINATE_ENVIRONMENT_URL environment variable are required
                  exit 1
            else
                  luminate_url="${LUMINATE_ENVIRONMENT_URL}"
            fi   
      fi

      local app_name=${BASH_CLI_OPT_VALUE[8]}

      if [ "$app_name" != "<undefined>" ]; then

            # Start by filtering for applications by name, and then reducing to exact name
            local curl_output=$(curl -s -X GET --write-out "HTTPSTATUS:%{http_code}" --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer $client_token"  https://api.$luminate_url/v2/applications/?filter=$app_name)

            # extract the body
            local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

            # extract the status
            local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

            if [ "$http_status" -eq "403" ]; then
                  echo Error: session expired or access denied. Please refresh session token.
                  exit 1
            fi
                  
            local app_query_response=$(echo $response_body | jq '."content" | map([.id, .type, .name] | join("    "))' | grep  -w " $app_name\"")

            if [ -z "$app_query_response" ]; then
                  echo Application named $app_name not found!
            else

                  # Retrieve the application ID
                  local retrieved_app_id=$(echo $app_query_response  | awk '{print $1;}' | cut -d "\"" -f 2)

                  local curl_output=$(curl -s -X GET --write-out "HTTPSTATUS:%{http_code}" --header "Content-Type: application/json" --header "Accept: application/json" --header "Authorization: Bearer $client_token"  https://api.$luminate_url/v2/applications/$retrieved_app_id)

                  # extract the body
                  local response_body=$(echo $curl_output | sed -e 's/HTTPSTATUS\:.*//g')

                  # extract the status
                  local http_status=$(echo $curl_output | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

                  local application_json=$(echo $response_body | python -m json.tool)

                  local ssh_user_name="tcptunnel"
                  local ssh_external_host_name=$(echo $application_json |  jq '.connectionSettings | .externalAddress' | cut -d "\"" -f 2)

                  
		      local app_name_lowercase=$(echo $app_name | awk '{print tolower($0)}')
		      
                  local identity_file=${BASH_CLI_OPT_VALUE[10]}

                  # Retrieve the target IP of the mapped ports (the actual server in the datacenter, behind the connector)
                  local target_ip=$(echo $application_json | jq '.tcpTunnelSettings | .[0] | .target' | cut -d "\"" -f 2)
                  echo $target_ip

                  # Build port mapping constructs for openssh command line
                  local ssh_portmap_commands=$(echo $application_json | jq '.tcpTunnelSettings | .[0] | .ports | .[]' | while read line ; do echo -L 127.0.0.1:$line:$target_ip:$line ; done | paste -sd " " -)


                  # Build port mapping constructs for openssh command line
                  #local ssh_portmap_comments=$(echo $multiline_ports_list | while read line ; do echo -L:127.0.0.1:$line$target_ip:$line ; done | paste -sd " " - )

                  if [ "$identity_file" != "<undefined>" ]; then
                        echo Running command: ssh $ssh_user_name@$app_name_lowercase@$ssh_external_host_name -i $identity_file $ssh_portmap_commands
                        ssh $ssh_user_name@$app_name_lowercase@$ssh_external_host_name -i $identity_file -N $ssh_portmap_commands
                  else
                        echo Running command: ssh $ssh_user_name@$app_name_lowercase@$ssh_external_host_name -N $ssh_portmap_commands
                        ssh $ssh_user_name@$app_name_lowercase@$ssh_external_host_name $ssh_portmap_commands
                  fi
                  
            fi

      else
            echo Error: Application named required
      fi

}

for i in "${!BASH_CLI_OPT_NAME[@]}"
do
      if [ ! "${BASH_CLI_OPT_DATA_TYPE[$i]}"  ];  then
            echo "BASH_CLI_OPT_DATA_TYPE[$i]=\"\" empty string is not allowed."
            echo "The value must be one of these: \"string\", \"boolean\", or \"cmd\""
            exit
      else 
            if [ "${BASH_CLI_OPT_DATA_TYPE[$i]}" == "string" ] ; then 
                  BASH_CLI_OPT_VALUE[$i]="<undefined>"
            elif [ "${BASH_CLI_OPT_DATA_TYPE[$i]}" == "boolean" ] ; then 
                  BASH_CLI_OPT_VALUE[$i]=false
            elif [ "${BASH_CLI_OPT_DATA_TYPE[$i]}" == "cmd" ] ; then 
                  BASH_CLI_OPT_VALUE[$i]="wait"
            else 
                  echo "BASH_CLI_OPT_DATA_TYPE[$i]=${BASH_CLI_OPT_DATA_TYPE[$i]} is not allowed."
                  echo "The value must be one of these: \"string\", \"boolean\", or \"cmd\""
                  exit
            fi   
      fi
done

SPECLINES=""
for i in "${!BASH_CLI_OPT_NAME[@]}"
do
      if [ "${BASH_CLI_OPT_DATA_TYPE[$i]}" != "cmd" ];  then
            SPECLINES+=" \t[${BASH_CLI_OPT_NAME[$i]}|${BASH_CLI_OPT_ALT_NAME[$i]} <${BASH_CLI_OPT_DESC[$i]}>]\n"
      fi         
done
SPECLINES+=" \t[-h|--help]\n"

SCRIPT_OPTIONS=""
SCRIPT_CMDS=""
for i in "${!BASH_CLI_OPT_DATA_TYPE[@]}"
do
      if [ "${BASH_CLI_OPT_DATA_TYPE[$i]}" != "cmd" ];  then
            SCRIPT_OPTIONS="${SCRIPT_OPTIONS} 
                              \t    ${BASH_CLI_OPT_NAME[$i]} \n"
      else 

            SCRIPT_CMDS="${SCRIPT_CMDS} 
                              \t${BASH_CLI_OPT_NAME[$i]} | ${BASH_CLI_OPT_ALT_NAME[$i]}
                              \t    ${BASH_CLI_OPT_DESC[$i]} \n"
      fi
done

function help {
      echo -e " Luminate Secure Access Cloud(TM) Command-line Interface v0.1PROT\n\n Usage: ./${BASH_CLI_SCRIPT_NAME} <options> <command> <flags> \n\n ${SPECLINES}
            \tThese are common ${BASH_CLI_SCRIPT_NAME} commands used in various situations:
            ${SCRIPT_CMDS}
      "
}
 
if [ $# -eq 0  ];  then
      help
      exit
fi

while [ "$1" != "" ]; do
      for i in ${!BASH_CLI_OPT_NAME[@]}
      do
            if [[ ( "${BASH_CLI_OPT_NAME[$i]}" == "$1" ) ||  
                  ( "${BASH_CLI_OPT_ALT_NAME[$i]}" == "$1" ) ]] ; then
                  if [ "${BASH_CLI_OPT_DATA_TYPE[$i]}" == "string" ] ; then 
                        if [[ ( ${2:0:1} == "-" ) || ( ${2:0:1} == "") ]] ; then 
                              BASH_CLI_OPT_VALUE[$i]='<undefined>'
                        else  
                              BASH_CLI_OPT_VALUE[$i]=$2 
                              shift
                        fi
                  fi   

                  if [ ${BASH_CLI_OPT_DATA_TYPE[$i]} == "boolean" ] ; then 
                        BASH_CLI_OPT_VALUE[$i]=true
                  fi 

                  if [ ${BASH_CLI_OPT_DATA_TYPE[$i]} == "cmd" ] ; then 
                        BASH_CLI_OPT_VALUE[$i]="invoked"
                  fi 
  
            else 
                  if [[ ( "$1" == "-h" ) || ( "$1" == "--help" ) ]] ; then
                        help
                        exit
                  fi

            fi
      done
      shift
done

validate_mandatory_options(){
      local i
      for i in $(echo ${BASH_CLI_MANDATORY_PARAM[$BASH_CLI_CURRENT_CMD_INDEX]} | tr "," "\n")
      do
            if [ "${BASH_CLI_OPT_DATA_TYPE[$i]}" == "boolean" ];  then
                  echo -e "\n Warning!! \n"
                  echo -e "\t Please check your script implementation" 
                  echo -e "\t All mandatory options (BASH_CLI_MANDATORY_PARAM[]) must be configured with string datatype option"
                  echo -e "\t BASH_CLI_OPT_NAME[$i]=\"${BASH_CLI_OPT_NAME[$i]}\" is currently using boolean data type and it does not allow to be a mandatory option"
                  echo -e "\n"
                  exit
            fi
            validate_string_parameter "${BASH_CLI_OPT_NAME[$i]}" "${BASH_CLI_OPT_VALUE[$i]}" "${BASH_CLI_OPT_DATA_TYPE[$i]}" "${BASH_CLI_OPT_DESC[$i]}"
      done
}

validate_string_parameter() {
      local pname=$1
      local pvalue=$2
      local pdatatype=$3
      local pdesc=$4
      if [ "${pvalue}" == "<undefined>" ];  then
            echo -e "\t\tMissing mandatory option: \"${pname}\" (${pdesc}) is mandatory option"

            if [ "${pdatatype}" == "string" ];  then
                  echo -e "\t\tExample: ./${BASH_CLI_SCRIPT_NAME} ${BASH_CLI_OPT_NAME[$BASH_CLI_CURRENT_CMD_INDEX]} ${pname} \"String Value\" "
            fi
            exit
      fi
}

show_optional_parameters() {
      local i
      local options
      for i in $(echo "${BASH_CLI_NON_MANDATORY_PARAM[$BASH_CLI_CURRENT_CMD_INDEX]}" | tr "," "\n")
      do
            options="${options} ${BASH_CLI_OPT_NAME[$i]}" 
      done
      echo -e "\n\tAll optional parameters of this command: ${options}"

      echo -e "\tCurrent value:"
      for i in $(echo ${BASH_CLI_NON_MANDATORY_PARAM[$BASH_CLI_CURRENT_CMD_INDEX]} | tr "," "\n")
      do
            echo -e "\t\t${BASH_CLI_OPT_NAME[$i]} ${BASH_CLI_OPT_VALUE[$i]}"
      done       
}

process() {
      local j

      for j in "${!BASH_CLI_OPT_NAME[@]}"
      do
            if [ "${BASH_CLI_OPT_DATA_TYPE[$j]}" == "cmd" ];  then
                  if [ "${BASH_CLI_OPT_VALUE[$j]}" == "invoked" ];  then
                        BASH_CLI_CURRENT_CMD_INDEX=$j
                        validate_mandatory_options
                        ${BASH_CLI_OPT_NAME[$BASH_CLI_CURRENT_CMD_INDEX]} 
                        # ${BASH_CLI_OPT_NAME[$BASH_CLI_CURRENT_CMD_INDEX]} "${BASH_CLI_ALL_ARGS}"
                        break
                  fi
                  
            fi
      done
}

process $BASH_CLI_ALL_ARGS
