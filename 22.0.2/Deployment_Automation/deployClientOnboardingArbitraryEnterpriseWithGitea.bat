@echo off
rem ###############################################################################
rem #
rem # Licensed Materials - Property of IBM
rem #
rem # (C) Copyright IBM Corp. 2023. All Rights Reserved.
rem #
rem # US Government Users Restricted Rights - Use, duplication or
rem # disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
rem #
rem ###############################################################################

echo.
SETLOCAL
rem This file is to be used with an arbitrary CP4BA 22.0.2 Enterprise deployment with a co-deployed gitea to deploy the Client Onboarding scenario and associated labs (by default using an  external mail server)

rem Set all variables according to your environment before executing this file

rem ----------------------------------------------------------------------------------------------------------
rem Specify below variables to launch the deployment automation with
rem ----------------------------------------------------------------------------------------------------------

rem Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginServer=REQUIRED
rem Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginToken=REQUIRED

rem Uncomment when the OCP cluster contains more than one namespace/project into which CP4BA has been deployed and specify the name of the namespace you want to deploy to. 
rem If only one CP4BA namespace exists the deployment tool will determine the namespace automatically
rem SET cp4baNamespace=

rem Fully qualified user id (cn=<username>, dc=<org>, ... or uid=<username>, ...) of an admin user for the CP4BA instance
SET cp4baAdminUserName=REQUIRED
rem Password for the CP4BA admin user to use to access the CP4BA environment
SET cp4baAdminPassword=REQUIRED
rem Fully qualified name of a group (cn=<groupname>, dc=<org>, ...) that contains the admin user/users for the CP4BA instance
SET cp4baAdminGroup=REQUIRED
rem Fully qualified name of a group (cn=<groupname>, dc=<org>, ...) that contains business users for the CP4BA instance
SET generalUsersGroup=REQUIRED
rem Uncomment when the admin credentials for the embedded Gitea differ from the credentials of the CP4BA admini
rem SET giteaCredentials="-giteaUserName= -giteaUserPwd="


rem Comment out below two properties if an internal mail server/client should be used to send emails or provide credentials for an external gmail account if emails should be sent to external email addresses

rem Email address of a gmail account to be used to send emails in the Client Onboarding scenario
SET gmailAddress=REQUIRED
rem App key for accessing the gmail account to send emails
SET gmailAppKey=REQUIRED



rem User for who the RPA bot is executed (specifying a non-existing user basically skipped the RPA bot execution)
SET rpaBotExecutionUser=cp4admin2
rem URL of the RPA server to be invoked for the RPA bot execution (currently not supported/tested, keep dummy value)
SET rpaServer=https://rpa-server.com:1111

rem Should ADP be used within the Client Oboarding scenario (do not change for now)
SET adpConfigured=false
rem Should the Content labs be configured (requires the expected object store to exist)
SET configureContentLab=false

rem Uncomment in case JVM throws an "Out Of Memory"-exception during the execution
rem SET jvmSettings=-Xms4096M

rem Uncomment in case GitHub is not accessible and all resources are already available locally
rem SET disableAccessToGitHub="-disableAccessToGitHub=true"

rem Proxy settings in case a proxy server needs to be used to access the GitHub resources
rem Uncomment at least the proxyScenario, proxyHost, and proxyPort lines and set values accordingly in case a proxy server needs to be used to access GitHub
rem Uncomment the lines proxyUser and proxyPwd too, in case the proxy server requires authentication
rem SET proxyScenario=GitHub
rem SET proxyHost=
rem SET proxyPort=
rem SET proxyUser=
rem SET proxyPwd=

rem Specific trace string for the boostrapping process (only uncomment if instructed to do so)
rem SET bootstrapDebugString="-bootstrapDebugString=*=finest"

rem ----------------------------------------------------------------------------------------------------------
rem Construct the proxy settings for curl and deployment automation tool if proxy is configured
rem ----------------------------------------------------------------------------------------------------------

if defined proxyHost (
	if defined proxyUser (
		SET TOOLPROXYSETTINGS="-proxyScenario=%proxyScenario% -proxyHost=%proxyHost% -proxyPort=%proxyPort% -proxyUser=%proxyUser% -proxyPwd=%proxyPwd%"
		
		if "%proxyScenario%"=="GitHub" (
			SET CURLPROXYSETTINGS="-x %proxyHost%:%proxyPort% -U %proxyUser%:%proxyPwd%"
		)
	) else (
		SET TOOLPROXYSETTINGS="-proxyScenario=%proxyScenario% -proxyHost=%proxyHost% -proxyPort=%proxyPort%"
		
		if "%proxyScenario%"=="GitHub" (
			SET CURLPROXYSETTINGS="-x %proxyHost%:%proxyPort%"
		)
	)
)

rem ----------------------------------------------------------------------------------------------------------
rem Global settings for the script (not to be modified by user)
rem ----------------------------------------------------------------------------------------------------------

rem Source URL where the deployment automation jar can be retrieved from
SET TOOLSOURCE=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/Deployment_Automation
rem CP4BA version
SET CP4BAVERSION=22.0.2
rem Deployment pattern of the CP4BA instance
SET DEPLOYMENTPATTERN=Enterprise
rem Source URL to bootstrap configuration for the deployment tool
SET BOOTSTRAPURL=-bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/%CP4BAVERSION%/Deployment_Automation/%DEPLOYMENTPATTERN%
rem Name of the configuration file to use when running the deployment automation tool
SET CONFIGNAME=config-deploy-withGitea
rem Automation script to use when running the deployment automation tool
SET AUTOMATIONSCRIPT=DeployClientOnboardingEmbeddedGitea.json

rem Name of the script file passed to execution environment
SET SCRIPTNAME=deployClientOnboardingArbitraryEnterpriseWithGitea.bat
rem Version of this script file passed to execution environment
SET SCRIPTVERSION=1.1.0
rem Download URL for this script
SET SCRIPTDOWNLOADPATH=https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/%CP4BAVERSION%/Deployment_Automation/%SCRIPTNAME%

rem ----------------------------------------------------------------------------------------------------------
rem Retrieve the deployment automation jar file from GitHub if not already available or use local one when 
rem GitHub access is disabled. Validate that the deployment tool jar is available
rem ----------------------------------------------------------------------------------------------------------

echo Bootstrapping deployment automation tool:
rem Depending on the fact if access to GitHub is prohibited jump to the correct way of retrieving and validating the version of the deployment automation jar
if defined disableAccessToGitHub (
	goto useLocalTool
) else (
	goto downloadTool
)

rem Try to download deployment automation jar from GitHub
:downloadTool
	rem Retrieve the download URL of the only deployment automation jar that is available in the GitHub repository
	for /f "tokens=*" %%i in ('curl -s -X GET %TOOLSOURCE% %CURLPROXYSETTINGS% ^| findstr /l "download_url"') do set DOWNLOADLINE=%%i

	rem Retrieve the protocol and URL portions including additional characters
	for /f "tokens=1,2,3 delims=:" %%a in ("%DOWNLOADLINE%") do (
		set PROTOCOL=%%b
		set URL=%%c
	)

	rem Construct the download URL from the fragments removing extra characters
	SET DOWNLOADURL=https:%URL:~0,-2%

	rem Extract the actual name of the deployment automation jar that is started later on
	for %%a in (%DOWNLOADURL:/= %) do set TOOLFILENAME=%%a

	rem In case the deployment automation jar does not yet exist locally download it otherwise print a msg that no download is required
	if not exist %TOOLFILENAME% (
		echo   Downloading deployment automation jar %TOOLFILENAME% from GitHub
		curl -O %DOWNLOADURL% %CURLPROXYSETTINGS%
	) else (
		echo   Deployment automation jar file '%TOOLFILENAME%' already exists, no need to download it from Github
	)

	rem if the tool still does not exist something went wrong during download
	if not exist %TOOLFILENAME% (
		set toolValidationFailed=true
		echo   Failure to download %TOOLFILENAME% from %DOWNLOADURL%
	)
	
	goto continueCheck

rem Check if the deployment automation jar is available locally
:useLocalTool
	rem Determine if the deployment automation tool is available and in case it is store it exact name to be used later to run it
	for /f "tokens=*" %%i in ('dir /b * ^| findstr /l "DeploymentAutomation.jar"') do set TOOLFILENAME=%%i
	
	rem In case not available/found print error and mark as validation failed
	if not defined TOOLFILENAME (
		set toolValidationFailed=true
		echo   No version of the deployment automation jar could be found while retrieval from GitHub is disabled
	) else (
		echo   Using local deployment automation jar file '%TOOLFILENAME%' as retrieval from GitHub is disabled
	)
	
	goto continueCheck

:continueCheck
	echo:

rem ----------------------------------------------------------------------------------------------------------
rem Validation that all required parameters are set
rem ----------------------------------------------------------------------------------------------------------

if "%ocLoginServer%"=="REQUIRED" set ocLoginServerRequired=true
if "%ocLoginServer%"=="" set ocLoginServerRequired=true

if defined ocLoginServerRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'ocLoginServer' has not been set
)

if "%ocLoginToken%"=="REQUIRED" set ocLoginTokenRequired=true
if "%ocLoginToken%"=="" set ocLoginTokenRequired=true

if defined ocLoginTokenRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'ocLoginToken' has not been set
)

if "%cp4baAdminUserName%"=="REQUIRED" set cp4baAdminUserNameRequired=true
if "%cp4baAdminUserName%"=="" set cp4baAdminUserNameRequired=true

if defined cp4baAdminUserNameRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	
	echo   Variable 'cp4baAdminUserName' has not been set
)

if "%cp4baAdminPassword%"=="REQUIRED" set cp4baAdminPasswordRequired=true
if "%cp4baAdminPassword%"=="" set cp4baAdminPasswordRequired=true

if defined cp4baAdminPasswordRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	
	echo   Variable 'cp4baAdminPassword' has not been set
)

if "%cp4baAdminGroup%"=="REQUIRED" set cp4baAdminGroupRequired=true
if "%cp4baAdminGroup%"=="" set cp4baAdminGroupRequired=true

if defined cp4baAdminGroupRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	
	echo   Variable 'cp4baAdminGroup' has not been set
)

if "%generalUsersGroup%"=="REQUIRED" set generalUsersGroupRequired=true
if "%generalUsersGroup%"=="" set generalUsersGroupequired=true

if defined generalUsersGroupRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	
	echo   Variable 'generalUsersGroup' has not been set
)

if defined gmailAddress (
	if "%gmailAddress%"=="REQUIRED" set gmailAddressRequired=true
	if "%gmailAddress%"=="" set gmailAddressRequired=true

	if defined gmailAddressRequired ( 
		if not defined validationFailed (
			echo Validating configuration failed:
			set validationFailed=true
		)
		echo   Variable 'gmailAddress' has not been set
	) else (
		set gmailAddressInternal=wf_cp_emailID=%gmailAddress%
	)
)

if defined gmailAppKey (
	if "%gmailAppKey%"=="REQUIRED" set gmailAppKeyRequired=true
	if "%gmailAppKey%"=="" set gmailAppKeyRequired=true

	if defined gmailAppKeyRequired ( 
		if not defined validationFailed (
			echo Validating configuration failed:
			set validationFailed=true
		)
		echo   Variable 'gmailAppKey' has not been set
	) else (
		set gmailAppKeyInternal=wf_cp_emailPassword=%gmailAppKey%
	)
)

if "%rpaBotExecutionUser%"=="REQUIRED" set rpaBotExecutionUserRequired=true
if "%rpaBotExecutionUser%"=="" set rpaBotExecutionUserRequired=true

if defined rpaBotExecutionUserRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'rpaBotExecutionUser' has not been set
)

if "%rpaServer%"=="REQUIRED" set rpaServerRequired=true
if "%rpaServer%"=="" set rpaServerRequired=true

if defined rpaServerRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'rpaServer' has not been set
)

if "%adpConfigured%"=="REQUIRED" set adpConfiguredRequired=true
if "%adpConfigured%"=="" set adpConfiguredRequired=true

if defined adpConfiguredRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'adpConfigured' has not been set
)

if "%configureContentLab%"=="REQUIRED" set configuredContentLabRequired=true
if "%configureContentLab%"=="" set configuredContentLabRequired=true

if defined configuredContentLabRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'configureContentLab' has not been set
)

if defined toolValidationFailed set overallValidationFailed=true
if defined validationFailed set overallValidationFailed=true

if defined overallValidationFailed (
	echo:
	echo Existing...
	exit /b 1;
)

echo Starting deployment automation tool...
echo:

java %jvmSettings% -jar %TOOLFILENAME% %bootstrapDebugString% %BOOTSTRAPURL% -scriptDownloadPath=%SCRIPTDOWNLOADPATH% -scriptName=%SCRIPTNAME% -scriptVersion=%SCRIPTVERSION% -ocLoginServer=%ocLoginServer% -ocLoginToken=%ocLoginToken% %cp4baNamespace% %TOOLPROXYSETTINGS% -installBasePath=/%DEPLOYMENTPATTERN% -config=%CONFIGNAME% -automationScript=%AUTOMATIONSCRIPT% "cp4baAdminUserName=%cp4baAdminUserName%" -cp4baAdminPwd=%cp4baAdminPassword% "cp4baAdminGroup=%cp4baAdminGroup%" "generalUsersGroupName=%generalUsersGroup%" %giteaCredentials% enableDeployClientOnboarding_ADP=%adpConfigured% enableConfigureSWATLabs_FNCM=%configureContentLab% ACTION_wf_cp_adpEnabled=%adpConfigured% %gmailAddressInternal% %gmailAppKeyInternal% ACTION_wf_cp_rpaBotExecutionUser=%rpaBotExecutionUser% ACTION_wf_cp_rpaServer=%rpaServer%

ENDLOCAL