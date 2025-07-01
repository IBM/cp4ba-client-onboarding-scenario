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

# This file is to be used with CP4BA 25.0.0 Enterprise deployment that was deployed using 
# either Apollo-One-Shot or Cloud Pak Deployer approach with a co-deployed gitea to deploy
# the Client Onboarding scenario and associated labs

# Set all variables according to your environment before executing this file either
# by editing the file or using the respective command line options

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

# Set to false in case environment the Client Onboarding lab artifacts should not be deployed and only the Client Onboarding scenario is required (if set to false, will reduce deployment time)
configureLabs=true

# Set to true in case environment should be used to perform Workflow labs using business users (user1-user10) instead of admin user (cp4admin)
enableWorkflowLabsForBusinessUsers=false

# Should one or multiple users be added to the Cloud Pak as part of deploying the solution (The actual users need to be specified in a file called 'AddUsersToPlatform.json' in the directory of this file.)
createUsers=false

# Flag that determines if the internal email server is used/deployed or the external gmail service
# (In case the internal email server is used, the users are retrieved from the local LDAP. 
#  In case of the gmail server the two properties 'gmailAddress' and 'gmailAppKey' need to be specified)
useInternalMailServer=true

# Name of the storage class for the internal mail server (TechZone normally uses ocs-storagecluster-cephfs, ROKS cp4a-file-delete-gold-gid)
ocpStorageClassForInternalMailServer=ocs-storagecluster-cephfs

# Email address of a gmail account to be used to send emails in the Client Onboarding scenario (in case useInternalMailServer is set to false)
gmailAddress=REQUIRED
# App key for accessing the gmail account to send emails (in case useInternalMailServer is set to false)
gmailAppKey=REQUIRED

# Uncomment following two lines in case you want to use your Docker.io account instead of pulling images for the mail server anonymously (mostly relvant when anonymous pull limit has been reached)
#dockerUserName=REQUIRED
#dockerToken=REQUIRED

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
#bootstrapDebugString=*=finest

# Specify a value if the log files should be written to a specific path, otherwise will be written to the location from which this file is executed
outputPath=

# Change to true in case detailed output messages and/or trace messages should be printed to the console
printDetailedMessageToConsole=false
printTraceMessageToConsole=false

# ----------------------------------------------------------------------------------------------------------
# Section handling values specified on the command line, requires GNU’s getopt command
# ----------------------------------------------------------------------------------------------------------

VALID_ARGS=$(getopt -o h --long dd,dv,dc,ocls:,oclt:,ns:,pscenario:,phost:,pport:,puser:,ppwd:,cl:,cu:,ewflbu:,rpau:,rpas:,uims:,gmaila:,gmailk:,sc:,du:,dt:,jvm:,ds:,bd:,op:,pdmtoc:,ptmtoc:,dgithub: -- "$@")
if [[ $? -ne 0 ]]; then
  exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -h)
        echo "HELP"
        echo "Optional command line parameters (overwriting parameters set in sh file):"
        echo "--ocls = ocpLoginServer"
        echo "--oclt = ocpLoginToken"
        echo "--ns = cp4baNamespace"
        echo "--pscenario = proxyScenario (needs to be GitHub if set)"
        echo "--phost = proxyHost"
        echo "--pport = proxyPort"
        echo "--puser = proxyUser"
        echo "--ppwd = proxyPwd"
        echo "--cl = configureLabs (true/false)"
        echo "--cu = createUsers (true/false)"
        echo "--ewflbu = enableWorkflowLabsForBusinessUsers (true/false)"
        echo "--rpau = rpaBotExecutionUser"
        echo "--rpas = rpaServer"
        echo "--uims = useInternalMailServer"
        echo "--sc = ocpStorageClassForInternalMailServer"
        echo "--gmaila = gmailAddress"
        echo "--gmailk = gmailAppKey"
        echo "--du = dockerUserName"
        echo "--dt = dockerToken"
        echo "--jvm = jvmSettings"
        echo "--bd = bootstrapDebugString"
        echo "--ds = debugString"
        echo "--dgithub = disableAccessToGitHub (true/false)"
        echo "--op = outputPath"
        echo "--pdmtoc = printDetailedMessageToConsole (true/false)"
        echo "--ptmtoc = printTraceMessageToConsole (true/false)"
        shift;
        exit 0;
        ;;
    --dd)
        dumpDetails=true
        shift
        ;;
    --dv)
        dumpVariables=true
        shift
        ;;
    --dc)
        dumpCmd=true
        shift
        ;;
    --ocls)
        ocLoginServer=$2
        shift 2
        ;;
    --oclt)
        ocLoginToken=$2
        shift 2
        ;;
    --ns)
        cp4baNamespace=$2
        shift 2
        ;;
    --pscenario)
        proxyScenario=$2
        shift 2
        ;;
    --phost)
        proxyHost=$2
        shift 2
        ;;
    --pport)
        proxyPort=$2
        shift 2
        ;;
    --puser)
        proxyUser=$2
        shift 2
        ;;
    --ppwd)
        proxyPwd=$2
        shift 2
        ;;
    --cl)
        configureLabs=$2
        shift 2
        ;;
    --cu)
        createUsers=$2
        shift 2
        ;;
    --ewflbu)
        enableWorkflowLabsForBusinessUsers=$2
        shift 2
        ;;
    --rpau)
        rpaBotExecutionUser=$2
        shift 2
        ;;
    --rpas)
        rpaServer=$2
        shift 2
        ;;
    --uims)
        useInternalMailServer=$2
        shift 2
        ;;
    --gmaila)
        gmailAddress=$2
        shift 2
        ;;
    --gmailk)
        gmailAppKey=$2
        shift 2
        ;;
    --sc)
        ocpStorageClassForInternalMailServer=$2
        shift 2
        ;;
    --du)
        dockerUserName=$2
        shift 2
        ;;
    --dt)
        dockerToken=$2
        shift 2
        ;;
    --jvm)
        jvmSettings=$2
        shift 2
        ;;
    --bd)
        bootstrapDebugString=$2
        shift 2
        ;;
    --ds)
        debugString=$2
        shift 2
        ;;
    --op)
        outputPath=$2
        shift 2
        ;;
    --pdmtoc)
        printDetailedMessageToConsole=$2
        shift 2
        ;;
    --ptmtoc)
        printTraceMessageToConsole=$2
        shift 2
        ;;
    --dgithub)
        disableAccessToGitHub=$2
        shift 2
        ;;
    --) shift; 
        break 
        ;;
  esac
done

if [ ! -z "${dumpVariables+x}" ]
then
  echo "Config parameter values:"
  echo "ocLoginServer '${ocLoginServer}'"
  echo "ocLoginToken '${ocLoginToken}'"
  echo "cp4baNamespace '${cp4baNamespace}'"
  echo "proxyScenario '${proxyScenario}'"
  echo "proxyHost '${proxyHost}'"
  echo "proxyPort '${proxyPort}'"
  echo "proxyUser '${proxyUser}'"
  echo "proxyPwd '${proxyPwd}'"
  echo "configureLabs '${configureLabs}'"
  echo "createUsers '${createUsers}'"
  echo "enableWorkflowLabsForBusinessUsers '${enableWorkflowLabsForBusinessUsers}'"
  echo "rpaBotExecutionUser '${rpaBotExecutionUser}'"
  echo "rpaServer '${rpaServer}'"
  echo "useInternalMailServer '${useInternalMailServer}"
  echo "gmailAddress '${gmailAddress}'"
  echo "gmailAppKey '${gmailAppKey}'"
  echo "ocpStorageClassForInternalMailServer '${ocpStorageClassForInternalMailServer}'"
  echo "dockerUserName '${dockerUserName}'"
  echo "dockerToken '${dockerToken}'"
  echo "jvmSettings '${jvmSettings}'"
  echo "bootstrapDebugString '${bootstrapDebugString}'"
  echo "debugString '${debugString}'"
  echo "disableAccessToGitHub '${disableAccessToGitHub}'"
  echo "outputPath '${outputPath}'"
  echo "printDetailedMessageToConsole '${printDetailedMessageToConsole}'"
  echo "printTraceMessageToConsole '${printTraceMessageToConsole}'"
fi

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
SCRIPTNAME=deployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh
# Name of the actual sh file passed to execution environment
FILENAME=$0
# Version of this script file passed to execution environment
SCRIPTVERSION=1.0.0
# Download URL for this script
SCRIPTDOWNLOADPATH=https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/${CP4BAVERSION%}/Deployment_Automation/${SCRIPTNAME%}
# Variable values to be copied to newer version in case found
COPYVARVALUES=ocLoginServer,ocLoginToken,cp4baNamespace,configureLabs,enableWorkflowLabsForBusinessUsers,createUsers,useInternalMailServer,ocpStorageClassForInternalMailServer,gmailAddress,gmailAppKey,dockerUserName,dockerToken,rpaBotExecutionUser,rpaServer,adpConfigured,jvmSettings,disableAccessToGitHub,proxyScenario,proxyHost,proxyPort,proxyUser,proxyPwd,proxyPwd,bootstrapDebugString,outputPath,printDetailedMessageToConsole,printTraceMessageToConsole

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

if [ -z "${ocLoginServer+x}" ] || [[ "${ocLoginServer}" == "REQUIRED" ]] || [[ "${ocLoginServer}" == "" ]]
then
  if $validationSuccess
  then
    echo "Validating configuration failed:"
    validationSuccess=false
   fi
   echo "  Variable 'ocLoginServer' has not been defined/set"
else
  INTERNALOCLOGINSERVER=-ocls=${ocLoginServer}
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'ocLoginToken' = '${INTERNALOCLOGINTOKEN}'" 
  fi
fi

if [ -z "${ocLoginToken+x}" ] || [[ "${ocLoginToken}" == "REQUIRED" ]] || [[ "${ocLoginToken}" == "" ]]
then
  if $validationSuccess
  then
    echo "Validating configuration failed:"
    validationSuccess=false
  fi
  echo "  Variable 'ocLoginToken' has not been defined/set"
else
  INTERNALOCLOGINTOKEN=-oclt=${ocLoginToken}
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'cp4baNamespace' = '${INTERNALCP4BANAMESPACE}'" 
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
      echo "  Variable 'useInternalMailServer' is set to 'true' but variable 'gmailAddress' has not been set"
    else
      GMAILADDRESSINTERNAL=wf_cp_emailID=${gmailAddress}
      if [ ! -z "${dumpDetails+x}" ]
      then
        echo "set 'gmailAddress' = '${GMAILADDRESSINTERNAL}'" 
      fi
    fi
  else
    echo "  Variable 'useInternalMailServer' is set to 'true' but variable 'gmailAddress' has not been set"
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
      echo "  Variable 'useInternalMailServer' is set to 'true' but variable 'gmailAppKey' has not been set"
    else
      GMAILAPPKEYINTERNAL=wf_cp_emailPassword=${gmailAppKey}
      if [ ! -z "${dumpDetails+x}" ]
      then
        echo "set 'gmailAppKey' = '${GMAILAPPKEYINTERNAL}'" 
      fi
    fi
  else
    echo "  Variable 'useInternalMailServer' is set to 'true' but variable 'gmailAppKey' has not been set"
  fi
  ENABLEDEPLOYEMAILCAPABILITYINTERNAL=enableDeployEmailCapability=false
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'enableDeployEmailCapability' = '${ENABLEDEPLOYEMAILCAPABILITYINTERNAL}'" 
  fi
else
  ENABLEDEPLOYEMAILCAPABILITYINTERNAL=enableDeployEmailCapability=true
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'enableDeployEmailCapability' = '${ENABLEDEPLOYEMAILCAPABILITYINTERNAL}'" 
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
    INTERNALCP4BANAMESPACE=-cp4bans=${cp4baNamespace}
    if [ ! -z "${dumpDetails+x}" ]
    then
      echo "set 'cp4baNamespace' = '${INTERNALCP4BANAMESPACE}'" 
    fi
  fi
fi

if [[ ! -z "${createUsers+x}" ]] && "${createUsers}" == "true"
then
  CREATEUSERSFILEINTERNAL=onboardUsersFile=AddUsersToPlatform.json
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'onboardUsersFile' = '${CREATEUSERSFILEINTERNAL}'" 
  fi

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
        if [ ! -z "${dumpDetails+x}" ]
        then
          echo "set 'dockerInfo' = '${INTERNALDOCKERINFO}'" 
        fi
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

if [[ ! -z "${printDetailedMessageToConsole+x}" ]]
then
  if [[ "${printDetailedMessageToConsole}" == "true" ]]
  then
    INTERNALPDMTOC=-pdmtc
    if [ ! -z "${dumpDetails+x}" ]
    then
      echo "set 'printDetailedMessageToConsole' = '${INTERNALPDMTOC}'" 
    fi
  fi
fi

if [[ ! -z "${printTraceMessageToConsole+x}" ]]
then
  if [[ "${printTraceMessageToConsole}" == "true" ]]
  then
    INTERALPTCTOC=-ptmtc
    if [ ! -z "${dumpDetails+x}" ]
    then
      echo "set 'printTraceMessageToConsole' = '${INTERALPTCTOC}'" 
    fi
  fi
fi

if [[ ! -z "${outputPath+x}" ]]
then
  INTERNALOUTPUTPATH=\"-op=${outputPath}\"
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'outputPath' = '${INTERNALOUTPUTPATH}'" 
  fi
fi

OCPSTORAGECLASSFOREMAILINTERNAL=ocpStorageClassForMail=${ocpStorageClassForInternalMailServer}

if [ ! -z "${enableWorkflowLabsForBusinessUsers+x}" ]
then
  WORKFLOWLABSFORBUSINESSUSERSINTERNAL=enableWFLabForBusinessUsers=${enableWorkflowLabsForBusinessUsers}
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'enableWFLabForBusinessUsers' = '${WORKFLOWLABSFORBUSINESSUSERSINTERNAL}'" 
  fi
fi

if [ ! -z "${configureLabs+x}" ]
then
  ENABLECONFIGURELABSINTERNAL=enableConfigureSWATLabs=${configureLabs}
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'enableConfigureSWATLabs' = '${ENABLECONFIGURELABSINTERNAL}'" 
  fi
fi

if [ ! -z "${bootstrapDebugString+x}" ]
then
  BOOTSTRAPDEBUGSTRINGINTERNAL=\"-bds=${bootstrapDebugString}\"
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'bootstrapDebugString' = '${BOOTSTRAPDEBUGSTRINGINTERNAL}'" 
  fi
fi

if [ ! -z "${debugString+x}" ]
then
  DEBUGSTRINGINTERNAL=\"debugString=${debugString}\"
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'debugString' = '${DEBUGSTRINGINTERNAL}'" 
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

if [ ! -z "${dumpCmd+x}" ]
then
  echo java ${jvmSettings} -jar ${TOOLFILENAME} ${BOOTSTRAPDEBUGSTRINGINTERNAL} ${BOOTSTRAPURL} \"-sdp=${SCRIPTDOWNLOADPATH}\" \"-sn=${FILENAME}\" \"-ss=${SCRIPTNAME}\" \"-sv=${SCRIPTVERSION}\" ${INTERNALOCLOGINSERVER} ${INTERNALOCLOGINTOKEN} ${INTERNALCP4BANAMESPACE} ${TOOLPROXYSETTINGS} ${DEBUGSTRINGINTERNAL} -ibp=${DEPLOYMENTPATTERN} -c=${CONFIGNAME} -as=${AUTOMATIONSCRIPT} ${DISABLEACCESSTOGITHUBINTERNAL} ${INTERNALOUTPUTPATH} ${INTERNALPDMTOC} ${INTERALPTCTOC} ${OCPSTORAGECLASSFOREMAILINTERNAL} ${GMAILADDRESSINTERNAL} ${GMAILAPPKEYINTERNAL} ${ENABLECONFIGURELABSINTERNAL} ${WORKFLOWLABSFORBUSINESSUSERSINTERNAL} ${CREATEUSERSFILEINTERNAL} ${ENABLEDEPLOYEMAILCAPABILITYINTERNAL} ${INTERNALDOCKERINFO} enableDeployClientOnboarding_ADP=${adpConfigured} ACTION_wf_cp_adpEnabled=${adpConfigured} ACTION_wf_cp_rpaBotExecutionUser=${rpaBotExecutionUser} ACTION_wf_cp_rpaServer=${rpaServer}
fi

java ${jvmSettings} -jar ${TOOLFILENAME} ${BOOTSTRAPDEBUGSTRINGINTERNAL} ${BOOTSTRAPURL} \"-sdp=${SCRIPTDOWNLOADPATH}\" \"-sn=${FILENAME}\" \"-ss=${SCRIPTNAME}\" \"-sv=${SCRIPTVERSION}\" ${INTERNALOCLOGINSERVER} ${INTERNALOCLOGINTOKEN} ${INTERNALCP4BANAMESPACE} ${TOOLPROXYSETTINGS} ${DEBUGSTRINGINTERNAL} -ibp=${DEPLOYMENTPATTERN} -c=${CONFIGNAME} -as=${AUTOMATIONSCRIPT} ${DISABLEACCESSTOGITHUBINTERNAL} ${INTERNALOUTPUTPATH} ${INTERNALPDMTOC} ${INTERALPTCTOC} ${OCPSTORAGECLASSFOREMAILINTERNAL} ${GMAILADDRESSINTERNAL} ${GMAILAPPKEYINTERNAL} ${ENABLECONFIGURELABSINTERNAL} ${WORKFLOWLABSFORBUSINESSUSERSINTERNAL} ${CREATEUSERSFILEINTERNAL} ${ENABLEDEPLOYEMAILCAPABILITYINTERNAL} ${INTERNALDOCKERINFO} enableDeployClientOnboarding_ADP=${adpConfigured} ACTION_wf_cp_adpEnabled=${adpConfigured} ACTION_wf_cp_rpaBotExecutionUser=${rpaBotExecutionUser} ACTION_wf_cp_rpaServer=${rpaServer}