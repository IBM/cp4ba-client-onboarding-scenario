@echo off
echo.
SETLOCAL
rem This file is to be used with CP4BA 22.0.1 starter deployment to remove the Client Onboarding scenario and associated labs
rem Set all variables according to your environment before executing this file

rem ----------------------------------------------------------------------------------------------------------
rem Specify below variables to launch the deployment automation with
rem ----------------------------------------------------------------------------------------------------------


rem Date stamp of the tool.jar to be used
SET toolVersion=
rem Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginServer=
rem Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginToken=
rem Proxy settings in case a proxy server needs to be used to access the GitHub resources
rem Set proxySettings=-proxyScenario=GitHub -proxyHost=cp31.fyre.ibm.com -proxyPort=3128


rem ----------------------------------------------------------------------------------------------------------
rem Validation that all variables parameters are set and the jar file for the deployment automation tool exists
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

java -jar %toolVersion%_DeploymentAutomation.jar -bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/22.0.1/Deployment_Automation/Starter -ocLoginServer=%ocLoginServer% -ocLoginToken=%ocLoginToken% %proxySettings% -installBasePath=/Starter -config=config-undeploy -automationScript=RemoveClientOnboardingArtifactsEmbeddedGitea.json

ENDLOCAL