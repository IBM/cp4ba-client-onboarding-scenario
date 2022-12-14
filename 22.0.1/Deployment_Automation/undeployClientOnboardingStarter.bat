@echo off
echo.
rem This file is to be used with CP4BA 22.0.1 starter deployment to remove the Client Onboarding scenario and associated labs
rem Replace all placeholders that are represented with <text> labels before executing this file
java -jar <TIMESTAMP>_DeploymentAutomation.jar -bootstrapURL=https://api.github.com/repos/IBM/cp4ba-client-onboarding-scenario/contents/22.0.1/Deployment_Automation/Starter -ocpAdminURL=<ocpAdminURL> -ocpAdminToken=<ocpAdminToken> -installBasePath=/Starter -config=config-undeploy -automationScript=RemoveClientOnboardingArtifactsEmbeddedGitea.json