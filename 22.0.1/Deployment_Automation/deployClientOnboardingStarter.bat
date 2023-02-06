@echo off
echo.
SETLOCAL
rem This file is to be used with CP4BA 22.0.1 starter deployment up to IF006 to deploy the Client Onboarding scenario and associated labs
rem Set all variables according to your environment before executing this file

rem ----------------------------------------------------------------------------------------------------------
rem Specify below variables to launch the deployment automation with
rem ----------------------------------------------------------------------------------------------------------

rem Uncomment in case JVM throws an "Out Of Memory"-exception during the execution
rem SET JVM_SETTINGS=-Xms4096M

rem Date stamp of the tool.jar to be used
SET toolVersion=
rem Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginServer=
rem Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginToken=

rem Email address of a gmail account to be used to send emails in the Client Onboarding scenario
SET gmailAddress=focuscorpdemo@gmail.com
rem App key for accessing the gmail account to send emails
SET gmailAppKey=mpjbdroynpjmbvdj



rem User for who the RPA bot is executed (specifying a non-existing user basically skipped the RPA bot execution)
SET rpaBotExecutionUser=cp4admin2
rem URL of the RPA server to be invoked for the RPA bot execution (currently not supported/tested, keep dummy value)
SET rpaServer=https://rpa-server.com:1111

rem Should ADP be used within the Client Oboarding scenario (do not change for now)
SET adpConfigured=false

rem Uncomment in case a proxy server needs to be used to access the GitHub resources
rem Set proxySettings=-proxyScenario=GitHub -proxyHost= -proxyPort=


rem ----------------------------------------------------------------------------------------------------------
rem Validation that all required variables are set and the jar file for the deployment automation tool exists
rem ----------------------------------------------------------------------------------------------------------

if "%toolVersion%"=="" ( 
	echo Variable 'toolVersion' has not been set
	exit /b 1;
)

if not exist %toolVersion%_DeploymentAutomation.jar (
	echo File '%toolVersion%_DeploymentAutomation.jar' does not been exist
	exit /b 1;
)

if "%ocLoginServer%"=="" ( 
	echo Variable 'ocLoginServer' has not been set
	exit /b 1;
)

if "%ocLoginToken%"=="" ( 
	echo Variable 'ocLoginToken' has not been set
	exit /b 1;
)

if "%gmailAddress%"=="" ( 
	echo Variable 'gmailAddress' has not been set
	exit /b 1;
)

if "%gmailAppKey%"=="" ( 
	echo Variable 'gmailAppKey' has not been set
	exit /b 1;
)

if "%rpaBotExecutionUser%"=="" ( 
	echo Variable 'rpaBotExecutionUser' has not been set
	exit /b 1;
)

if "%rpaServer%"=="" ( 
	echo Variable 'rpaServer' has not been set
	exit /b 1;
)

if "%adpConfigured%"=="" ( 
	echo Variable 'adpConfigured' has not been set
	exit /b 1;
)

java %JVM_SETTINGS% -jar %toolVersion%_DeploymentAutomation.jar -bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/22.0.1/Deployment_Automation/Starter -ocLoginServer=%ocLoginServer% -ocLoginToken=%ocLoginToken% %proxySettings% -installBasePath=/Starter -config=config-deploy -automationScript=DeployClientOnboardingEmbeddedGiteaADSWorkaround.json enableDeployClientOnboarding_ADP=%adpConfigured% ACTION_wf_cp_adpEnabled=%adpConfigured% ACTION_wf_cp_emailID=%gmailAddress% ACTION_wf_cp_emailPassword=%gmailAppKey% ACTION_wf_cp_rpaBotExecutionUser=%rpaBotExecutionUser% ACTION_wf_cp_rpaServer=%rpaServer%

ENDLOCAL