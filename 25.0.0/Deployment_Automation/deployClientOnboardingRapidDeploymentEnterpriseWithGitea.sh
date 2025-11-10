#!/bin/bash
###############################################################################
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2024. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
###############################################################################

# This file is to be used with CP4BA 25.0.0 Enterprise deployment according to the SWAT rapid deployment scripts with a co-deployed gitea to deploy the Client Onboarding scenario and associated labs (by default using an  external mail server)

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
# Uncomment when the admin credentials for the embedded Gitea differ from the credentials of the CP4BA admini
#giteaCredentials="-giteaUserName= -giteaUserPwd="

# Set to false in case environment the Client Onboarding lab artifacts should not be deployed and only the Client Onboarding scenario is required (if set to false, will reduce deployment time)
configureLabs=true

# Flag that determines if the internal email server is used or the external gmail service
# (in case internal email server is used one or two LDIF files with the users and their passwords need to be placed in the same location as this file. In case of the gmail server the two properties 'gmailAddress' and 'gmailAppKey' need to be specified)
useInternalMailServer=true

# Name of the storage class for the internal mail server (in case useInternalMailServer is set to true)
ocpStorageClassForInternalMailServer=REQUIRED

# Section with flags related to using AI-enhanced Client Onboarding scenario

# Is the Content Assistant capability available in the environment or not?
enableContentAssistant=false
# Is the usage of Content Assistant in the APP to be limited to a specific user or not (left empty)
restrictContentAssistantToUser=
# Name of the ICN desktop that should be used to open the Annual Report in Daeja Viewer from the Workflow solution
icaDesktopName=ICN
# Region to use for the IBM Content Assistant ICN plug-in (can either be aws-us-east-1 / aws-eu-central-1 (only required when enableContentAssistant=true)
icaGenAIRegion=REQUIRED
# Used for the respective GenAI configuration within CPE and a Gen AI enabled object store (only required when enableContentAssistant=true)
genAIAccessCode=REQUIRED
#  Used for the respective GenAI configuration within CPE and a Gen AI enabled object store (only required when enableContentAssistant=true)
genAIServiceURL=https://filenetai.test.saas.ibm.com/demo
# Is the GenAI capability available in Workflow
enableWFGenAI=false
# Is the Workflow Assistant capability available
enableWFAssistant=false
# The number of users to create sample case data for (cp4badmin and usr001-usrXXX, therefore number needs to be one more than usrXXX)
createSampleCaseDataForNumUsers=10
# The maximum number of thread used to create the dummy cases in parallel
maxCaseIteratorThreads=20

# Explicit base URL for accessing graphQL (only required if automatic detection does not work in environment)
graphQLURL=
# Explicit base URL for accessing ICN (only required if automatic detection does not work in environment)
icnBaseURL=

# Uncomment following two lines in case you want to use your Docker.io account instead of pulling images for the mail server anonymously (mostly relvant when anonymous pull limit has been reached)
#dockerUserName=REQUIRED
#dockerToken=REQUIRED

# Email address of a gmail account to be used to send emails in the Client Onboarding scenario (in case useInternalMailServer is set to false)
gmailAddress=REQUIRED
# App key for accessing the gmail account to send emails (in case useInternalMailServer is set to false)
gmailAppKey=REQUIRED


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
# Uncomment at least the proxScenario, proxyHost, and proxyPort lines and set values accordingly in case a proxy server needs to be used to access GitHub
# Uncomment the lines proxyUser and proxyPwd too, in case the proxy server requires authentication
#proxyScenario=GitHub
#proxyHost=
#proxyPort=
#proxyUser=
#proxyPwd=

# Specific trace string for the boostrapping process (only uncomment if instructed to do so)
#bootstrapDebugString="\"-bootstrapDebugString=*=finest\""

# Any other options can be defined here and will be passed unchanged to the deployment tool
additionalOptions=

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
CP4BAVERSION="25.0.0"
# Deployment pattern of the CP4BA instance
DEPLOYMENTPATTERN="Enterprise"
# Source URL to bootstrap configuration for the deployment tool
BOOTSTRAPURL="-bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/${CP4BAVERSION}/Deployment_Automation/${DEPLOYMENTPATTERN}"
# Name of the configuration file to use when running the deployment automation tool
CONFIGNAME="config-deploy-withGitea"
# Automation script to use when running the deployment automation tool
AUTOMATIONSCRIPT="DeployClientOnboardingGeneric.json"

# Name of the source sh file passed to execution environment
SCRIPTNAME=deployClientOnboardingRapidDeploymentEnterpriseWithGitea.sh
# Name of the actual sh file passed to execution environment
FILENAME=$0
# Version of this script file passed to execution environment
SCRIPTVERSION=1.0.3
# Download URL for this script
SCRIPTDOWNLOADPATH=https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/${CP4BAVERSION%}/Deployment_Automation/${SCRIPTNAME%}
# Variable values to be copied to newer version in case found
COPYVARVALUES=ocLoginServer,ocLoginToken,cp4baNamespace,cp4baAdminPassword,giteaCredentials,configureLabs,useInternalMailServer,ocpStorageClassForInternalMailServer,dockerUserName,dockerToken,gmailAddress,gmailAppKey,rpaBotExecutionUser,rpaServer,adpConfigured,jvmSettings,disableAccessToGitHub,proxyScenario,proxyHost,proxyPort,proxyUser,proxyPwd,proxyPwd,bootstrapDebugString,enableContentAssistant,restrictContentAssistantToUser,icaDesktopName,icaGenAIRegion,genAIAccessCode,genAIServiceURL,enableWFGenAI,enableWFAssistant,createSampleCaseDataForNumUsers,maxCaseIteratorThreads,graphQLURL,icnBaseURL

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
  enableDeployEmailCapabilityInternal=enableDeployEmailCapability=false
  
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

if [ ! -z "${cp4baNamespace+x}" ]
then
  if [[ "${cp4baNamespace}" == "REQUIRED" ]] || [[ "${cp4baNamespace}" == "" ]]
  then
    if $validationSuccess
    then
      echo "Validating configuration failed:"
      validationSuccess=false
    fi
    echo "  Variable 'cp4baNamespace' has not been set"
  else
    cp4baNamespaceInternal=-cp4baNamespace=${cp4baNamespace}
  fi
fi

if [[ ! -z "${createUsers+x}" ]] && "${createUsers}" == "true"
then
  createUsersFile=onboardUsersFile=AddUsersToPlatform.json

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

# if dockerUserName is defined check if not equal default value required
if [[ ! -z "${dockerUserName+x}" ]]
then
  if [[ "${dockerUserName}" == "REQUIRED" ]]
  then
    if $validationSuccess
    then
      echo "Validating configuration failed:"
      validationSuccess=false
    fi
    echo "  Variable 'dockerUserName' is defined but is not set correctly"

    # check dockerToken variable is set and if so if set to non default value
    if [[ ! -z "${dockerToken+x}" ]]
    then
      if [[ "${dockerToken}" == "REQUIRED" ]]
      then
	echo "  Variable 'dockerToken' is defined but is not set correctly"
      fi
    else
      echo "  Variable 'dockerToken' is not defined but must be defined as variable 'dockerUserName' is defined"
    fi
  else
    if [[ ! -z "${dockerToken+x}" ]]
    then
      if [[ "${dockerToken}" == "REQUIRED" ]]
      then
        if $validationSuccess
        then
          echo "Validating configuration failed:"
          validationSuccess=false
        fi
	echo "  Variable 'dockerToken' is defined but is not set correctly"
      else
        INTERNALDOCKERINFO="dockerUserName=${dockerUserName} dockerToken=${dockerToken}"
      fi
    else
      if $validationSuccess
      then
        echo "Validating configuration failed:"
        validationSuccess=false
      fi
      echo "  Variable 'dockerToken' is not defined but must be defined as variable 'dockerUserName' is defined"
    fi
  fi
# dockerUserName is not defined, check dockerToken variable
else
  if [[ ! -z "${dockerToken+x}" ]]
  then
    if [[ "${dockerToken}" == "REQUIRED" ]]
    then
      if $validationSuccess
      then
	echo "Validating configuration failed:"
	validationSuccess=false
      fi
      echo "  Variable 'dockerUserName' is not defined but must be defined as variable 'dockerToken' is defined"
      echo "  Variable 'dockerToken' is defined but is not set correctly"
    else
      if $validationSuccess
      then
        echo "Validating configuration failed:"
        validationSuccess=false
      fi
      echo "  Variable 'dockerUserName' is not defined but must be defined as variable 'dockerToken' is defined"
    fi
  fi
fi

if [ ! -z "${configureLabs+x}" ]
then
	enableConfigureLabsInternal=enableConfigureSWATLabs=${configureLabs}
fi

if [[ "${enableContentAssistant}" == "true" ]]
then
  internalEnableContentAssistant=enableContentAssistant=${enableContentAssistant}
  
  if [[ "${genAIRegion}" == "REQUIRED" ]] || [[ "${genAIRegion}" == "" ]]
  then
     if $validationSuccess
     then
       echo "Validating configuration failed:"
       validationSuccess=false
     fi
    echo "  Variable 'enableContentAssistant' is set to 'true' but variable 'genAIRegion' has not been set"
  else
    internalGenAIRegion=genAIRegion=${genAIRegion}
  fi
  
  if [[ "${genAIAccessCode}" == "REQUIRED" ]] || [[ "${genAIAccessCode}" == "" ]]
  then
     if $validationSuccess
     then
       echo "Validating configuration failed:"
       validationSuccess=false
     fi
    echo "  Variable 'enableContentAssistant' is set to 'true' but variable 'genAIAccessCode' has not been set"
  else
    internalGenAIAccessCode=genAIAccessCode=${genAIAccessCode}
  fi
  
  if [[ "${genAIRegionRequired}" == "REQUIRED" ]] || [[ "${genAIRegionRequired}" == "" ]]
  then
     if $validationSuccess
     then
       echo "Validating configuration failed:"
       validationSuccess=false
     fi
    echo "  Variable 'enableContentAssistant' is set to 'true' but variable 'genAIRegionRequired' has not been set"
  else
    internalGenAIServiceURL=genAIRegionRequired=${genAIRegionRequired}
  fi
fi

if [ ! -z "${restrictContentAssistantToUser+x}" ]
then
  if [[ "${restrictContentAssistantToUser}" != "" ]]
  then
    internalRestrictContentAssistantToUser=restrictContentAssistantToUser=${restrictContentAssistantToUser}
  fi
fi

if [ ! -z "${icaDesktopName+x}" ]
then
  internalICADesktopName=icaDesktopName=${icaDesktopName}
fi

if [ ! -z "${enableWFGenAI+x}" ]
then
  internalEnableWFGenAI=enableWFGenAI=${enableWFGenAI}
fi

if [ ! -z "${enableWFAssistant+x}" ]
then
  internalEnableWFAssistant=enableWFAssistant=${enableWFAssistant}
fi

if [ ! -z "${graphQLURL+x}" ]
then
  if [[ "${graphQLURL}" != "" ]]
  then
    internalGraphQLURL=graphQLURL=${graphQLURL}
  fi
fi

if [ ! -z "${icnBaseURL+x}" ]
then
  if [[ "${icnBaseURL}" != "" ]] 
  then
    internalIcnBaseURL=icnBaseURL=${icnBaseURL}
  fi
fi

if [ ! -z "${createSampleCaseDataForNumUsers+x}" ]
then
  if [[ "${createSampleCaseDataForNumUsers}" != "" ]]
  then
    internalNumUsersSampleCaseDataForWFAssistant=numUsersSampleCaseDataForWFAssistant=${createSampleCaseDataForNumUsers}
  fi
fi

if [ ! -z "${createSampleCaseDataForNumUsers+x}" ]
then
  if [[ "${createSampleCaseDataForNumUsers}" != "" ]]
  then
    internalMaxCaseIteratorThreads=maxCaseIteratorThreads=${maxCaseIteratorThreads}
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

java ${jvmSettings} -jar ${TOOLFILENAME} ${bootstrapDebugString} ${BOOTSTRAPURL} \"-scriptDownloadPath=${SCRIPTDOWNLOADPATH}\" \"-scriptName=${FILENAME}\" \"-scriptSource=${SCRIPTNAME}\" \"-scriptVersion=${SCRIPTVERSION}\" -ocLoginServer=${ocLoginServer} -ocLoginToken=${ocLoginToken} ${cp4baNamespaceInternal} ${TOOLPROXYSETTINGS} -installBasePath=${DEPLOYMENTPATTERN} -config=${CONFIGNAME} -automationScript=${AUTOMATIONSCRIPT} -cp4baAdminPwd=${cp4baAdminPassword} ${giteaCredentials} ${enableConfigureLabsInternal} enableDeployClientOnboarding_ADP=${adpConfigured} ACTION_wf_cp_adpEnabled=${adpConfigured} ${enableDeployEmailCapabilityInternal} ${ocpStorageClassForInternalMailServerInternal} ${ldifFileLineInternal} ${gmailAddressInternal} ${gmailAppKeyInternal} ${INTERNALDOCKERINFO} ACTION_wf_cp_rpaBotExecutionUser=${rpaBotExecutionUser} ACTION_wf_cp_rpaServer=${rpaServer} ${internalEnableContentAssistant} ${internalRestrictContentAssistantToUser} ${internalGenAIRegion} ${internalGenAIAccessCode} ${internalGenAIServiceURL} ${internalEnableWFGenAI} ${internalEnableWFAssistant} ${internalICADesktopName} ${internalGraphQLURL} ${internalIcnBaseURL} ${internalNumUsersSampleCaseDataForWFAssistant} ${internalMaxCaseIteratorThreads} ${additionalOptions}