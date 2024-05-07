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

# This file is to be used with CP4BA 23.0.2 Enterprise deployment that was deployed using 
# either Apollo-One-Shot or Cloud Pak Deployer approach with a co-deployed gitea to remove 
# the Client Onboarding scenario and associated labs

# Set all variables according to your environment before executing this file or use the respective command line options

#----------------------------------------------------------------------------------------------------------
# Specify below variables to launch the deployment automation with
#----------------------------------------------------------------------------------------------------------

# Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
ocLoginServer=REQUIRED
# Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
ocLoginToken=REQUIRED

# Modify below three properties according to your needs. Only if the previous option is set to true, the next option can be set to true, too 
# (e.g. only when cleanupClientOnboardingLabs_UserData is set to true, cleanupClientOnboardingLabs can be set to true)
# Potential use-cases:
# - You ran a workshop and want to reuse the environment, you may want to only remove user-data but keep the lab and scenario artifacts deployed (change the second and third option to false)
# - You want to remove the whole Client Onboarding Artifacts including! custom artifacts created by business users leave all three properties set to true
# Warning: cleanupClientOnboardingLabs_UserData does not remove data in CPE that was created using the admin user of the environment, only data created by the business users. If the admin user
# created data undeploying the content lab artfiacts may fail and manual cleanup may be required of the data created by the admin user before content lab artifcats can be undeployed successfully
cleanupClientOnboardingLabs_UserData=true
cleanupClientOnboardingLabs=true
cleanupClientOnboardingScenario=true

# Uncomment when the OCP cluster contains more than one namespace/project into which CP4BA has been deployed and specify the name of the namespace you want to deploy to. 
# If only one CP4BA namespace exists the deployment tool will determine the namespace automatically
#cp4baNamespace=REQUIRED

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

# Specify a value if the log files should be written to a specific path, otherwise will be written to the location from which this file is executed
outputPath=

# Change to true in case detailed output messages and/or trace messages should be printed to the console
printDetailedMessageToConsole=false
printTraceMessageToConsole=false

# ----------------------------------------------------------------------------------------------------------
# Section handling values specified on the command line, requires GNU’s getopt command
# ----------------------------------------------------------------------------------------------------------

VALID_ARGS=$(getopt -o h --long dd,dv,dc,ocls:,oclt:,ns:,pscenario:,phost:,pport:,puser:,ppwd:,cCOLUD:,cCOL:,cCOS:,bd:,ds:,op:,pdmtoc:,ptmtoc:,dgithub: -- "$@")
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
        echo "--cCOLUD = cleanupClientOnboardingLabs_UserData (true/false)"
        echo "--cCOL = cleanupClientOnboardingLabs (true/false)"
        echo "--cCOS = cleanupClientOnboardingScenario (true/false)"
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
    --cCOLUD)
        cleanupClientOnboardingLabs_UserData=$2
        shift 2
        ;;
    --cCOL)
        cleanupClientOnboardingLabs=$2
        shift 2
        ;;
    --cCOS)
        cleanupClientOnboardingScenario=$2
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
  echo "proxyHost '${proxyHost}'"
  echo "proxyPort '${proxyPort}'"
  echo "proxyUser '${proxyUser}'"
  echo "proxyPwd '${proxyPwd}'"
  echo "cleanupClientOnboardingLabs_UserData '${cleanupClientOnboardingLabs_UserData}'"
  echo "cleanupClientOnboardingLabs '${cleanupClientOnboardingLabs}'"
  echo "cleanupClientOnboardingScenario '${cleanupClientOnboardingScenario}'"
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
CP4BAVERSION="23.0.2"
# Deployment pattern of the CP4BA instance
DEPLOYMENTPATTERN="Enterprise"
# Source URL to bootstrap configuration for the deployment tool
BOOTSTRAPURL="-bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/${CP4BAVERSION}/Deployment_Automation/${DEPLOYMENTPATTERN}"
# Name of the configuration file to use when running the deployment automation tool
CONFIGNAME="config-undeploy-withGitea"
# Automation script to use when running the deployment automation tool
AUTOMATIONSCRIPT="RemoveClientOnboardingArtifactsGeneric.json"

# Name of the source sh file passed to execution environment
SCRIPTNAME=undeployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh
# Name of the actual sh file passed to execution environment
FILENAME=$0
# Version of this script file passed to execution environment
SCRIPTVERSION=1.0.1
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
    echo "set 'ocLoginServer' = '${INTERNALOCLOGINSERVER}'" 
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
    echo "set 'ocLoginToken' = '${INTERNALOCLOGINTOKEN}'" 
  fi
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

if ! $validationSuccess
then
  echo
fi

if ! $validationSuccess || ! $toolValidationSuccess
then
  echo "Exiting..."
  exit 1
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

if [ ! -z "${cleanupClientOnboardingLabs_UserData+x}" ]
then
  CLEANUPCLIENTONBOARDINGLABS_USERDATAINTERNAL=enableCleanupSWATLabs_UserData=${cleanupClientOnboardingLabs_UserData}
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'cleanupClientOnboardingLabs_UserData' = '${CLEANUPCLIENTONBOARDINGLABS_USERDATAINTERNAL}'" 
  fi
fi

if [ ! -z "${cleanupClientOnboardingLabs+x}" ]
then
  CLEANUPCLIENTONBOARDINGLABSINTERNAL=enableCleanupSWATLabs=${cleanupClientOnboardingLabs}
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'cleanupClientOnboardingLabs' = '${CLEANUPCLIENTONBOARDINGLABSINTERNAL}'" 
  fi
fi

if [ ! -z "${cleanupClientOnboardingScenario+x}" ]
then
  CLEANUPCLIENTONBOARDINGINTERNAL=enableCleanupClientOnboarding=${cleanupClientOnboardingScenario}
  if [ ! -z "${dumpDetails+x}" ]
  then
    echo "set 'enableCleanupClientOnboarding' = '${CLEANUPCLIENTONBOARDINGINTERNAL}'" 
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


if [ ! -z "${dumpCmd+x}" ]
then
  echo java -jar ${TOOLFILENAME} ${BOOTSTRAPDEBUGSTRINGINTERNAL} ${BOOTSTRAPURL} \"-sdp=${SCRIPTDOWNLOADPATH}\" \"-sn=${FILENAME}\" \"-ss=${SCRIPTNAME}\" \"-sv=${SCRIPTVERSION}\" ${INTERNALOCLOGINSERVER} ${INTERNALOCLOGINTOKEN} ${INTERNALCP4BANAMESPACE} ${TOOLPROXYSETTINGS} ${DEBUGSTRINGINTERNAL} -ibp=${DEPLOYMENTPATTERN} -c=${CONFIGNAME} -as=${AUTOMATIONSCRIPT} ${DISABLEACCESSTOGITHUBINTERNAL} ${CLEANUPCLIENTONBOARDINGLABS_USERDATAINTERNAL} ${CLEANUPCLIENTONBOARDINGLABSINTERNAL} ${CLEANUPCLIENTONBOARDINGINTERNAL} ${INTERNALOUTPUTPATH} ${INTERNALPDMTOC} ${INTERALPTCTOC}
fi

java -jar ${TOOLFILENAME} ${BOOTSTRAPDEBUGSTRINGINTERNAL} ${BOOTSTRAPURL} \"-sdp=${SCRIPTDOWNLOADPATH}\" \"-sn=${FILENAME}\" \"-ss=${SCRIPTNAME}\" \"-sv=${SCRIPTVERSION}\" ${INTERNALOCLOGINSERVER} ${INTERNALOCLOGINTOKEN} ${INTERNALCP4BANAMESPACE} ${TOOLPROXYSETTINGS} ${DEBUGSTRINGINTERNAL} -ibp=${DEPLOYMENTPATTERN} -c=${CONFIGNAME} -as=${AUTOMATIONSCRIPT} ${DISABLEACCESSTOGITHUBINTERNAL} ${CLEANUPCLIENTONBOARDINGLABS_USERDATAINTERNAL} ${CLEANUPCLIENTONBOARDINGLABSINTERNAL} ${CLEANUPCLIENTONBOARDINGINTERNAL} ${INTERNALOUTPUTPATH} ${INTERNALPDMTOC} ${INTERALPTCTOC}