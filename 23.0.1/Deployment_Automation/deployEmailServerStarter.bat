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
rem This file is to be used with CP4BA 23.0.1 starter deployment to deploy the an email server/client

rem Set all variables according to your environment before executing this file

rem ----------------------------------------------------------------------------------------------------------
rem Specify below variables to launch the deployment automation with
rem ----------------------------------------------------------------------------------------------------------

rem Either 'pakInstallerPortalURL' or 'ocLoginServer' and 'ocLoginToken' need to be specified but not both depending on how environment is installed

rem URL of the PAK INSTALLER PORTAL directly from the 'Your environment is ready' email 'PakInstaller Portal URL:' when deployed from TechZone via Pak Installer
SET pakInstallerPortalURL=REQUIRED

rem Value of the 'server' parameter as shown on the 'Copy login command' page in the OCP web console
rem SET ocLoginServer=REQUIRED
rem Value shown under 'Your API token is' or as 'token' parameter as shown on the 'Copy login command' page in the OCP web console
rem SET ocLoginToken=REQUIRED

rem Should one or multiple users be added to the Cloud Pak as part of deploying the solution (The actual users need to be specified in a file called 'AddUsersToPlatform.json' in the directory of this file.)
SET createUsers=false


rem Uncomment following two lines in case you want to use your Docker.io account instead of pulling images for the mail server anonymously (mostly relvant when anonymous pull limit has been reached)
rem SET dockerUserName=REQUIRED
rem SET dockerToken=REQUIRED

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
SET TOOLSOURCE=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/Deployment_Automation/Current
rem CP4BA version
SET CP4BAVERSION=23.0.1
rem Deployment pattern of the CP4BA instance
SET DEPLOYMENTPATTERN=Starter
rem Source URL to bootstrap configuration for the deployment tool
SET BOOTSTRAPURL=-bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/%CP4BAVERSION%/Deployment_Automation/%DEPLOYMENTPATTERN%
rem Name of the configuration file to use when running the deployment automation tool
SET CONFIGNAME=config-deployEmail
rem Automation script to use when running the deployment automation tool
SET AUTOMATIONSCRIPT=DeployEmailCapability.json

rem Name of the source batch file passed to execution environment
SET SCRIPTNAME=deployEmailServerStarter.bat
rem Name of the actual batch file passed to execution environment
SET FILENAME=%~nx0
rem Version of this script file passed to execution environment
SET SCRIPTVERSION=1.0.1
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

rem if pakInstallerPortalURL is defined and default or value not specified check that both ocLoginServer and ocLoginToken are defined properly
if defined pakInstallerPortalURL (
	rem if pakInstallerPortalURL has default value then need to ensure oc variables are properly defined
	if "%pakInstallerPortalURL%"=="REQUIRED" (
		rem if ocLoginServer variable is defined, ensure it is not at default value or empty, otherwise including not defined set marker that it is missing
		if defined ocLoginServer (
			if "%ocLoginServer%"=="REQUIRED" (
				set ocLoginServerRequired=true
			) else (
				if "%ocLoginServer%"=="" (
					set ocLoginServerRequired=true
				) else (
					set INTERNALOCLOGINSERVER=-ocLoginServer=%ocLoginServer%
				)
			)
		) else (
			set ocLoginServerRequired=true
		)
	
		rem if ocLoginToken variable is defined, ensure it is not at default value or empty, otherwise including not defined set marker that it is missing
		if defined ocLoginToken (
			if "%ocLoginToken%"=="REQUIRED" (
				set ocLoginTokenRequired=true
			) else (
				if "%ocLoginToken%"=="" (
					set ocLoginTokenRequired=true
				) else (
					set INTERNALOCLOGINTOKEN=-ocLoginToken=%ocLoginToken%
				)
			)
		) else (
			set ocLoginTokenRequired=true
		)
	rem pakInstallerPortalURL is set a to a value ensure that 'ocLoginServer' and 'ocLoginToken' are either not defined (commented out) or remain at the default value
	) else (
		if defined ocLoginServer (
			if NOT "%ocLoginServer%"=="REQUIRED" (
				set multipleLoginMethod=true
			)
		)

		if defined ocLoginToken (
			if NOT "%ocLoginToken%"=="REQUIRED" (
				set multipleLoginMethod=true
			)
		)
		
		set INTERNALPAKINSTALLERPORTALURL=-pakInstallerPortalURL=%pakInstallerPortalURL%
	)
rem pakInstallerPortalURL is not defined (commented out) ensure that 'ocLoginServer' and 'ocLoginToken' are properly defined
) else (
	rem if 'ocLoginServer' variable is defined, ensure it is not at default value or empty, otherwise including not defined set marker that it is missing
	if defined ocLoginServer (
		if "%ocLoginServer%"=="REQUIRED" (
			set ocLoginServerRequired=true
		) else (
			if "%ocLoginServer%"=="" (
				set ocLoginServerRequired=true
			) else (
				set INTERNALOCLOGINSERVER=-ocLoginServer=%ocLoginServer%
			)
		)
	) else (
		set ocLoginServerRequired=true
	)
	
	rem if 'ocLoginToken' variable is defined, ensure it is not at default value or empty, otherwise including not defined set marker that it is missing
	if defined ocLoginToken (
		if "%ocLoginToken%"=="REQUIRED" (
			set ocLoginTokenRequired=true
		) else (
			if "%ocLoginToken%"=="" (
				set ocLoginTokenRequired=true
			) else (
				set INTERNALOCLOGINTOKEN=-ocLoginToken=%ocLoginToken%
			)
		)
	) else (
		set ocLoginTokenRequired=true
	)
)

if defined multipleLoginMethod ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Either 'ocLoginServer' and 'ocLoginToken' or 'pakInstallerPortalURL' can be specified but NOT both
)

if defined ocLoginServerRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'ocLoginServer' has not been defined/set ^(nor is variable 'pakInstallerPortalURL' defined/set^)
)

if defined ocLoginTokenRequired ( 
	if not defined validationFailed (
		echo Validating configuration failed:
		set validationFailed=true
	)
	echo   Variable 'ocLoginToken' has not been defined/set ^(nor is variable 'pakInstallerPortalURL' defined/set^)
)

if defined createUsers (
	if "%createUsers%"=="true" (
		set createUsersFile=onboardUsersFile=AddUsersToPlatform.json
		
		rem Determine if the json file exist
		for /f "tokens=*" %%i in ('dir /b * ^| findstr /l "AddUsersToPlatform.json"') do set USERFILENAME=%%i
		
		rem In case not available/found print error and mark as validation failed
		if not defined USERFILENAME (
			set validationFailed=true
			echo   Configured to add users to Cloud Pak environment but file 'AddUsersToPlatform.json' does not exist in current directory
		)
	)
)

if defined dockerUserName (
	if "%dockerUserName%"=="REQUIRED" (
		if not defined validationFailed (
			set validationFailed=true
			echo Validating configuration failed:			
		)
		echo   Variable 'dockerUserName' is defined but is not set correctly
		
		if defined dockerToken (
			if "%dockerToken%"=="REQUIRED" (
				echo   Variable 'dockerToken' is defined but has not been set correctly
			)
		) else (
			echo   Variable 'dockerToken' is not defined but must be defined as variable 'dockerUserName' is defined
		)
	) else (
		if defined dockerToken (
			if "%dockerToken%"=="REQUIRED" (
				if not defined validationFailed (
					echo Validating configuration failed:
					set validationFailed=true
				)
				echo   Variable 'dockerUserName' is defined but is not set correctly
			) else (
				set INTERNALDOCKERINFO=dockerUserName=%dockerUserName% dockerToken=%dockerToken%
			)
		) else (
			if not defined validationFailed (
				echo Validating configuration failed:
				set validationFailed=true
			)
			echo   Variable 'dockerToken' is not defined but must be defined as variable 'dockerUserName' is defined
		)
	)
) else (
	if defined dockerToken (
		if not defined validationFailed (
			set validationFailed=true
			echo Validating configuration failed:			
		)
		echo   Variable 'dockerUserName' is not defined but must be defined as variable 'dockerToken' is defined
		
		if "%dockerToken%"=="REQUIRED" (
			echo   Variable 'dockerUserName' is defined but is not set correctly
		) 
	)
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

java %jvmSettings% -jar %TOOLFILENAME% %bootstrapDebugString% %BOOTSTRAPURL% "-scriptDownloadPath=%SCRIPTDOWNLOADPATH%" "-scriptName=%FILENAME%" "-scriptSource=%SCRIPTNAME%" "-scriptVersion=%SCRIPTVERSION%" %INTERNALOCLOGINSERVER% %INTERNALOCLOGINTOKEN% %INTERNALPAKINSTALLERPORTALURL% %TOOLPROXYSETTINGS% -installBasePath=/%DEPLOYMENTPATTERN% -config=%CONFIGNAME% -automationScript=%AUTOMATIONSCRIPT% %createUsersFile% %INTERNALDOCKERINFO%

ENDLOCAL