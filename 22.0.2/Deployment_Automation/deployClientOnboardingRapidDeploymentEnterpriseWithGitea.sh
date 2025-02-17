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

# This file is to be used with CP4BA 22.0.2 Enterprise deployment according to the SWAT rapid deployment scripts with a co-deployed gitea to deploy the Client Onboarding scenario and associated labs (by default using an  external mail server)

# Set all variables according to your environment before executing this file

#----------------------------------------------------------------------------------------------------------
# Specify below variables to launch the deployment automation with
#----------------------------------------------------------------------------------------------------------

# Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
ocLoginServer=REQUIRED
# Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
ocLoginToken=REQUIRED

# Uncomment when the OCP cluster contains more than one namespace/project into which CP4BA has been deployed and specify the name of the namespace you want to deploy to. 
# If only one CP4BA namespace exists the deployment tool will determine the namespace automatically
#cp4baNamespace=REQUIRED

# Password for the CP4BA admin user to use to access the CP4BA environment
cp4baAdminPassword=REQUIRED


# Flag that determines if the internal email server is used or the external gmail service
# (in case internal email server is used one or two LDIF files with the users and their passwords need to be placed in the same location as this file. In case of the gmail server the two properties 'gmailAddress' and 'gmailAppKey' need to be specified)
useInternalMailServer=true

# Name of the storage class for the internal mail server (in case useInternalMailServer is set to true)
ocpStorageClassForInternalMailServer=REQUIRED

# Email address of a gmail account to be used to send emails in the Client Onboarding scenario (in case useInternalMailServer is set to false)
gmailAddress=REQUIRED
# App key for accessing the gmail account to send emails (in case useInternalMailServer is set to false)
gmailAppKey=REQUIRED


# Uncomment when the admin credentials for the embedded Gitea differ from the credentials of the CP4BA admini
#giteaCredentials="-giteaUserName= -giteaUserPwd="

# User for who the RPA bot is executed (specifying a non-existing user basically skipped the RPA bot execution)
rpaBotExecutionUser=cp4admin2
# URL of the RPA server to be invoked for the RPA bot execution
rpaServer=https://rpa-server.com:1111

# Should ADP be used within the Client Oboarding scenario (do not change for now)
adpConfigured=false

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
CP4BAVERSION="22.0.2"
# Deployment pattern of the CP4BA instance
DEPLOYMENTPATTERN="Enterprise"
# Source URL to bootstrap configuration for the deployment tool
BOOTSTRAPURL="-bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/${CP4BAVERSION}/Deployment_Automation/${DEPLOYMENTPATTERN}"
# Name of the configuration file to use when running the deployment automation tool
CONFIGNAME="config-deploy-withGitea"
# Automation script to use when running the deployment automation tool
AUTOMATIONSCRIPT="DeployClientOnboardingEmbeddedGitea.json"

# Name of the source sh file passed to execution environment
SCRIPTNAME=deployClientOnboardingRapidDeploymentEnterpriseWithGitea.sh
# Name of the actual sh file passed to execution environment
FILENAME=$0
# Version of this script file passed to execution environment
SCRIPTVERSION=1.2.3
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

if [[ "${ocLoginServer}" == "REQUIRED" ]] || [[ "${ocLoginServer}" == "" ]]
then
  if $validationSuccess
  then
    echo "Validating configuration failed:"
    validationSuccess=false
  fi
  echo "  Variable 'ocLoginServer' has not been set"
fi

if [[ "${ocLoginToken}" == "REQUIRED" ]] || [[ "${ocLoginToken}" == "" ]]
then
  if $validationSuccess
  then
    echo "Validating configuration failed:"
    validationSuccess=false
  fi
  echo "  Variable 'ocLoginToken' has not been set"
fi

if [[ "${cp4baAdminPassword}" == "REQUIRED" ]] || [[ "${cp4baAdminPassword}" == "" ]]
then
  if $validationSuccess
  then
    echo "Validating configuration failed:"
    validationSuccess=false
  fi
  echo "  Variable 'cp4baAdminPassword' has not been set"
fi

if [[ "${useInternalMailServer}" == "true" ]]
then
  enableDeployEmailCapabilityInternal=enableDeployEmailCapability=true

  COUNTLDIFFILES=$(ls *.ldif 2>/dev/null | wc -l | tr -d " ")

  if [[ "${COUNTLDIFFILES}" == "1" ]]
  then
    LDIFFILE1=$(ls *.ldif | sed -n '1 p')
    ldifFileLineInternal=externalLDIF1=${LDIFFILE1}
  elif [[ "${COUNTLDIFFILES}" == "2" ]]
  then
    LDIFFILE1=$(ls *.ldif | sed -n '1 p')
    LDIFFILE2=$(ls *.ldif | sed -n '2 p')
    ldifFileLineInternal="externalLDIF1=${LDIFFILE1} externalLDIF2=${LDIFFILE2}"
  else
    if $validationSuccess
    then
        echo "Validating configuration failed:"
        validationSuccess=false
    fi
    echo "  Variable 'useInternalMailServer' is set to 'true' but ${COUNTLDIFFILES} ldif file(s) found in the directory. 1 or 2 ldif files are required."
  fi
  
  if [[ "${ocpStorageClassForInternalMailServer}" == "REQUIRED" ]] || [[ "${ocpStorageClassForInternalMailServer}" == "" ]]
  then
     if $validationSuccess
     then
       echo "Validating configuration failed:"
       validationSuccess=false
     fi
    echo "  Variable 'useInternalMailServer' is set to 'true' but variable 'ocpStorageClassForInternalMailServer' has not been set"
  else
    ocpStorageClassForInternalMailServerInternal=ocpStorageClassForMail=${ocpStorageClassForInternalMailServer}
  fi
fi

if [[ "${useInternalMailServer}" == "false" ]]
then
  if [ ! -z "${gmailAddress+x}" ]
  then
    if [[ "${gmailAddress}" == "REQUIRED" ]] || [[ "${gmailAddress}" == "" ]]
    then
      if $validationSuccess
      then
        echo "Validating configuration failed:"
        validationSuccess=false
      fi
      echo "  Variable 'useInternalMailServer' is set to 'false' but variable 'gmailAddress' has not been set"
    else
      gmailAddressInternal=wf_cp_emailID=${gmailAddress}
    fi
  fi
fi

if [[ "${useInternalMailServer}" == "false" ]] && [ ! -z "${gmailAppKey+x}" ]
then
  if [[ "${gmailAppKey}" == "REQUIRED" ]] || [[ "${gmailAppKey}" == "" ]]
  then
     if $validationSuccess
     then
       echo "Validating configuration failed:"
       validationSuccess=false
     fi
    echo "  VVariable 'useInternalMailServer' is set to 'false' but variable 'gmailAppKey' has not been set"
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

if [[ "${adpConfigured}" == "REQUIRED" ]] || [[ "${adpConfigured}" == "" ]]
then
  if $validationSuccess
  then
    echo "Validating configuration failed:"
    validationSuccess=false
  fi
  echo "  Variable 'adpConfigured' has not been set"
fi

if defined cp4baNamespace (
	if "%cp4baNamespace%"=="REQUIRED" set cp4baNamespaceRequired=true
	if defined cp4baNamespaceRequired (
		if not defined validationFailed (
			echo Validating configuration failed:
			set validationFailed=true
		)
		echo   Variable 'cp4baNamespace' has not been set
	) else (
		set cp4baNamespaceInternal="-cp4baNamespace=%cp4baNamespace%"
	)
)

if ! $validationSuccess
then
  echo
fi

if ! $validationSuccess || ! $toolValidationSuccess
then
  echo "Exiting..."
  exit 1
fi

java ${jvmSettings} -jar ${TOOLFILENAME} ${bootstrapDebugString} ${BOOTSTRAPURL} \"-scriptDownloadPath=${SCRIPTDOWNLOADPATH}\" \"-scriptName=${FILENAME}\" \"-scriptSource=${SCRIPTNAME}\" \"-scriptVersion=${SCRIPTVERSION}\" -ocLoginServer=${ocLoginServer} -ocLoginToken=${ocLoginToken} ${cp4baNamespaceInternal} ${TOOLPROXYSETTINGS} -installBasePath=${DEPLOYMENTPATTERN} -config=${CONFIGNAME} -automationScript=${AUTOMATIONSCRIPT} -cp4baAdminPwd=${cp4baAdminPassword} ${giteaCredentials} enableDeployClientOnboarding_ADP=${adpConfigured} ACTION_wf_cp_adpEnabled=${adpConfigured} ${enableDeployEmailCapabilityInternal} ${ocpStorageClassForInternalMailServerInternal} ${ldifFileLineInternal} ${gmailAddressInternal} ${gmailAppKeyInternal} ACTION_wf_cp_rpaBotExecutionUser=${rpaBotExecutionUser} ACTION_wf_cp_rpaServer=${rpaServer}