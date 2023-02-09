#This file is to be used with CP4BA 21.0.3 starter deployment up to IF006 to deploy the Client Onboarding scenario and associated labs

#Set all variables according to your environment before executing this file

#----------------------------------------------------------------------------------------------------------
#Specify below variables to launch the deployment automation with
#----------------------------------------------------------------------------------------------------------

#Date stamp of the DeploymentAutomation.jar to be used, for example '20230206' when you are using '20230206_DeploymentAutomation.jar
toolVersion=REQUIRED
#Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
ocLoginServer=REQUIRED
#Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
ocLoginToken=REQUIRED

#Email address of a gmail account to be used to send emails in the Client Onboarding scenario
gmailAddress=REQUIRED
#App key for accessing the gmail account to send emails
gmailAppKey=REQUIRED



#User for who the RPA bot is executed (specifying a non-existing user basically skipped the RPA bot execution)
rpaBotExecutionUser=cp4admin2
#URL of the RPA server to be invoked for the RPA bot execution (currently not supported/tested, keep dummy value)
rpaServer=https://rpa-server.com:1111

#Proxy settings in case a proxy server needs to be used to access the GitHub resources
#proxySettings="-proxyScenario=GitHub -proxyHost= -proxyPort="

#----------------------------------------------------------------------------------------------------------
#Validation that all required variables are set and the jar file for the deployment automation tool exists
#----------------------------------------------------------------------------------------------------------

validationSuccess=true

if [[ "${toolVersion}" == "REQUIRED" ]] || [[ "${toolVersion}" == "" ]]
then
	if $validationSuccess
	then
		echo "Validating configuration failed:"
		validationSuccess=false
	fi
	echo "  Variable 'toolVersion' has not been set"
fi

if [[ ! -f ${toolVersion}_DeploymentAutomation.jar ]] 
then
	if $validationSuccess
	then
		echo "Validating configuration failed:"
		echo "  File '"${toolVersion}"_DeploymentAutomation.jar' does not exist"
		validationSuccess=false
	fi
fi

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

if [[ "${gmailAddress}" == "REQUIRED" ]] || [[ "${gmailAddress}" == "" ]]
then
	if $validationSuccess
	then
		echo "Validating configuration failed:"
		validationSuccess=false
	fi
	echo "  Variable 'gmailAddress' has not been set"
fi

if [[ "${gmailAppKey}" == "REQUIRED" ]] || [[ "${gmailAppKey}" == "" ]]
then
	if $validationSuccess
	then
		echo "Validating configuration failed:"
		validationSuccess=false
	fi
	echo "  Variable 'gmailAppKey' has not been set"
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

if ! $validationSuccess
then
	echo "Exiting"
	exit 1
fi

java ${JVM_SETTINGS} -jar ${toolVersion}_DeploymentAutomation.jar -bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/21.0.3/Deployment_Automation/Starter -ocLoginServer=${ocLoginServer} -ocLoginToken=${ocLoginToken} ${proxySettings} -installBasePath=Starter -config=config-deploy -automationScript=DeployClientOnboardingEmbeddedGitea.json ACTION_wf_cp_emailID=${gmailAddress} ACTION_wf_cp_emailPassword=${gmailAppKey} ACTION_wf_cp_rpaBotExecutionUser=${rpaBotExecutionUser} ACTION_wf_cp_rpaServer=${rpaServer}