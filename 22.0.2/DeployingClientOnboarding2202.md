# Deploying the Client Onboarding scenario to a Jam-in-a-Box environment (for CP4BA 22.0.2)

## Introduction

Use these instruction to deploy the out-of-box end-to-end [Client Onboarding solution](https://github.com/IBM/cp4ba-client-onboarding-scenario) and its accompanying [labs](https://github.com/IBM/cp4ba-client-onboarding-scenario/blob/main/JamInABox.md#table-of-content) to a self-provisioned Jam-in-a-Box environment (based on Cloud Pak for Business Automation (CP4BA) 22.0.2). For more information about Jam-in-a-Box refer to the [Jam-in-a-Box overview](https://github.com/IBM/cp4ba-jam-in-a-box) page.


## Prerequisites

1. **Cloud Pak for Business Automation (CP4BA) 22.0.2 environment**

   **a) IBM Business Partners and IBMers**

   Reserve a [Jam-in-a-Box for Business Automation](https://techzone.ibm.com/collection/jam-in-a-box-for-business-automation) environment from IBM TechZone. For that select the **Cloud Pak for Business Automation 22.0.2 - IF002 VMWare Public (Powered by Pak Installer)** tile from the [Resources](https://techzone.ibm.com/collection/jam-in-a-box-for-business-automation/resources) tab. 

   Provide and select the required information. Ensure that you keep the default selection '**all**' in the 'techzone-reservation' dropdown.

   <img src="..\images\techzone-reservation.jpg" />

   Once you have reserved an environment in IBM TechZone, it is first **Scheduled** for provisioning. After a while it moves into status **Provisioning**, and after some time it finally becomes **Ready**. Overall this may take up to 6 hours. You will receive several emails during that period. 

   

   The final email has the subject '**Your environment is ready**'. The email contains a link to the **PakInstaller Portal** that you require.

   <img src="..\images\your-environment-is-ready.jpg"/>

   

   ***Getting access to the OpenShift Web Console (optional)***

   On the **OpenShift Console** tab of the PakInstaller Portal, you'll find the link to the **OpenShift Web Console** together with the **admin user** (always ocpadmin) and the **password** (unique to each provisioned environment).

   <img src="..\images\pakinstaller-portal.jpg" />

   You require the OpenShift Web Console to validate that the Cloud Pak is fully installed and to get the access information for the environment required to deploy the Client Onboarding artifacts.

   When logging into the OpenShift Web Console make sure to select **Daffy htpasswd Provider**.

   <img src="..\images\openshift-login-selection.jpg" />

   

   ***Environment Validation***

   After the final email, it may still take some time until the Cloud Pak is fully operational. **Periodically check until your environment is ready**. For this, perform the following steps:

   - Open the **OpenShift Web Console** (see above) in a browser
   - Click on **Workloads -> ConfigMaps** in the left-hand side navigator
   - Type '**access-info**' in the field next to 'Name'

   If the ConfigMap '**icp4adeploy-cp4ba-access-info**' is shown, your CP4BA cluster is fully deployed.

   

   **b) Everybody else**

   Create or use a CP4BA 22.0.2 starter deployment authoring environment with at least the following capabilities: Business Applications, Automation Decision Services, Workflow, Business Automation Insights, and optionally Automation Document Processing.

   

2. **Machine to start deployment from**
   A Windows, Linux, or Mac system with **Java 8** or later installed is required to start the deployment of the Client Onboarding artifacts. Ensure that the **bin** directory of your Java installation is part of the operation system path. If you receive an error like **'Java' is not recognized as an internal or external command** then this is not the case.

## Import Instructions

### Download Required bat/sh File

   1. **Create a new directory** on your machine from which you want to start the deployment (e.g. "co_depl")

   2. **Save the deployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)

      **Linux/Mac** 	*CP4BA 22.0.2* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/22.0.2/Deployment_Automation/deployClientOnboardingStarter.sh)** (*Ensure to make the sh file executable by performing `chmod +x deployClientOnboardingStarter.sh`*)

      **Windows** - *CP4BA 22.0.2* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/22.0.2/Deployment_Automation/deployClientOnboardingStarter.bat)**

### Update bat/sh File
On Windows open the file **deployClientOnboardingStarter.bat**/on Linux or Mac open the file **deployClientOnboardingStarter.sh** in the text editor of your choice. 

Update the variable `pakInstallerPortalURL` defined at the top of the file with the link from the '**Your environment is ready**' email provided for the **PakInstaller Portal URL**.

<img src="..\images\your-environment-is-ready.jpg"/>

### Perform Import
*As part of the deployment, the deployment tool pulls additional resources from its GitHub repository. Ensure the machine you are executing the tool from has access both to GitHub (github.com/githubusercontent.com) and the location where your CP4BA instance is running.*

In a console window execute either **`deployClientOnboardingStarter.bat`** or **`./deployClientOnboardingStarter.sh`** to perform the import of the Client Onboarding scenario and lab artifacts.

In case you are using Java 9 or later, you will see a message `WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.` . This can safely be ignored.

While executing the deployment tool prints an overview of the actions it performs and their results to the console. 

#### Error an initial import

After about 10-15 minutes the import should complete with the message 

```
Overall Summary - Result: 1 action failed but processing continued as requested and completed successfully
```

If you scroll to the top of your console output, you will see the error message below.

```
Failure publishing automation service of solution 'Client Onboarding', snapshot '1.0.0' 
```

Due to a defect in IBM Automation Decision Services (ADS), publishing the ADS automation service fails initially. This problem will be fixed in a later IF of CP4BA 22.0.2.

#### Performing the deployment a second time to fix the initial error

**You have to wait approximately 30 minutes and then perform the deployment a second time.** (If the publishing of the ADS automation service still fails, please wait a little longer and retry again. It should eventually publish successfully.)

#### Successful completion of import

Once the deployment tool completes without a fatal error, it will output a status message that declares successful deployment of the Client Onboarding scenario. In addition it provides key links and user names/passwords for you to use. These links/values are specific to your environment.

```
Overall execution completed after 14 mins, 42 secs

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


Successfully created ConfigMap 'client-onboarding-information' with same information as above

--- Execution completed ---
```

This information is also stored in a ConfigMap named `client-onboarding-information`. If you need to find the information again, you can always review it in this single location. Just log into the OpenShift Web Console of your environment, in the left-hand navigator expand `Workloads`, click on `ConfigMaps`, and enter `client` into the field next to `Name`.

### Troubleshooting the Client Onboarding Deployment

The deployment tool performs a lot of validation upfront and will report any issues it encounters. You can execute it multiple times without causing any issues. It will skip over those deployment steps that have already been successfully performed.

**Sometimes the deployment fails because of timing or network issues. These may not occur again when triggering the deployment a second time.** Other failures have been observed where the CP4BA environment or some of its PODs had issues and needed to be restarted.

For the purpose of analyzing issues the deployment tool creates four files in the directory where it is located:
- deployClientOnboarding_22.0.2_Starter_output.txt - Contains the messages printed to the console
- deployClientOnboarding_22.0.2_Starter_detailedOutput.txt - Everything printed to the console plus details about the deployment steps
- deployClientOnboarding_22.0.2_Starter_trace.txt - Contains very detailed trace messages about everthing that is done as part of running a deployment
- deployClientOnboarding_22.0.2_Starter_combined.txt - Contains a combination of the detailedOutput and trace files

In case your deployment fails and you get stuck, please reach out using the contact information that is given when the deployment fails and provide the `<date>_collector.zip` file created in this instance.

## Advanced Configuration

### Updating bat/sh File for non-Pak Installer Starter Deployment Environments

In case you have a starter deployment environment of CP4BA 22.0.2 that was not deployed using Pak Installer, update the two variables `ocLoginServer` and `ocLoginToken` defined at the top of the file with your specific details:

1. **Login** to the OpenShift Web Console

2. Click the **Copy login command** option in the drop down that appears when clicking on the user name in the top right corner 

   <img src="..\images\openshift-copy-log-in-command.jpg" />

3. Click on **Display Token** link shown on the next page 

4. For `ocLoginServer` set the value displayed after `--server=`. For `--ocLoginToken` set the value displayed after `token=`

   <img src="..\images\openshift-log-in-token.jpg" />

5. Start the deployment on the Client Onboarding artifacts

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

   <img src="..\images\rpa-reservation-sync-url.jpg" />

If you have previously run the deployment, run it again. It will recognize that your RPA configuration has changed and will redeploy the artifact that contains the changed RPA information.

### Configuring an external email server (gmail)

By default a Jam-in-a-Box environment is deployed with an internal email server and web-based email client. Emails being sent as part of the Client Onboarding scenario can only be send and received using the internal email addresses of the email server.

**Prerequisite**

In case emails should be send to public/external email addresses, you can optionally configure a gmail SMTP server. If you don't have a suitable gmail account, set up a new account first. For the credentials, create an **[App Password](https://support.google.com/accounts/answer/185833?hl=en)**. You will need both the email address and the app password for the deployment.

**Configuration** 

In the sh/bat file uncomment the two lines with the parameters`gmailAddress` and `gmailAppKey`. Set them to the values of your gmail account as described above.

If you have previously run the deployment, run it again. It will recognize that your RPA configuration has changed and will redeploy the artifact that contains the changed RPA information.

### Using a proxy server to access github.com

In case you need to go through a proxy to access github.com perform these steps: 

1. Uncomment the three lines starting with `proxyScenario=GitHub`, `proxyHost=`, and `proxyPort=` 
2. Specify the host and port values for your proxy
3. In case your proxy requires authentication do the same for the lines `proxyUser=` and `proxyPwd=`

### Executing the deployment without access to github.com

In case don't have access to github.com and want to perform the deployment in air-gap mode perform these steps: 

1. Clone the git repository or alternatively download the [Starter](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/22.0.2/Deployment_Automation/Starter) folder, [Solution Exports](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/22.0.2/Solution%20Exports) folder, and the [«date»_DeploymentAutomation.jar](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/Deployment_Automation/Current) file
2. Copy both folders and the jar file into the directory previously created in you put the bat/sh file
3. Uncomment the line `disableAccessToGitHub="-disableAccessToGitHub=true"` to disable access to github.com and only use local files

### Configuring Java Heap Size to Avoid Out-of-Memory

In case you experience an Out Of Memory (OOM) situation while deploying the Client Onboarding scenario perform these steps:

1. Uncomment the line containing `jvmSettings=`
2. Set an appropriate heap size

## Support

**Business Partners and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.