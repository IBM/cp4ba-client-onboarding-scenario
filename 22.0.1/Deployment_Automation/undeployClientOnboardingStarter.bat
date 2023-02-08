@echo off
echo.
SETLOCAL
rem This file is to be used with CP4BA 22.0.1 starter deployment to remove the Client Onboarding scenario and associated labs

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

rem Proxy settings in case a proxy server needs to be used to access the GitHub resources
rem Set proxySettings=-proxyScenario=GitHub -proxyHost= -proxyPort=


rem ----------------------------------------------------------------------------------------------------------
rem Validation that all variables parameters are set and the jar file for the deployment automation tool exists
rem ----------------------------------------------------------------------------------------------------------

if "%toolVersion%"=="REQUIRED" ( 
	echo Validating configuration failed:
	set validationFailed=true
	
	echo   Variable 'toolVersion' has not been set
)

if not defined validationFailed (
	if not exist %toolVersion%_DeploymentAutomation.jar (
		echo Validating configuration failed:
		set validationFailed=true
	)

	echo   File '%toolVersion%_DeploymentAutomation.jar' does not exist
)

if "%ocLoginServer%"=="REQUIRED" ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'ocLoginServer' has not been set
)

if "%ocLoginToken%"=="REQUIRED" ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'ocLoginToken' has not been set
)

if defined validationFailed exit /b 1;

java -jar %toolVersion%_DeploymentAutomation.jar -bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/22.0.1/Deployment_Automation/Starter -ocLoginServer=%ocLoginServer% -ocLoginToken=%ocLoginToken% %proxySettings% -installBasePath=/Starter -config=config-undeploy -automationScript=RemoveClientOnboardingArtifactsEmbeddedGitea.json

ENDLOCAL