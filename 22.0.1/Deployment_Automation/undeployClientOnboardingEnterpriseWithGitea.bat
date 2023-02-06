@echo off
echo.
SETLOCAL
rem This file is to be used with CP4BA 22.0.1 enterprise deployment with a co-deployed gitea to remove the Client Onboarding scenario and associated labs
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
rem Set proxySettings=-proxyScenario=GitHub -proxyHost= -proxyPort=

rem Password for the CP4BA admin user to use to access the CP4BA environment
SET cp4baAdminPassword=
rem Uncomment when the admin credentials for the embedded Gitea differ from the credentials of the CP4BA admini
rem SET giteaCredentials=-giteaUserName= -giteaUserPwd=


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

if "%cp4baAdminPassword%"=="" ( 
	echo Variable 'cp4baAdminPassword' has not been set
	exit /b 1;
)

java -jar %toolVersion%_DeploymentAutomation.jar -bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/22.0.1/Deployment_Automation/Enterprise -ocLoginServer=%ocLoginServer% -ocLoginToken=%ocLoginToken% %proxySettings% -installBasePath=/Enterprise -config=config-undeploy -automationScript=RemoveClientOnboardingArtifactsEmbeddedGitea.json -cp4baAdminPwd=%cp4baAdminPassword% %giteaCredentials%

ENDLOCAL