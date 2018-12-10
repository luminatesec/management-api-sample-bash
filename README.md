# management-api-sample-bash

Sample Bash (Bourne Again Shell) Script implementing a command-line interface for Luminate Secure Access Cloud (TM) with Luminate Management API (REST)

This tool is provided by Luminate Security as-is, as an open source, not as a part of the licensed product. It can be modified to fit any needs of automation for Luminate Secure Access Cloud (TM) environments. External contributions are welcome and will be reviewed by the team prior to inclusion to the main branch.

## Pre-conditions / Requirements

In order to function properly, this script requires following command-line tools/utilities to be deployed and to be in PATH:
- CURL - For accessing the REST API (https://curl.haxx.se/)
- JQ - For parsing JSON responses from the REST API () and for building JSON request bodies (https://stedolan.github.io/jq/)
- Python - For formatting JSON for display
- Standard Unix command-line tools: grep, awk, sed, cut, paste, tr

The script was tested in the following environments:
1. Bash on Mac OS X
2. Bash on Microsoft Windows in Cygwin environment

## Supported Environment Variables

- **LUMINATE_ENVIRONMENT_URL** - Base URL of the Luminate Secure Access Cloud (TM) environment, for example, ***mycompany.luminatesec.com***
- **LUMINATE_CLIENT_ID** - ID of the API Client defined in the Luminate Admin Portal (for OAuth2/OpenID Connect authentication part)
- **LUMINATE_CLIENT_SECRET** - Secret of the API Client defined in the Luminate Admin Portal (for OAuth2/OpenID Connect authentication part)
- **LUMINATE_SESSION_TOKEN** - Session token returned by Luminate Management API, valid for 1 hour. Should be the GUID form.


## Comand-line Reference

 Usage: lumcli.sh <options> <command> <flags> 

 	[-c|--client_id <Luminate Management API Client ID>]
 	[-s|--client_secret <Luminate Management API Client Secret>]
 	[-t|--access_token <Luminate Management API Access Token>]
 	[-o|--object_id <ID of the relevant object>]
 	[-n|--object_name <Name of the relevant object>]
 	[-i|--identity <Path to identity file (private key) for public key authentication>]
 	[-U|--env_url <Luminate environment URL (such as company.luminatesec.com)>]
 	[-h|--help]

            	These are common lumcli.sh commands used in various situations:
             
                              	connect | Connect
                              	    Connect to Luminate Management API and generate a session token

					Required flags:
					-c <Client ID> or LUMINATE_CLIENT_ID environment variable
					-s <Client Secret> or LUMINATE_CLIENT_SECRET environment variable
					-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable 
 
                              	sites-list | ListSites
                              	    Retrieve list of all sites

					Required flags:
					-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable
					-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable 
 
                              	apps-list | ListApps
                              	    Retrieve list of all applicatons

					Required flags:
					-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable
					-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable 
 
                              	apps-details | AppDetails
                              	    Get application details

					Required flags:
					-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable
					-n <Application Name> or -o <Application ID>
					-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable 
 
                              	ssh-connect | SshConnect
                              	    Connect to an SSH Server

					Required flags:
					-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable
					-n <Application Name> or -o <Application ID>
					-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable

					Optional flags:
					-i <Path to Luminate SSH Key in PEM format> 
 
                              	tcp-connect | TcpConnect
                              	    Connect to TCP Port maps

					Required flags:
					-t <Session Token> or LUMINATE_SESSION_TOKEN environment variable
					-n <Application Name> or -o <Application ID>
					-U <Luminate Environment URL> or LUMINATE_ENVIRONMENT_URL environment variable

					Optional flags:
					-i <Path to Luminate SSH Key in PEM format> 
