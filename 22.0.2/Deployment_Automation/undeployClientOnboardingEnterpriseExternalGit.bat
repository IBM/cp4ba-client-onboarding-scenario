@echo off
echo.
SETLOCAL
rem This file is to be used with CP4BA 22.0.2 enterprise deployment with an external Git repository for the ADS project to remove the Client Onboarding scenario and associated labs

rem Set all variables according to your environment before executing this file

rem ----------------------------------------------------------------------------------------------------------
rem Specify below variables to launch the deployment automation with
rem ----------------------------------------------------------------------------------------------------------

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

rem Proxy settings in case a proxy server needs to be used to access the GitHub resources
rem SET proxySettings=-proxyScenario=GitHub -proxyHost= -proxyPort=

rem Specific trace string for the boostrapping process (only uncomment if instructed to do so)
rem SET bootstrapDebugString="-bootstrapDebugString=*=finest"

rem ----------------------------------------------------------------------------------------------------------
rem Validation that all variables parameters are set and the jar file for the deployment automation tool exists
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

if defined validationFailed exit /b 1;

java -jar %toolVersion%_DeploymentAutomation.jar %bootstrapDebugString% -bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/22.0.2/Deployment_Automation/Enterprise -ocLoginServer=%ocLoginServer% -ocLoginToken=%ocLoginToken% %proxySettings% -installBasePath=/Enterprise -config=config-undeploy -automationScript=RemoveClientOnboardingArtifacts.json cp4baAdminUserName=%cp4baAdminUserName% -cp4baAdminPwd=%cp4baAdminPassword%

ENDLOCAL