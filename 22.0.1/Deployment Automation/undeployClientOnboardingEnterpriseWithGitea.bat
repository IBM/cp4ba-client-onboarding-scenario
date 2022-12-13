@echo off
echo.
rem this file is to be used with CP4BA 22.0.1 enterprise deployment with a co-deployed gitea to remove the Client Onboarding scenario and associated labs
java -jar <TIMESTAMP>_DeploymentAutomation.jar -ocpAdminURL=<ocpAdminURL> -ocpAdminToken=<ocpAdminToken> -installBasePath=/Enterprise -config=config-undeploy -automationScript=RemoveClientOnboardingArtifactsEmbeddedGitea.json -cp4baAdminPwd=<CP4BA admin user pwd> -giteaUserName=<gitea user if different from CP4BA admin user> -giteaUserPwd=<gitea pwd if different from CP4BA admin pwd>