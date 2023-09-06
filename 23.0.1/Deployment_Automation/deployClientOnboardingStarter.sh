#!/bin/bash
###############################################################################
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2023. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
###############################################################################

# This file is to be used with CP4BA 23.0.1 starter deployment to deploy the Client Onboarding scenario and associated labs using an internal email server/client

# Set all variables according to your environment before executing this file

#----------------------------------------------------------------------------------------------------------
# Specify below variables to launch the deployment automation with
#----------------------------------------------------------------------------------------------------------

# Either 'pakInstallerPortalURL' or 'ocLoginServer' and 'ocLoginToken' need to be specified but not both depending on how environment is installed

# URL of the PAK INSTALLER PORTAL directly from the 'Your environment is ready' email 'PakInstaller Portal URL:' when deployed from TechZone via Pak Installer
pakInstallerPortalURL=REQUIRED

# Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
#ocLoginServer=REQUIRED
# Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
#ocLoginToken=REQUIRED

# Set to true in case environment should be used to perform Workflow labs using business users (user1-user10) instead of admin user (cp4admin)
enableWorkflowLabsForBusinessUsers=false

# User for who the RPA bot is executed (specifying a non-existing user basically skipped the RPA bot execution)
rpaBotExecutionUser=cp4admin2
# URL of the RPA server to be invoked for the RPA bot execution (currently not supported/tested, keep dummy value)
rpaServer=https://rpa-server.com:1111

# Uncomment below two properties to provide credentials for an external gmail account if emails should be sent to external email addresses otherwise an internal email server/client will be used

# Email address of the gmail account to send emails
# gmailAddress=REQUIRED
# App key for accessing the gmail account to send emails
# gmailAppKey=REQUIRED

# Should one or multiple users be added to the Cloud Pak as part of deploying the solution (The actual users need to be specified in a file called 'AddUsersToPlatform.json' in the directory of this file.)
createUsers=false


# Uncomment in case JVM throws an "Out Of Memory"-exception during the execution
#jvmSettings="-Xms4096M"

# Uncomment in case GitHub is not accessible and all resources are already available locally
#disableAccessToGitHub="-disableAccessToGitHub=true"

# Proxy settings in case a proxy server needs to be used to access the GitHub resources
# Uncomment at least the proxScenatio, proxyHost, and proxyPort lines and set values accordingly in case a proxy server needs to be used to access GitHub
# Uncomment the lines proxyUser and proxyPwd too, in case the proxy server requires authentication
#proxyScenario=GitHub
#proxyHost=
#proxyPort=
#proxyUser=
#proxyPwd=

# Specific trace string for the boostrapping process (only uncomment if instructed to do so)
#bootstrapDebugString="\"-bootstrapDebugString=*=finest\""

# ----------------------------------------------------------------------------------------------------------
# Construct the proxy settings for curl and deployment automation tool if proxy is configured
# ----------------------------------------------------------------------------------------------------------

if [ ! -z "${proxyHost+x}" ]
then
  if [ ! -z "${proxyUser+x}" ]
  then
     TOOLPROXYSETTINGS=-"proxyScenario=${proxyScenario} -proxyHost=${proxyHost} -proxyPort=${proxyPort} -proxyUser=${proxyUser} -proxyPwd=${proxyPwd}"

     if [[ "${proxyScenario}" == "GitHub" ]] 
     then
       CURLPROXYSETTINGS="-x ${proxyHost}:${proxyPort} -U ${proxyUser}:${proxyPwd}"
     fi
  else
    TOOLPROXYSETTINGS="-proxyScenario=${proxyScenario} -proxyHost=${proxyHost} -proxyPort=${proxyPort}"
    if [[ "${proxyScenario}" == "GitHub" ]] 
    then
       CURLPROXYSETTINGS="-x ${proxyHost}:${proxyPort}"
    fi
  fi
fi

# ----------------------------------------------------------------------------------------------------------
# Global settings for the script (not to be modified by user)
# ----------------------------------------------------------------------------------------------------------

# Source URL where the deployment automation jar can be retrieved from
TOOLSOURCE="https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/Deployment_Automation/Current"
# CP4BA version
CP4BAVERSION="23.0.1"
# Deployment pattern of the CP4BA instance
DEPLOYMENTPATTERN="Starter"
# Source URL to bootstrap configuration for the deployment tool
BOOTSTRAPURL="-bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/${CP4BAVERSION}/Deployment_Automation/${DEPLOYMENTPATTERN}"
# Name of the configuration file to use when running the deployment automation tool
CONFIGNAME="config-deploy"
# Automation script to use when running the deployment automation tool
AUTOMATIONSCRIPT="DeployClientOnboardingEmbeddedGitea.json"

# Name of the source sh file passed to execution environment
SCRIPTNAME=deployClientOnboardingStarter.sh
# Name of the actual sh file passed to execution environment
FILENAME=$0
# Version of this script file passed to execution environment
SCRIPTVERSION=1.1.1
# Download URL for this script
SCRIPTDOWNLOADPATH=https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/${CP4BAVERSION%}/Deployment_Automation/${SCRIPTNAME%}

# ----------------------------------------------------------------------------------------------------------
# Retrieve the deployment automation jar file from GitHub if not already available or use local one when 
# GitHub access is disabled. Validate that the deployment tool jar is available
# ----------------------------------------------------------------------------------------------------------

toolValidationSuccess=true
echo "Bootstrapping deployment automation tool:"

# In case access to GitHub is disabled check if the deployment automation jar is available locally
if [ ! -z "${disableAccessToGitHub+x}" ]
then
  # 
  if ls *DeploymentAutomation.jar 1> /dev/null 2>&1; then
    # get the latest version of the file
    TOOLFILENAME=$(ls *DeploymentAutomation.jar | tail -n 1)
    
    echo "  Using local deployment automation jar file '${TOOLFILENAME}' as retrieval from GitHub is disabled"
  # if no file with the name found 
  else
    toolValidationSuccess=false
    echo "  No version of the deployment automation jar could be found while retrieval from GitHub is disabled"
  fi
else
  # Retrieve the download URL of the only deployment automation jar that is available in the GitHub repository
  GITHUBENTRIES=$(curl -s -X GET ${TOOLSOURCE})

  # Extract the download URL and the actual name of the deployment automation jar that is started later on
  DOWNLOADURL="download_url\": \""
  DOWNLOADLINE=${GITHUBENTRIES#*$DOWNLOADURL}
  DOWNLOADURL="${DOWNLOADLINE%%\"*}"
  TOOLFILENAME="${DOWNLOADURL##*/}"
  
  # In case the deployment automation jar does not yet exist locally download it otherwise print a msg that no download is required
  if [[ ! -f ${TOOLFILENAME} ]] 
  then
      echo "  Downloading deployment automation jar ${TOOLFILENAME} from GitHub"
      curl -O ${DOWNLOADURL} ${CURLPROXYSETTINGS}
  else
    echo "  Deployment automation jar file '${TOOLFILENAME}' already exists, no need to download it from Github"
  fi
  
  # In case the tool still does not exist something went wrong during download
  if [[ ! -f ${TOOLFILENAME} ]] 
  then
    toolValidationSuccess=false
    echo "  Failure to download ${TOOLFILENAME} from ${DOWNLOADURL}"  
  fi
fi

echo

# ----------------------------------------------------------------------------------------------------------
# Validation that all required parameters are set
# ----------------------------------------------------------------------------------------------------------

validationSuccess=true

# if 'pakInstallerPortalURL' is not defined or set as default or empty then check that 'ocLoginServer' and 'ocLoginToken' are properly defined
if [ -z "${pakInstallerPortalURL+x}" ] || [[ "${pakInstallerPortalURL}" == "REQUIRED" ]] || [[ "${pakInstallerPortalURL}" == "" ]]
then
	if [ -z "${ocLoginServer+x}" ] || [[ "${ocLoginServer}" == "REQUIRED" ]] || [[ "${ocLoginServer}" == "" ]]
	then
		if $validationSuccess
		then
			echo "Validating configuration failed:"
			validationSuccess=false
		fi
		echo "  Variable 'ocLoginServer' has not been defined/set (nor is variable 'pakInstallerPortalURL' defined/set)"
	else
		INTERNALOCLOGINSERVER=-ocLoginServer=${ocLoginServer}
	fi
	
	if [ -z "${ocLoginToken+x}" ] || [[ "${ocLoginToken}" == "REQUIRED" ]] || [[ "${ocLoginToken}" == "" ]]
	then
		if $validationSuccess
		then
			echo "Validating configuration failed:"
			validationSuccess=false
		fi
		echo "  Variable 'ocLoginToken' has not been defined/set (nor is variable 'pakInstallerPortalURL' defined/set)"
	else
		INTERNALOCLOGINTOKEN=-ocLoginToken=${ocLoginToken}
	fi
else 
	if ([[ "${ocLoginServer}" != "REQUIRED" ]] && [[ "${ocLoginServer}" != "" ]]) || ([[ "${ocLoginToken}" != "REQUIRED" ]] && [[ "${ocLoginToken}" != "" ]])
	then
		if $validationSuccess
		then
			echo "Validating configuration failed:"
			validationSuccess=false
		fi
		echo "  Either 'ocLoginServer' and 'ocLoginToken' or 'pakInstallerPortalURL' can be specified but NOT both"
	else
		INTERNALPAKINSTALLERPORTALURL=-pakInstallerPortalURL=${pakInstallerPortalURL}
	fi
fi

if [ ! -z "${gmailAddress+x}" ]
then
  if [[ "${gmailAddress}" == "REQUIRED" ]] || [[ "${gmailAddress}" == "" ]]
  then
    if $validationSuccess
    then
      echo "Validating configuration failed:"
      validationSuccess=false
    fi
    echo "  Variable 'gmailAddress' has not been set"
  else
    gmailAddressInternal=wf_cp_emailID=${gmailAddress}
  fi
fi

if [ ! -z "${gmailAppKey+x}" ]
then
  if [[ "${gmailAppKey}" == "REQUIRED" ]] || [[ "${gmailAppKey}" == "" ]]
  then
     if $validationSuccess
     then
       echo "Validating configuration failed:"
       validationSuccess=false
     fi
    echo "  Variable 'gmailAppKey' has not been set"
  else
    gmailAppKeyInternal=wf_cp_emailPassword=${gmailAppKey}
  fi
fi

if [[ "${rpaBotExecutionUser}" == "REQUIRED" ]] || [[ "${rpaBotExecutionUser}" == "" ]]
then
  if $validationSuccess
  then
    echo "Validating configuration failed:"
    validationSuccess=false
  fi
  echo "  Variable 'rpaBotExecutionUser' has not been set"
fi

if [[ "${rpaServer}" == "REQUIRED" ]] || [[ "${rpaServer}" == "" ]]
then
   if $validationSuccess
   then
    echo "Validating configuration failed:"
    validationSuccess=false
  fi
  echo "  Variable 'rpaServer' has not been set"
fi

if [[ ! -z "${createUsers+x}"  ]] && "${createUsers}" == "true"
then
   createUsersFile=createUsersFile=AddUsersToPlatform.json

   if ! ls "AddUsersToPlatform.json" 1> /dev/null 2>&1; 
   then
     if $validationSuccess
     then
	echo "Validating configuration failed:"
        validationSuccess=false
     fi
     echo "  Configured to add users to Cloud Pak environment but file 'AddUsersToPlatform.json' does not exist in current directory"
   fi
fi


if ! $validationSuccess
then
  echo
fi

if ! $validationSuccess || ! $toolValidationSuccess
then
  echo "Exiting..."
  exit 1
fi

if [ ! -z "${enableWorkflowLabsForBusinessUsers+x}" ]
then
	workflowLabsForBusinessUsers=enableWFLabForBusinessUsers=${enableWorkflowLabsForBusinessUsers}
fi


java ${jvmSettings} -jar ${TOOLFILENAME} ${bootstrapDebugString} ${BOOTSTRAPURL} \"-scriptDownloadPath=${SCRIPTDOWNLOADPATH}\" \"-scriptName=${FILENAME}\" \"-scriptSource=${SCRIPTNAME}\" \"-scriptVersion=${SCRIPTVERSION}\" ${INTERNALOCLOGINSERVER} ${INTERNALOCLOGINTOKEN} ${INTERNALPAKINSTALLERPORTALURL} ${TOOLPROXYSETTINGS} -installBasePath=${DEPLOYMENTPATTERN} -config=${CONFIGNAME} -automationScript=${AUTOMATIONSCRIPT} ${gmailAddressInternal} ${gmailAppKeyInternal} ${workflowLabsForBusinessUsers} ${createUsersFile} ACTION_wf_cp_rpaBotExecutionUser=${rpaBotExecutionUser} ACTION_wf_cp_rpaServer=${rpaServer}