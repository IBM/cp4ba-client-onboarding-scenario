# Deploying the Client Onboarding scenario into an Enterprise Deployment created by Cloud Pak Deployer - Using a separate machine (for CP4BA 24.0.1) 

## Introduction

> [!IMPORTANT]
>
> These instructions only apply in case you have set up your CP4BA 24.0.1 Enterprise deployment using [**Cloud Pak Deployer**](https://ibm.github.io/cloud-pak-deployer/30-reference/configuration/cp4ba/).
>
> You need to have deployed at least the following capabilities in your CP4BA environment: Business Applications, Automation Decision Services, Workflow, Business Automation Insights.


Use these instruction to deploy the end-to-end [Client Onboarding solution](https://github.com/IBM/cp4ba-client-onboarding-scenario) and its accompanying [labs](https://github.com/IBM/cp4ba-labs/tree/main/24.0.1/README.md) to a self-provisioned **Cloud Pak for Business Automation (CP4BA) 24.0.1** environment deployed via Cloud Pak Deployer.

This deployment approach requires a separate machine with Java on it to run the deployment and the manual download and modification of a file to kick off the deployment. It offers the largest flexibility for customized deployments.

A simpler deployment approach without the need for a separate machine is described [here](CloudPakDeployerViaJob.md).



## Prerequisites

### 1. Cloud Pak for Business Automation (CP4BA) 24.0.1 Enterprise deployment environment deployed via Cloud Pak Deployer

**Cloud Pak for Business Automation (CP4BA) 24.0.1 Enterprise deployment environment deployed via Cloud Pak Deployer**

Either

- request a CP4BA 24.0.1 Enterprise environment deployed via Cloud Pak Deployer from TechZone following these [instructions](https://techzone.ibm.com/collection/apollo-business-automation/journey-cp4ba--tech-zone-deployer) 

  or

- bring your own CP4BA 24.0.1 Enterprise deployment authoring environment deployed via [Cloud Pak Deployer](https://ibm.github.io/cloud-pak-deployer/30-reference/configuration/cp4ba/) with at least the following capabilities: Business Applications, Automation Decision Services, Workflow, Business Automation Insights, Process Federation Server.


### 2. Machine to start the deployment from

A Windows, Linux, or Mac system with **Java 8** or later installed is required to start the deployment of the Client Onboarding artifacts. Ensure that the **bin** directory of your Java installation is part of the operation system path. If you receive an error like **'Java' is not recognized as an internal or external command** then this is not the case.



## Import Instructions

### Download Required bat/sh File

   1. **Create a new directory** on your machine from which you want to start the deployment (e.g. "co_depl")

   2. **Save the deployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)

      **Linux/Mac** 	*CP4BA 24.0.1* - Enterprise deployment via Cloud Pak Deployer - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/24.0.1/Deployment_Automation/deployClientOnboardingCloudPakDeployerEnterpriseWithGitea.sh)** (*Ensure to make the sh file executable by performing `chmod +x deployClientOnboardingCloudPakDeployerEnterpriseWithGitea.sh`*)

      **Windows** - *CP4BA 24.0.1* - Enterprise deployment via Cloud Pak Deployer - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/24.0.1/Deployment_Automation/deployClientOnboardingCloudPakDeployerEnterpriseWithGitea.bat)**

### Update bat/sh File
On Windows open the file **deployClientOnboardingCloudPakDeployerEnterpriseWithGitea.bat**/on Linux or Mac open the file **deployClientOnboardingCloudPakDeployerEnterpriseWithGitea.sh** in the text editor of your choice. 

Update the two variables `ocLoginServer` and `ocLoginToken` defined at the top of the bat/sh file with your specific details:

1. **Login** to the OpenShift Console

2. Click the **Copy login command** option in the drop down that appears when clicking on the user name in the top right corner 

   <img src="images\openshift-copy-log-in-command.jpg" />

3. Click on **Display Token** link shown on the next page 

4. For `ocLoginServer` set the value displayed after `--server=`. For `--ocLoginToken` set the value displayed after `token=`

   <img src="images\openshift-log-in-token.jpg" />

> [!TIP]
>
> In case you want to use the environment to **perform the Workflow labs with the business users** instead of the admin user, set `enableWorkflowLabsForBusinessUsers` to `true`. This will extend the deployment time to about 45 minutes.
>
> This is due to the fact that the security settings for elements in two Content Service object stores need to be updated and the CPE pods need to be restarted twice due to other changes.

### Perform Import
*As part of the deployment, the deployment tool pulls additional resources from its GitHub repository. Ensure the machine you are executing the tool from has access (e.g. is not blocked by a firewall or requires a proxy server) both to GitHub (github.com/githubusercontent.com) and the location where your CP4BA instance is running.*

In a console window execute either **`deployClientOnboardingCloudPakDeployerEnterpriseWithGitea.bat`** or **`./deployClientOnboardingCloudPakDeployerEnterpriseWithGitea.sh`** to perform the import of the Client Onboarding scenario and lab artifacts.

In case you are using Java 9 or later, you will see a message `WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.` . This can safely be ignored.

While executing the deployment tool prints an overview of the actions it performs and their results to the console. 

#### Successful completion of import

Once the deployment tool completes without a fatal error, it will output a status message that declares successful deployment of the Client Onboarding scenario. In addition it provides key links and user names/passwords for you to use. These links/values are specific to your environment.

```
Key resources to access are:
      
Client Onboarding Solution:
  - Client Onboarding Desktop: https://cpd-cp4ba.<clustername>/icn/navigator/?desktop=ClientOnboarding
  - Client Onboarding Document Upload: https://cpd-cp4ba.<clustername>/ae-workspace/public-app/Client%20Onboarding%20Document%20Upload(CODU)?ReferenceID=<Your Reference ID>
  - IBM Business Performance Center (BPC): https://cpd-cp4ba.<clustername>/bai-bpc
      
Labs:
  - IBM Cloudpak Dashboard (open Business Automation Studio from there): https://cpd-cp4ba.<clustername>
  - IBM Content Services ACCE: https://cpd-cp4ba.<clustername>/cpe/acce/
  - IBM Content Services Admin Desktop: https://cpd-cp4ba.<clustername>/icn/navigator/?desktop=admin
  - IBM Content Services GraphQL: https://cpd-cp4ba.<clustername>/content-services-graphql/
  - IBM Content Navigator (Content/ICN lab) Desktop: https://cpd-cp4ba.<clustername>/icn/navigator/?desktop=ICN
  - IBM Workplace (WatsonX Orchestrate lab): https://cpd-cp4ba.<clustername>/icn/navigator/?desktop=workplace
      
Utilities:
  - Process Admin Console: https://cpd-cp4ba.<clustername>/bas/ProcessAdmin/
  - IBM Content Navigator BAW Admin Desktop: https://cpd-cp4ba.<clustername>/icn/navigator/?desktop=bawadmin
      
Credentials:
  - Using admin user 'cpadmin' with password '<pwd>'
  - Additional Cloud Pak Deployer Users: User 'cpuser', Pwd '<pwd>'; User 'cpuser1', Pwd '<pwd>'; User 'cpuser2', Pwd '<pwd>'
      
Local Mail Server/Client:
  - Mail Client URL: https://roundcube-cp4ba-collateral.apps.<clustername>
  - User Ids: '<username>' or '<username>@cp.internal'
  - Passwords: 'same as Cloud Pak login'
  - Only internal email addresses (<username>@cp.internal) can be used!
      
Remarks:
  - Object store name for Content labs is 'Content'
  - WatsonX Orchestrate: CP4BA-side configuration performed, requires additional separate WatsonX Orchestrate SaaS instance
      
Successfully created ConfigMap '000-client-onboarding-information' with same information as above
```

This information is also stored in a ConfigMap named `000-client-onboarding-information`. If you need to find the information again, you can always review it in this single location. Just log into the OpenShift Web Console of your environment, in the left-hand navigator expand `Workloads`, click on `ConfigMaps`, and enter `client` into the field next to `Name`.



> [!NOTE]
>
> **If everything worked, you should now have a CP4BA 24.0.1 deployment with the Client Onboarding scenario deployed and are done!**



### Troubleshooting the Client Onboarding Deployment

The deployment tool performs a lot of validation upfront and will report any issues it encounters. You can execute it multiple times without causing any issues. It will skip over those deployment steps that have already been successfully performed.

**Sometimes the deployment fails because of timing or network issues. These may not occur again when triggering the deployment a second time.** Other failures have been observed where the CP4BA environment or some of its PODs had issues and needed to be restarted.

For the purpose of analyzing issues the deployment tool creates four files in the directory where it is located:
- deployClientOnboarding_24.0.1_Starter_output.txt - Contains the messages printed to the console
- deployClientOnboarding_24.0.1_Starter_detailedOutput.txt - Everything printed to the console plus details about the deployment steps
- deployClientOnboarding_24.0.1_Starter_trace.txt - Contains very detailed trace messages about everything that is done as part of running a deployment
- deployClientOnboarding_24.0.1_Starter_combined.txt - Contains a combination of the detailedOutput and trace files

In case your deployment fails and you get stuck, please reach out using the contact information that is given when the deployment fails and provide the `<date>_collector.zip` file created in this instance.



## Advanced Configuration

Refer to this [document](CloudPakDeployerSeparateMachine_Advanced.md) for advanced configuration scenarios like:

- Configuring an RPA environment
- Performing the Workflow labs using business users (instead of or in addition to the admin user)
- Adding users/setting regular user passwords during deployment
- Removing the Client Onboarding Artifacts from the environment



## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-ba-dl](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.