@echo off
echo.
SETLOCAL
rem This file is to be used with CP4BA 22.0.2 enterprise deployment with an external Git repository for the ADS project to remove the Client Onboarding scenario and associated labs

rem Set all variables according to your environment before executing this file

rem ----------------------------------------------------------------------------------------------------------
rem Specify below variables to launch the deployment automation with
rem ----------------------------------------------------------------------------------------------------------

rem Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginServer=https://api.ataxic.cp.fyre.ibm.com:6443
rem Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
SET ocLoginToken=sha256~9lWbR3EvU4nWVwppO4_izRJ3OetZU-QYSL4Xc5GAq74

rem Fully qualified user id of an admin user for the CP4BA instance
SET cp4baAdminUserName=cn=p8admin,ou=StaffTest,o=ibm,c=us
rem Password for the CP4BA admin user to use to access the CP4BA environment
SET cp4baAdminPassword=Psiadmin1

rem Uncomment in case GitHub is not accessible and all resources are already available locally
rem SET disableAccessToGitHub=-disableAccessToGitHub=true

rem Proxy settings in case a proxy server needs to be used to access the GitHub resources
rem Uncomment at least the proxScenatio, proxyHost, and proxyPort lines and set values accordingly in case a proxy server needs to be used to access GitHub
rem Uncomment the lines proxyUser and proxyPwd too, in case the proxy server requires authentication
rem SET proxScenatio=GitHub
rem SET proxyHost=cp31.fyre.ibm.com
rem SET proxyPort=3128
rem SET proxyUser=
rem SET proxyPwd=

rem Specific trace string for the boostrapping process (only uncomment if instructed to do so)
rem SET bootstrapDebugString="-bootstrapDebugString=*=finest"

rem ----------------------------------------------------------------------------------------------------------
rem Construct the proxy settings for curl and deployment automation tool if proxy is configured
rem ----------------------------------------------------------------------------------------------------------

if defined proxyHost (
	if defined proxyUser (
		SET TOOLPROXYSETTINGS=-proxyScenario=%proxScenatio% -proxyHost=%proxyHost% -proxyPort=%proxyPort% -proxyUser=%proxyUser% -proxyPwd=%proxyPwd%
		
		if "%proxScenatio%"=="GITHUB" (
			SET CURLPROXYSETTINGS=-x %proxyHost%:%proxyPort% -U %proxyUser%:%proxyPwd%
		)
	) else (
		SET TOOLPROXYSETTINGS=-proxyScenario=%proxScenatio% -proxyHost=%proxyHost% -proxyPort=%proxyPort%
		
		if "%proxScenatio%"=="GITHUB" (
			SET CURLPROXYSETTINGS=-x %proxyHost%:%proxyPort%
		)
	)
)

rem ----------------------------------------------------------------------------------------------------------
rem Global settings for the script (not to be modified by user)
rem ----------------------------------------------------------------------------------------------------------

rem Source URL where the deployment automation jar can be retrieved from
SET TOOLSOURCE=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/Deployment_Automation
rem Deployment pattern of the CP4BA instance
SET DEPLOYMENTPATTERN=Enterprise
rem Source URL to bootstrap configuration for the deployment tool
SET BOOTSTRAPURL=-bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/22.0.2/Deployment_Automation/%DEPLOYMENTPATTERN%
rem Name of the configuration file to use when running the deployment automation tool
SET CONFIGNAME=config-undeploy
rem Automation script to use when running the deployment automation tool
SET AUTOMATIONSCRIPT=RemoveClientOnboardingArtifacts.json

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

if defined toolValidationFailed set overallValidationFailed=true
if defined validationFailed set overallValidationFailed=true

if defined overallValidationFailed (
	echo:
	echo Existing...
	exit /b 1;
)

echo Starting deployment automation tool...
echo:

java -jar %TOOLFILENAME% %bootstrapDebugString% %BOOTSTRAPURL% -ocLoginServer=%ocLoginServer% -ocLoginToken=%ocLoginToken% %TOOLPROXYSETTINGS% -installBasePath=/%DEPLOYMENTPATTERN% -config=%CONFIGNAME% -automationScript=%AUTOMATIONSCRIPT% "cp4baAdminUserName=%cp4baAdminUserName%" -cp4baAdminPwd=%cp4baAdminPassword%

ENDLOCAL