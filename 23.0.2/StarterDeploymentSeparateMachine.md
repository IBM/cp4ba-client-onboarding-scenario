# Deploying the Client Onboarding scenario into a Starter deployment environment - Using a separate machine (for CP4BA 23.0.2 IF002 and above) 

## Introduction

Use these instruction to deploy the out-of-the-box end-to-end [Client Onboarding solution](https://github.com/IBM/cp4ba-client-onboarding-scenario) and its accompanying [labs](https://github.com/IBM/cp4ba-labs/tree/main/23.0.2/README.md) to a self-provisioned environment (based on **Cloud Pak for Business Automation (CP4BA) 23.0.2**).

This deployment approach requires a separate machine with Java on it to run the deployment and the manual download and modification of a file to kick off the deployment. It offers the largest flexibility for customized deployments.

I simpler approach without the need for a separate machine is described [here](/StarterDeploymentViaJob.md).


## Prerequisites

### 1. Cloud Pak for Business Automation (CP4BA) 23.0.2 IF002 or newer Starter deployment environment

#### IBM TechZone provided environment

Reserve a Business Automation environment from IBM TechZone. For that select the **CP4BA 23.0.x - Multi-Pattern Starter TechZone Deployer powered CP4BA 2023.x** tile from the [Pre-Installed Software](https://techzone.ibm.com/collection/tech-zone-certified-base-images/journey-pre-installed-software) tab.

Provide and select the required information. The selection you make for 'Purpose' determines if you need to specify a 'Sales Opportunity number' and the 'reservation policy' (how long the environment is available and how often it can be extended).

<img src="..\images\techzone-reservation_2302_starter.jpg" style="zoom: 67%;" />

Once you have reserved an environment in IBM TechZone, it is first **Scheduled** for provisioning. After a while it moves into status **Provisioning**, and after about 2-3 hours it finally becomes **Ready**. You will receive an email when provisioning starts and a second email with the subject '**Reservation Ready on IBM Technology Zone**' when it completes. 

> [!WARNING]
>
> Ready in this case only means that OpenShift has been provisioned and that deploying Cloud Pak for Business Automation has been started but **not** that it is fully deployed yet. This may take another 4-5 hours to complete. 
> See below for how to check that CP4BA has been successfully deployed.

The final email contains a link '**View My Reservations**' to get to your reservations. Click on this link and click on the tile that represents your reservation.

<img src="..\images\your-environment-is-ready_2302_starter.jpg" style="zoom: 25%;" />

Towards the top of the screen you will find the **link to the OpenShift console**, the **Username** (which is always **kubeadmin**) to log into the OpenShift console, and the unique **Password** for the environment.

   <img src="..\images\techzone-reserved-env_2302_starter.jpg" style="zoom:25%;" />

#### Bring Your Own CP4BA environment

Alternatively, create or use a CP4BA 23.0.2 IF002 or newer Starter deployment authoring environment with at least the following capabilities: Business Applications, Automation Decision Services, Workflow, Business Automation Insights, Process Federation Server.

> [!IMPORTANT]
>
> IF002 or later is required due to bugs in earlier versions that prohibit the deployment and successful working of the scenario.

### 2. Machine to start the deployment from

A Windows, Linux, or Mac system with **Java 8** or later installed is required to start the deployment of the Client Onboarding artifacts. Ensure that the **bin** directory of your Java installation is part of the operation system path. If you receive an error like **'Java' is not recognized as an internal or external command** then this is not the case.

## Import Instructions

### Download Required bat/sh File

   1. **Create a new directory** on your machine from which you want to start the deployment (e.g. "co_depl")

   2. **Save the deployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)

      **Linux/Mac** 	*CP4BA 23.0.2* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.2/Deployment_Automation/deployClientOnboardingStarter.sh)** (*Ensure to make the sh file executable by performing `chmod +x deployClientOnboardingStarter.sh`*)

      **Windows** - *CP4BA 23.0.2* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.2/Deployment_Automation/deployClientOnboardingStarter.bat)**

### Update bat/sh File
On Windows open the file **deployClientOnboardingStarter.bat**/on Linux or Mac open the file **deployClientOnboardingStarter.sh** in the text editor of your choice. 

Update the two variables `ocLoginServer` and `ocLoginToken` defined at the top of the bat/sh file with your specific details, and the `ocpStorageClassForInternalMailServer` variable with a storage class of your cluster that supports RWO and RWX:

1. **Login** to the OpenShift Console

2. Click the **Copy login command** option in the drop down that appears when clicking on the user name in the top right corner 

   <img src="..\images\openshift-copy-log-in-command.jpg" />

3. Click on **Display Token** link shown on the next page 

4. For `ocLoginServer` set the value displayed after `--server=`. For `--ocLoginToken` set the value displayed after `token=`

   <img src="..\images\openshift-log-in-token.jpg" />

5. Go to **Storage -> StorageClasses**, select an appropriate storage class, and set the storage class name for `ocpStorageClassForInternalMailServer` (The default value normally works for TechZone OCP clusters.)

> [!TIP]
>
> In case you want to use the environment to **perform the Workflow labs with the business users** instead of the admin user, set `enableWorkflowLabsForBusinessUsers` to `true`. This will extend the deployment time to about 45 minutes.
>
> This is due to the fact that the security settings for elements in two Content Service object stores need to be updated and the CPE pods need to be restarted twice due to other changes.

### Perform Import
*As part of the deployment, the deployment tool pulls additional resources from its GitHub repository. Ensure the machine you are executing the tool from has access (e.g. is not blocked by a firewall or requires a proxy server) both to GitHub (github.com/githubusercontent.com) and the location where your CP4BA instance is running.*

In a console window execute either **`deployClientOnboardingStarter.bat`** or **`./deployClientOnboardingStarter.sh`** to perform the import of the Client Onboarding scenario and lab artifacts.

In case you are using Java 9 or later, you will see a message `WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.` . This can safely be ignored.

While executing the deployment tool prints an overview of the actions it performs and their results to the console. 

#### Successful completion of import

Once the deployment tool completes without a fatal error, it will output a status message that declares successful deployment of the Client Onboarding scenario. In addition it provides key links and user names/passwords for you to use. These links/values are specific to your environment.

```
Overall execution completed after 25 mins, 42 secs

Deploying the Client Onboarding scenario artifacts was successful.

Key resources to access are:

Client Onboarding Solution:
- Client Onboarding Desktop: https://cpd-cp4ba-starter.<clustername>/icn/navigator/?desktop=ClientOnboarding
- Client Onboarding Document Upload: https://cpd-cp4ba-starter.<clustername>/ae-workspace/public-app/Client%20Onboarding%20Document%20Upload(CODU)?ReferenceID=<Your Reference ID>
- IBM Business Performance Center (BPC): https://cpd-cp4ba-starter.<clustername>/bai-bpc

Labs:
- IBM Cloudpak Dashboard (open Business Automation Studio from there): https://cpd-cp4ba-starter.<clustername>
- IBM Content Services ACCE: https://cpd-cp4ba-starter.<clustername>/cpe/acce/
- IBM Content Services Admin Desktop: https://cpd-cp4ba-starter.<clustername>/icn/navigator/?desktop=admin
- IBM Content Services GraphQL: https://cpd-cp4ba-starter.<clustername>/content-services-graphql/
- ICN (Content/ICN lab) Desktop: https://cpd-cp4ba-starter.<clustername>m/icn/navigator/?desktop=ICN

Utilities:
- Process Admin Console: https://cpd-cp4ba-starter.<clustername>/bas/ProcessAdmin/
- ICN BAWADMIN Desktop: https://cpd-cp4ba-starter.<clustername>/icn/navigator/?desktop=bawadmin

User Credentials:
- Using user 'cp4admin' with password '<pwd>'
- Additional Users: User 'user1', Pwd '<pwd>'; User 'user2', Pwd '<pwd>'; User 'user3', Pwd '<pwd>'; User 'user4', Pwd <pwd>'; User 'user5', Pwd '<pwd>'

Local Mail Server/Client:
- Mail Client URL: https://roundcubenginx-mail.<clustername>
- User Ids: '<username> or <username>@example.org'
- Passwords: 'same as above'
- Only internal email addresses (<username>@example.org) can be used!

Remarks:
      - WatsonX Orchestrate: CP4BA-side configuration performed, requires additional separate WatsonX Orchestrate SaaS instance

Successfully created ConfigMap 'client-onboarding-information' with same information as above

--- Execution completed ---
```

This information is also stored in a ConfigMap named `client-onboarding-information`. If you need to find the information again, you can always review it in this single location. Just log into the OpenShift Web Console of your environment, in the left-hand navigator expand `Workloads`, click on `ConfigMaps`, and enter `client` into the field next to `Name`.

### Troubleshooting the Client Onboarding Deployment

The deployment tool performs a lot of validation upfront and will report any issues it encounters. You can execute it multiple times without causing any issues. It will skip over those deployment steps that have already been successfully performed.

**Sometimes the deployment fails because of timing or network issues. These may not occur again when triggering the deployment a second time.** Other failures have been observed where the CP4BA environment or some of its PODs had issues and needed to be restarted.

For the purpose of analyzing issues the deployment tool creates four files in the directory where it is located:
- deployClientOnboarding_23.0.2_Starter_output.txt - Contains the messages printed to the console
- deployClientOnboarding_23.0.2_Starter_detailedOutput.txt - Everything printed to the console plus details about the deployment steps
- deployClientOnboarding_23.0.2_Starter_trace.txt - Contains very detailed trace messages about everthing that is done as part of running a deployment
- deployClientOnboarding_23.0.2_Starter_combined.txt - Contains a combination of the detailedOutput and trace files

In case your deployment fails and you get stuck, please reach out using the contact information that is given when the deployment fails and provide the `<date>_collector.zip` file created in this instance.



## Advanced Configuration

### Performing the Workflow labs using business users (instead of or in addition to the admin user)

As part of editing the **deployClientOnboardingStarter.bat** or **deployClientOnboardingStarter.sh** file, ensure to set the `enableWorkflowLabsForBusinessUsers` variable to `true`.

This will extend the deployment time to about 45 minutes. This is due to the fact that the security settings for elements in two Content Service object stores need to be updated and the CPE pods need to be restarted twice due to other changes.

### Configuring an RPA environment 

(IBM Business Partners and IBMers only)
To experience or demo how the RPA bot is executed as part of running the Client Onboarding scenario you need to connect a specific RPA environment.

**Prerequisite**

Provision an instance of [**IBM Business Automation - Traditional and On-premise. V4.x** ](https://techzone.ibm.com/collection/ibm-business-automation-traditional-and-on-premise/environments) (make sure to use **V4.x**). Wait until you receive an email from IBM TechZone with the title "Reservation Ready on IBM Technology Zone". 

Once the environment is ready, select open your reservation on the IBM TechZone 'My Reservations' page. At the bottom of the screen you find a large blue button below the header 'VM Remote Console'. It will bring up the Windows desktop as part of the browser window. **This is the recommended way to connect to the RPA VM for demoing the bot execution.** 

<img src="..\images\rpa-vm-browser-rdp.jpg" />

***Prior to testing/demoing:*** Start Firefox, the browser used by the bot, once and ensure that no update or similar is pending. This could interfere with executing the bot. Afterwards close the browser again.

**Configuration** 

You need to set the following two variables in the bat/sh-file you downloaded and edited previously:

1. `rpaBotExecutionUser` - Set to the user for who the RPA bot should be executed for (would normally be `cp4admin`). Setting it to a non-existing user like cp4admin2 will always skip the actual bot invocation.

2. `rpaServer` - Set this to the URL of the RPA environment that you provisioned as described above. Use the URL listed as `RPA Asynch Server API` at the top of your reservation on IBM TechZone. 

   <img src="..\images\rpa-reservation-async-url.jpg" />

If you have previously run the deployment, run it again. It will recognize that your RPA configuration has changed and will redeploy the artifact that contains the changed RPA information.

### Configuring an external email server (gmail)

By default a Jam-in-a-Box environment is deployed with an internal email server and web-based email client. Emails being sent as part of the Client Onboarding scenario can only be send and received using the internal email addresses of the email server.

**Prerequisite**

In case emails should be send to public/external email addresses, you can optionally configure a gmail SMTP server. If you don't have a suitable gmail account, set up a new account first. For the credentials, create an **[App Password](https://support.google.com/accounts/answer/185833?hl=en)**. You will need both the email address and the app password for the deployment.

**Configuration** 

In the sh/bat file uncomment the two lines with the parameters`gmailAddress` and `gmailAppKey`. Set them to the values of your gmail account as described above.

If you have previously run the deployment, run it again. It will recognize that your email server configuration has changed and will redeploy the artifact that contains the changed email server information.

### Creating users during deployment / Setting admin and/or regular user passwords

In case you want to create one or multiple users to  have user names other than user1-user10 or cp4admin and/or you want to set your own password for the administrator and/or all users (user1-user10), follow these steps:

1. Download the file [AddUsersToPlatform.json](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.2/Deployment_Automation/Starter/AddUsersToPlatform.json) and place it in the same directory where you placed the bat/sh file
2. Edit the AddUsersToPlatform.json in your favorite text editor
   1. If you want to **add a single user**, modify the existing entry for user "Henry" to match your needs 
      - Ensure to update ALL properties like "dn", "cn", "sn", "uid", "mail"
      - Using the "members" array, you can add the new user to any of the pre-existing groups
      - Using the "roles" array, you can determine the Cloud Pak/Zen roles the user should get when onboarded to the Cloud Pak
   2. If you want to **add multiple users**, just duplicate the user definition and make your modifications (again making sure to update all properties)
   3. If you **don't want to add users** **but modify the password of the admin and/or regular users**, then either remove the whole "entities" array or set the attribute "enabled" to false
   4. If you want to **set the password for the admin user** "cp4admin" to a value of your choice, add element "adminPwd" with the password to be set on the same level as the "entities" attribute. (e.g. "adminPwd": "password")
   5. If you want to **set the password for all regular users** ("user1" to "user10") to a value of your choice, add element "userPwd" with the password to be set on the same level as the "entities" attribute. (e.g. "userPwd": "password"). Be aware that all of the users 1-10 will get the same password
3. In the sh/bat file modify the line "**createUsers**=" and set the value from false to true

### Using a proxy server to access github.com

In case you need to go through a proxy to access github.com perform these steps: 

1. Uncomment the three lines starting with `proxyScenario=GitHub`, `proxyHost=`, and `proxyPort=` 
2. Specify the host and port values for your proxy
3. In case your proxy requires authentication do the same for the lines `proxyUser=` and `proxyPwd=`

### Executing the deployment without access to github.com

In case don't have access to github.com and want to perform the deployment in air-gap mode perform these steps: 

1. Clone the git repository or alternatively download the [Starter](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/23.0.2/Deployment_Automation/Starter) folder, [Solution Exports](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/23.0.2/Solution%20Exports) folder, and the [«date»_DeploymentAutomation.jar](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/Deployment_Automation/Current) file
2. Copy both folders and the jar file into the directory previously created in you put the bat/sh file
3. Uncomment the line `disableAccessToGitHub="-disableAccessToGitHub=true"` to disable access to github.com and only use local files

### Configuring Java Heap Size to Avoid Out-of-Memory

In case you experience an Out Of Memory (OOM) situation while deploying the Client Onboarding scenario perform these steps:

1. Uncomment the line containing `jvmSettings=`
2. Set an appropriate heap size

### Removing the Client Onboarding Artifacts from the Environment

In case you want to clean up your environment and remove the Client Onboarding artifacts you previously imported perform these steps:

1. **Save the undeployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)

   **Linux/Mac** *CP4BA 23.0.2* - Starter deployment - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.2/Deployment_Automation/undeployClientOnboardingStarter.sh)** (*Ensure to make the sh file executable by performing `chmod +x deployClientOnboardingStarter.sh`*)

   **Windows** - *CP4BA 23.0.2* - Starter deployment - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.2/Deployment_Automation/undeployClientOnboardingStarter.bat)**

2. Update the two variables `ocLoginServer` and `ocLoginToken` defined at the top of the bat/sh file with your specific details.

## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.