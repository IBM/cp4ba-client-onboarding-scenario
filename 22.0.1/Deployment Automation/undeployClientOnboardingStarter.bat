@echo off
echo.
rem this file is to be used with CP4BA 22.0.1 starter deployment to remove the Client Onboarding scenario and associated labs
java -jar <TIMESTAMP>_DeploymentAutomation.jar -ocpAdminURL=<ocpAdminURL> -ocpAdminToken=<ocpAdminToken> -installBasePath=/Starter -config=config-undeploy -automationScript=RemoveClientOnboardingArtifactsEmbeddedGitea.json