# Deploying the Client Onboarding scenario on an Enterprise Deployment with arbitrary LDAP and external GitHub (for CP4BA 25.0.1)

## Introduction

These instructions apply for those cases where you have an LDAP with arbitrary users and groups and want to use an external Git repository on github.com for your CP4BA 25.0.1 Enterprise deployment. It is the most flexible deployment profile but therefore also requires the highest amount of configuration parameters to be specified.

You need to have deployed at least the following capabilities in your CP4BA environment: Business Applications, Automation Decision Services, Workflow, Business Automation Insights.

> [!TIP]
>
> In case want to perform the Content labs, you need to create another CPE Object Store called `CONTENT`.
>
> In case want to perform the Automation Document Processing (ADP) lab, you also need to deploy the ADP capability.

## Prerequisites

**Machine to start deployment from**
A Windows, Linux, or Mac system with **Java 8** or later installed is required to start the deployment of the Client Onboarding artifacts. Ensure that the **bin** directory of your Java installation is part of the operation system path. If you receive an error like **'Java' is not recognized as an internal or external command** then this is not the case.

## Import Instructions

### Download Required bat/sh File

   1. **Create a new directory** on your machine from which you want to start the deployment (e.g. "co_depl")

   2. **Save the deployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)

      **Linux/Mac** - *CP4BA 25.0.1* - Enterprise deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/25.0.1/Deployment_Automation/deployClientOnboardingEnterpriseExternalGit.sh)** (*Ensure to make the sh file executable by performing `chmod +x deployClientOnboardingEnterpriseExternalGit.sh`*)

      **Windows** - *CP4BA 25.0.1* - Enterprise deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/25.0.1/Deployment_Automation/deployClientOnboardingEnterpriseExternalGit.bat)**

### Update bat/sh File
On Windows open the file **deployClientOnboardingEnterpriseExternalGit.bat**/on Linux or Mac open the file **deployClientOnboardingEnterpriseExternalGit.sh** in the text editor of your choice. 

1. Update the two variables `ocLoginServer` and `ocLoginToken` defined at the top of the file with your specific details

   1. **Login** to the OpenShift Web Console
   2. Click the **Copy login command** option in the drop down that appears when clicking on the user name in the top right corner <img src="..\images\openshift-copy-log-in-command.jpg" />
   3. Click on **Display Token** link shown on the next page 
   4. For `ocLoginServer` set the value displayed after `--server=`. For `--ocLoginToken` set the value displayed after `token=`

   <img src="..\images\openshift-log-in-token.jpg" />

2. Update the user and group related variables according to below table

   | Property           | Value          | Comment                                                      |
   | ------------------ | -------------- | ------------------------------------------------------------ |
   | cp4baAdminUserName | default: empty | Fully qualified user id (cn=<username>, dc=<org>, ... or uid=<username>, ...) of an admin user for the CP4BA instance |
   | cp4baAdminPassword | default: empty | Password for the CP4BA admin user to use to access the CP4BA environment |
   | cp4baAdminGroup    | default: empty | Fully qualified name of a group (cn=<groupname>, dc=<org>, ...) that contains the admin user/users for the CP4BA instance |
   | generalUsersGroup  | default: empty | Fully qualified name of a group (cn=<groupname>, dc=<org>, ...) that contains business users for the CP4BA instance |

3. Update the Git repository related values used for the Automation Decision Service part according to below table

   | Property         | Value          | Comment                                                      |
   | ---------------- | -------------- | ------------------------------------------------------------ |
   | adsGitOrg        | default: empty | Name of the Git organisation to create the ADS repository in. (Can not be a the personal user account!) |
   | adsGitUserName   | default: empty | User name of the user used to create the ADS repository with |
   | adsGitRepoAPIKey | default: empty | Git API key to connect to the Git server                     |

4. Update the variable `ocpStorageClassForInternalMailServer` with the name of a storage class in your OCP cluster that can be used for the email server and client that will be deployed by default

   > [!TIP]
   >
   > In case you want to use a gmail mail account instead, follow the instructions in the Advanced Configuration section below.

5. Place *one or two LDIF files* (need to have the ending .ldif) into the same directory that contain a user export from your LDAP to replicate the same users and password for the internal mail server as they exist in the CP4BA environment.

### Perform Import

*As part of the deployment, the deployment tool pulls additional resources from its GitHub repository. Ensure the machine you are executing the tool from has access both to GitHub (github.com/githubusercontent.com) and the location where your CP4BA instance is running.*

In a console window execute either **`deployClientOnboardingEnterpriseExternalGit.bat`** or **`./deployClientOnboardingEnterpriseExternalGit.sh`** to perform the import of the Client Onboarding scenario and lab artifacts.

In case you are using Java 9 or later, you will see a message `WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.` . This can be ignored safely.

While executing, the deployment tool prints an overview of the actions it performs and their results to the console. 

#### Successful completion of import

Once the deployment tool completes without a fatal error, it will output a status message that declares successful deployment of the Client Onboarding scenario. In addition it provides key links and user names/passwords for you to use. These links/values are specific to your environment.

```
Overall execution completed after 14 mins, 42 secs

Deploying the Client Onboarding scenario artifacts was successful.

Key resources to access are:

Client Onboarding Solution:
- Client Onboarding Desktop: https://<route-prefix>.<clustername>/icn/navigator/?desktop=ClientOnboarding
- Client Onboarding Document Upload: https://<route-prefix>.<clustername>/ae-workspace/public-app/Client%20Onboarding%20Document%20Upload(CODU)?ReferenceID=<Your Reference ID>
- IBM Business Performance Center (BPC): https://<route-prefix>.<clustername>/bai-bpc

Labs:
- IBM Cloudpak Dashboard (open Business Automation Studio from there): https://<route-prefix>.<clustername>
- IBM Content Services ACCE: https://<route-prefix>.<clustername>/cpe/acce/
- IBM Content Services Admin Desktop: https://<route-prefix>.<clustername>/icn/navigator/?desktop=admin
- IBM Content Services GraphQL: https://<route-prefix>.<clustername>/content-services-graphql/
- ICN (Content/ICN lab) Desktop: https://<route-prefix>.<clustername>m/icn/navigator/?desktop=ICN

Utilities:
- Process Admin Console: https://<route-prefix>.<clustername>/bas/ProcessAdmin/
- ICN BAWADMIN Desktop: https://<route-prefix>.<clustername>/icn/navigator/?desktop=bawadmin

User Credentials:
- Using user 'cp4admin'

Local Mail Server/Client:
- Mail Client URL: https://roundcubenginx-mail.<clustername>
- User Ids: '<username> or <username>@example.com'
- Passwords: 'same as Cloud Pak login'
- Only internal email addresses (<username>@example.org) can be used!

Remarks:
- WatsonX Orchestrate: CP4BA-side configuration performed, requires additional separate WatsonX Orchestrate SaaS instance

Successfully created ConfigMap 'client-onboarding-information' with same information as above

--- Execution completed ---
```

This information is also stored in a ConfigMap named `000-client-onboarding-information`. If you need to find the information again, you can always review it in this single location. Just log into the OpenShift Web Console of your environment, in the left-hand navigator expand `Workloads`, click on `ConfigMaps`, and enter `client` into the field next to `Name`.

The **remarks** section may contain more/other remarks depending on your configuration, e.g. in case you don't have a CPE object store called CONTENT a hint will be added, that the content labs have not been deployed.

### Troubleshooting the Client Onboarding Deployment

The deployment tool performs a lot of validation upfront and will report any issues it encounters. You can execute it multiple times without causing any issues. It will skip over those deployment steps that have already been successfully performed.

> [!TIP]
>
> - **Sometimes the deployment fails because of timing or network issues. These may not occur again when triggering the deployment a second time.** Other failures have been observed where the CP4BA environment or some of its PODs had issues and needed to be restarted.
>
> - In case you run into **issue during the deployment of the email server and email client**, ensure the storage class is set correctly and check the information about setting a docker user name and password in the Advanced Configuration section.

For the purpose of analyzing issues the deployment tool creates four files in the directory where it is located:

- deployClientOnboarding_25.0.1_Enterprise_output.txt - Contains the messages printed to the console
- deployClientOnboarding_25.0.1_Enterprise_detailedOutput.txt - Everything printed to the console plus details about the deployment steps
- deployClientOnboarding_25.0.1_Enterprise_trace.txt - Contains very detailed trace messages about everything that is done as part of running a deployment
- deployClientOnboarding_25.0.1_Enterprise_combined.txt - Contains a combination of the detailedOutput and trace files

In case your deployment fails and you get stuck, please reach out using the contact information that is given when the deployment fails and provide the `<date>_collector.zip` file created in this instance.

## Advanced Configuration

### Configuring an RPA environment 

(IBM Business Partners and IBMers only)
To experience or demo how the RPA bot is executed as part of running the Client Onboarding scenario you need to connect a specific RPA environment.

**Prerequisite**

Provision an instance of [**IBM Business Automation - Traditional and On-premise. V4 Updated 2023-02-14** ](https://techzone.ibm.com/collection/ibm-business-automation-traditional-and-on-premise/environments) (make sure to use **V4**). Wait until you receive an email from IBM TechZone with the title "Your environment is ready". 

Once the environment is ready select your reservation. At the bottom of the screen you find a large blue button below the header 'VM Remote Console'. It will bring up the Windows desktop as part of the browser window. **This is the recommended way to connect to the RPA VM for demoing the bot execution.** 

<img src="..\images\rpa-vm-browser-rdp.jpg" />

***Prior to testing/demoing:*** Start Firefox, the browser used by the bot, once and ensure that no update or similar is pending. This could interfere with executing the bot. Afterwards close the browser again.

**Configuration** 

You need to set the following two variables in the bat/sh-file you downloaded previously:

1. `rpaBotExecutionUser` - Set to the user for who the RPA bot should be executed for (would normally be `cp4admin`). Setting it to a non-existing user like cp4admin2 will always skip the actual bot invocation.

2. `rpaServer` - Set this to the URL of the RPA environment that you provisioned as described above. Use the URL listed as `RPA Asynch Server API` in the email that you received when your environment became ready. 

   <img src="..\images\rpa-reservation-async-url.jpg" />

If you have previously run the deployment, run it again. It will recognize that your RPA configuration has changed and will redeploy the artifact that contains the changed RPA information.

### Configuring an external email server (gmail)

By default the deployment will also deploy an internal email server and web-based email client. Emails being sent as part of the Client Onboarding scenario can only be send and received using the internal email addresses of the internal email server.

**Prerequisite**

In case emails should be send to public/external email addresses, you can optionally configure a gmail SMTP server. If you don't have a suitable gmail account, set up a new account first. For the credentials, create an **[App Password](https://support.google.com/accounts/answer/185833?hl=en)**. You will need both the email address and the app password for the deployment.

**Configuration** 

In the sh/bat file uncomment the two lines with the parameters`gmailAddress` and `gmailAppKey`. Set them to the values of your gmail account as described above.

Additionally, set the parameter `useInternalMailServer` to **false**.

If you have previously run the deployment, run it again. It will recognize that your gmail configuration has changed and will redeploy the artifact that contains the changed gmail information.

### Specifying the CP4BA namespace to deploy to when multiple CP4BA deployments exist

An OCP cluster can contain multiple CP4BA deployments with each deployment residing in its own namespace/project.

For the deployment tool to know which CP4BA deployment to use to deploy the Client Onboarding artifacts to, you need to specify the target namespace/project by uncommenting the parameter `cp4baNamespace` and setting the correct namespace/project.

In case only one CP4BA deployment exists the deployment tool will automatically choose that without the need to specify it explicitly. That is the reason why the parameter is commented out by default.

### Deploying only for the Client Onboarding scenario without labs

By default the deployment tool will deploy all artifacts required to perform the labs that are offered in addition to the artifacts for the Client Onboarding scenario itself.

In case you just want to practice or demo the Client Onboarding scenario but not perform the labs, you can disable the deployment of the lab artifacts by changing the parameter `configureLabs` from to true to **false**. This will reduce the deployment time by a couple of minutes.

### Deploying the AI-enhanced version of the Client Onboarding scenario (not yet supported)

The Client Onboarding scenario is also available with AI features that became available starting with CP4BA 25.0.0 and the IBM Content Assistant. To be able to deploy the AI-enhanced Client Onboarding scenario you need to have your BAW configured to support the gen AI activity and the Workflow Assistant (connection to watsonx.AI is required) and you need to have the access details for a SaaS instance of the IBM Content Assistant.

If these pre-conditions are met you can configure the following additional properties:

| Property                        | Value                                             | Comment                                                      |
| ------------------------------- | ------------------------------------------------- | ------------------------------------------------------------ |
| enableContentAssistant          | true/false (default: false)                       | Is the Content Assistant to be used                          |
| restrictContentAssistantToUser  | default: empty                                    | Named user for who the Content Assistant is to be used while it is not used in the Client Onboarding scenario for all other users (empty means it is used for any user) |
| icaDesktopName                  | default: ICN                                      | Name of the Navigator desktop to be used to launch the Daeja user. Desktop must be configured to have the Content Assistant plug-in configured. |
| icaGenAIRegion                  | default: empty                                    | Region where the IBM Content Assistant SaaS tenant is located |
| genAIAccessCode                 | default: empty                                    | Access code for the IBM Content Assistant SaaS instance      |
| genAIServiceURL                 | default: https://filenetai.test.saas.ibm.com/demo | URL for the IBM Content Assistant SaaS instance              |
| enableWFGenAI                   | true/false (default: false)                       | Should the genAI activity within Workflow be used as part of the scenario |
| enableWFAssistant               | true/false (default: false)                       | Should the Workflow Assistant be used as part of the scenario |
| createSampleCaseDataForNumUsers | default: 20                                       | Number of users for who the sample data that is required for Workflow Assistant is to be generated. (User names have to follow the pattern 'usrXXX') |
| maxCaseIteratorThreads          | default: 20                                       | Number of threads to use to create the sample data to speed up the data creation |
| graphQLURL                      | default: empty                                    | In case the automatic way to determine the GraphQL URL does not work the GraphQL URL can be explicitly specified. (Used in the context of the IBM Content Assistant) |
| icnBaseURL                      | default: empty                                    | In case the automatic way to determine the Navigator URL does not work the Navigator URL can be explicitly specified. (Used in the context of the IBM Content Assistant) |



### Specifying a Docker user name and password for deploying the email server and client

The images for deploying the components required for the email server and email client are retrieved from docker.io anonymously by default. Docker.io imposes a pull rate limit for anonymous pulls. It can happen that based on your IP and other factors the anonymous pull limit has been reached. This will prohibit the ability to deploy the email server and email client with their prerequisites.

To avoid this anonymous pull limit you can:

1. Create an account on Docker.io which includes your user name and a token or use an existing one
2. Uncomment the two parameters `dockerUserName` and `dockerToken` and set the respective value from step 1.

> [!WARNING]
>
> Based on these values a pull secret will be created in the namespace where the email server and email client will be deployed. This pull secret will be used for the OCP deployment of the email server and email client OCP deployments. Your Docker.io pull credentials will be visible to all users with access to to the OCP cluster.

### Using a proxy server to access github.com

In case you need to go through a proxy to access github.com perform these steps: 

1. Uncomment the three lines starting with `proxyScenario=GitHub`, `proxyHost=`, and `proxyPort=` 
2. Specify the host and port values for your proxy
3. In case your proxy requires authentication do the same for the lines `proxyUser=` and `proxyPwd=`

### Configuring Java Heap Size to Avoid Out-of-Memory

In case you experience an Out Of Memory (OOM) situation while deploying the Client Onboarding scenario perform these steps:

1. Uncomment the line containing `jvmSettings=`
2. Set an appropriate heap size

### Removing the Client Onboarding Artifacts from the Environment

In case you want to clean up your environment and remove the Client Onboarding artifacts you previously imported perform these steps:

1. **Save the undeployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)

   **Linux/Mac** - *CP4BA 25.0.1* - Enterprise deployment - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/25.0.1/Deployment_Automation/undeployClientOnboardingEnterpriseExternalGit.sh)** (*Ensure to make the sh file executable by performing `chmod +x undeployClientOnboardingRapidDeploymentEnterpriseWithGitea.sh`*)

   **Windows** - *CP4BA 25.0.1* - Enterprise deployment - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/25.0.1/Deployment_Automation/undeployClientOnboardingEnterpriseExternalGit.bat)**

2. On Windows open the file **undeployClientOnboardingEnterpriseExternalGit.bat**/on Linux or Mac open the file **undeployClientOnboardingEnterpriseExternalGit.sh** in the text editor of your choice. 

   1. Update two variables `ocLoginServer` and `ocLoginToken` defined at the top of the file with your specific details
   2. Update the variable `cp4baAdminPassword` with the password for the `cp4badmin` user

   Optionally:

   1. Specify what you want to undeploy/remove

      By default the undeployment removes all user data as created as part of the labs, the artifacts deployed for the labs, and the artifacts required by the Client Onboarding scenario itself.

      Refer to the detailed explanation preceding the three parameters `cleanupClientOnboardingLabs_UserData`, `cleanupClientOnboardingLabs`, and `cleanupClientOnboardingScenario` to determine if you want to make any modifications.

   2. In case you have multiple deployments of CP4BA in your OCP cluster, uncomment the parameter `cp4baNamespace` and specify the namespace/project of your CP4BA deployment

   3. Specify a proxy server if needed by applying the same steps as described in the section **Using a proxy server to access github.com**

   4. Disable access to GitHub as described in the section **Executing the deployment without access to github.com**

## Support

**Business Partners and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-ba-dl](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.