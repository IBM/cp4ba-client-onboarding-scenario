@echo off
echo.
SETLOCAL
rem This file is to be used with CP4BA 22.0.1 enterprise deployment with a co-deployed gitea to deploy the Client Onboarding scenario and associated labs

rem Set all variables according to your environment before executing this file

rem ----------------------------------------------------------------------------------------------------------
rem Specify below variables to launch the deployment automation with
rem ----------------------------------------------------------------------------------------------------------

rem Uncomment in case JVM throws an "Out Of Memory"-exception during the execution
rem SET JVM_SETTINGS=-Xms4096M

rem Date stamp of the DeploymentAutomation.jar to be used, for example '20230206' when you are using '20230206_DeploymentAutomation.jar'
SET toolVersion=REQUIRED
rem Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginServer=REQUIRED
rem Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginToken=REQUIRED

rem Fully qualified user id of an admin user for the CP4BA instance
SET cp4baAdminUserName=REQUIRED
rem Password for the CP4BA admin user to use to access the CP4BA environment
SET cp4baAdminPassword=REQUIRED
rem Fully qualified name of a group that contains the admin user/users for the CP4BA instance
SET cp4baAdminGroup=REQUIRED
rem Fully qualified name of a group that contains normal users for the CP4BA instance
SET generalUsersGroup=REQUIRED

rem Name of the Git organisation to create the ADS repository in
SET adsGitOrg=REQUIRED
rem User name of the user used to create the ADS repository with
SET adsGitUserName=REQUIRED
rem Git API key to connect to the Git server
SET adsGitRepoAPIKey=REQUIRED

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

rem Uncomment in case a proxy server needs to be used to access the GitHub resources
rem SET proxySettings=-proxyScenario=GitHub -proxyHost= -proxyPort=

rem Specific trace string for the boostrapping process (only uncomment if instructed to do so)
rem SET bootstrapDebugString="-bootstrapDebugString=*=finest"

rem ----------------------------------------------------------------------------------------------------------
rem Validation that all required variables are set and the jar file for the deployment automation tool exists
rem ----------------------------------------------------------------------------------------------------------

if "%toolVersion%"=="REQUIRED" set toolVersionRequired=true
if "%toolVersion%"=="" set toolVersionRequired=true

if defined toolVersionRequired ( 
	echo Validating configuration failed:
	set validationFailed=true
	
	echo   Variable 'toolVersion' has not been set
)

if not defined validationFailed (
	if not exist %toolVersion%_DeploymentAutomation.jar (
		echo Validating configuration failed:
		set validationFailed=true
	
		echo   File '%toolVersion%_DeploymentAutomation.jar' does not exist
	)
)

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

if "%adsGitOrg%"=="REQUIRED" set adsGitOrgRequired=true
if "%adsGitOrg%"=="" set adsGitOrgRequired=true

if defined adsGitOrgRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	
	echo   Variable 'adsGitOrg' has not been set
)

if "%adsGitUserName%"=="REQUIRED" set adsGitUserNameRequired=true
if "%adsGitUserName%"=="" set adsGitUserNameRequired=true

if defined adsGitUserNameRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	
	echo   Variable 'adsGitUserName' has not been set
)

if "%adsGitRepoAPIKey%"=="REQUIRED" set adsGitRepoAPIKeyRequired=true
if "%adsGitRepoAPIKey%"=="" set adsGitRepoAPIKeyRequired=true

if defined adsGitRepoAPIKeyRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	
	echo   Variable 'adsGitRepoAPIKey' has not been set
)

if "%gmailAddress%"=="REQUIRED" set gmailAddressRequired=true
if "%gmailAddress%"=="" set gmailAddressRequired=true

if defined gmailAddressRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'gmailAddress' has not been set
)

if "%gmailAppKey%"=="REQUIRED" set gmailAppKeyRequired=true
if "%gmailAppKey%"=="" set gmailAppKeyRequired=true

if defined gmailAppKeyRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'gmailAppKey' has not been set
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

if defined validationFailed exit /b 1;


java %JVM_SETTINGS% -jar %toolVersion%_DeploymentAutomation.jar %bootstrapDebugString% -bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/22.0.2/Deployment_Automation/Enterprise -ocLoginServer=%ocLoginServer% -ocLoginToken=%ocLoginToken% %proxySettings% -installBasePath=/Enterprise -config=config-deploy -automationScript=DeployClientOnboarding.json cp4baAdminUserName=%cp4baAdminUserName% -cp4baAdminPwd=%cp4baAdminPassword%  cp4baAdminGroup=%cp4baAdminGroup% generalUsersGroupName=%generalUsersGroup% ACTION_adsGitOrg=%adsGitOrg% ACTION_adsGitUserName=%adsGitUserName% ACTION_adsGitRepoAPIKey=%adsGitRepoAPIKey% enableDeployClientOnboarding_ADP=%adpConfigured% ACTION_wf_cp_adpEnabled=%adpConfigured% ACTION_wf_cp_emailID=%gmailAddress% ACTION_wf_cp_emailPassword=%gmailAppKey% ACTION_wf_cp_rpaBotExecutionUser=%rpaBotExecutionUser% ACTION_wf_cp_rpaServer=%rpaServer%

ENDLOCAL