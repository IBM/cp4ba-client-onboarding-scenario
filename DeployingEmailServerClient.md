# Deploying an Email Server and Web-Based Client to a Jam-in-a-Box/Starter environment

## Introduction

Use these instruction to deploy an email server and web-based client to a Jam-in-A-Box/Starter deployment for Cloud Pak for Business Automation (CP4BA) 22.0.2 and 23.0.1.

The email server can only send a receive emails internally and not communicate with external email servers. It is mostly useful to connect it to other components within CP4BA, e.g. for notification emails. With the combination of server and web-based client it is self-contained.


## Prerequisites

1. **Cloud Pak for Business Automation (CP4BA) 22.0.2 or 23.0.1 environment**

   **a) IBM Business Partners and IBMers**

   Reserve a [Jam-in-a-Box for Business Automation](https://techzone.ibm.com/collection/jam-in-a-box-for-business-automation) environment from IBM TechZone. For that select the **Cloud Pak for Business Automation 22.0.2 IF005 - VMWare Public (OCP 4.12) (Powered by Pak Installer)** or **Cloud Pak for Business Automation 23.0.1 IF001 - VMWare Public (OCP 4.12) (Powered by Pak Installer)** tile from the [Resources](https://techzone.ibm.com/collection/jam-in-a-box-for-business-automation/resources) tab.

   Provide and select the required information. The selection you make for 'Purpose' determines if you need to specify a 'Sales Opportunity number' and the 'reservation policy' (how long the environment is available and how often it can be extended).

   *Deploying the email server and client does not require any specific capability to be elected in the 'Starter Service' dropdown.*

   Once you have reserved an environment in IBM TechZone, it is first **Scheduled** for provisioning. After a while it moves into status **Provisioning**, and after some time it finally becomes **Ready**. Overall this may take up to 6 hours. You will receive several emails during that period. 

   The final email has the subject '**Reservation Ready on IBM Technology Zone**'. It contains a link '**View My Reservations**' to get to your reservations. Click on this link and click on the tile that represents your reservation.

   <img src="images\your-environment-is-ready_2301.jpg"/>

   At the bottom of the screen for your environment, you'll find the **PakInstaller Portal URL** that you require.

   <img src="images\techzone-reserved-env_2301.jpg"/>

   ***Getting access to the OpenShift Web Console (optional)***

   Open the PakInstaller Portal using the link shown on the reservation details page in IBM TechZone. On the **OpenShift Console** tab of the PakInstaller Portal, you'll find the link to the **OpenShift Web Console** together with the **admin user** (always ocpadmin) and the **password** (unique to each provisioned environment).

   <img src="images\pakinstaller-portal_2301.jpg" />

   You can use the OpenShift Web Console to validate that the Cloud Pak is fully installed.

   When logging into the OpenShift Web Console make sure to select **Daffy htpasswd Provider**.

   <img src="images\openshift-login-selection.jpg" />

   

   ***Environment Validation***

   After the final email, it may still take some time until the Cloud Pak is fully operational. **Periodically check until your environment is ready**. For this, perform the following steps:

   - Open the **OpenShift Web Console** (see above) in a browser
- Click on **Workloads -> ConfigMaps** in the left-hand side navigator
   - Type '**access-info**' in the field next to 'Name'
   
   If the ConfigMap '**icp4adeploy-cp4ba-access-info**' is shown, your CP4BA cluster is fully deployed.

   

   **b) Everybody else**

   Create or use a CP4BA 22.0.2 or 23.0.1 Starter deployment authoring environment with whatever capabilities you require.

   

2. **Machine to start deployment from**
   A Windows, Linux, or Mac system with **Java 8** or later installed is required to start the deployment of the Client Onboarding artifacts. Ensure that the **bin** directory of your Java installation is part of the operation system path. If you receive an error like **'Java' is not recognized as an internal or external command** then this is not the case.

## Import Instructions

### Download Required bat/sh File

   1. **Create a new directory** on your machine from which you want to start the deployment (e.g. "email_depl")

   2. **Save the deployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)

      **Linux/Mac** 	

      *CP4BA 22.0.2* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/22.0.2/Deployment_Automation/deployEmailServerStarter.sh)**  or *CP4BA 23.0.1* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.1/Deployment_Automation/deployEmailServerStarter.sh)** (*Ensure to make the sh file executable by performing `chmod +x deployClientOnboardingStarter.sh`*)
      
      **Windows**
      
      *CP4BA 22.0.2* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/22.0.2/Deployment_Automation/deployEmailServerStarter.bat)** or *CP4BA 23.0.1* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.1/Deployment_Automation/deployEmailServerStarter.bat)**

### Update bat/sh File
On Windows open the file **deployEmailServerStarter.bat**/on Linux or Mac open the file **deployEmailServerStarter.sh** in the text editor of your choice. 

Update the variable `pakInstallerPortalURL` defined at the top of the file with the link from your TechZone reservation details (**PakInstaller Portal URL** at the bottom of the page).

<img src="images\techzone-reserved-env_2301.jpg"/>

### Perform Deployment
*As part of the deployment, the deployment tool pulls additional resources from its GitHub repository. Ensure the machine you are executing the tool from has access (e.g. is not blocked by a firewall or requires a proxy server) both to GitHub (github.com/githubusercontent.com) and the location where your CP4BA instance is running.*

In a console window execute either **`deployEmailServerStarter.bat`** or **`./deployEmailServerStarter.sh`** to perform the deployment of the email server and client.

In case you are using Java 9 or later, you will see a message `WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.` . This can safely be ignored.

While executing the deployment tool prints an overview of the actions it performs and their results to the console. 

#### Successful completion of import

Once the deployment tool completes without a fatal error, it will output a status message that declares successful deployment of the Client Onboarding scenario. In addition it provides key links and user names/passwords for you to use. These links/values are specific to your environment.

```
Overall execution completed after 4 mins, 20 secs

Deploying the email server and client was successful.

Key resources to access are:

OpenShift Web Console:
- URL:  https://console-openshift-console.apps.<clustername>.cloud.techzone.ibm.com
- User: 'ocpadmin'
- Pwd:  '<pwd>'

User Credentials:
- Using user 'cp4admin' with password '<pwd>'
- Additional Users: User 'user1', Pwd '<pwd>'; User 'user2', Pwd '<pwd>'; User 'user3', Pwd '<pwd>'; User 'user4', Pwd '<pwd>'; User 'user5', Pwd '<pwd>'

Local Mail Server/Client:
- Mail Client URL: https://roundcubenginx-mail.apps.<clustername>.cloud.techzone.ibm.com
- User Ids: '<username>' or '<username>@example.org'
- Passwords: 'same as above'
- Only these internal email addresses (<username>@example.org) are allowed to be specified in the Client Onboarding app!


Successfully created ConfigMap 'email-information' with same information as above

--- Execution completed ---
```

This information is also stored in a ConfigMap named `email-information`. If you need to find the information again, you can always review it in this single location. Just log into the OpenShift Web Console of your environment, in the left-hand navigator expand `Workloads`, click on `ConfigMaps`, and enter `email` into the field next to `Name`.

### Troubleshooting the Mail Server/Client Deployment

The deployment tool performs a lot of validation upfront and will report any issues it encounters. You can execute it multiple times without causing any issues. It will skip over those deployment steps that have already been successfully performed.

**Sometimes the deployment fails because of timing or network issues. These may not occur again when triggering the deployment a second time.** Other failures have been observed where the CP4BA environment or some of its PODs had issues and needed to be restarted.

For the purpose of analyzing issues the deployment tool creates four files in the directory where it is located:
- deployEmail_22.0.2|23.0.1_Starter_output.txt - Contains the messages printed to the console
- deployEmail_22.0.2|23.0.1_Starter_detailedOutput.txt - Everything printed to the console plus details about the deployment steps
- deployEmail_22.0.2|23.0.1_Starter_trace.txt - Contains very detailed trace messages about everthing that is done as part of running a deployment
- deployEmail_22.0.2|23.0.1_Starter_combined.txt - Contains a combination of the detailedOutput and trace files

In case your deployment fails and you get stuck, please reach out using the contact information that is given when the deployment fails and provide the `<date>_collector.zip` file created in this instance.

## Advanced Configuration

### Updating bat/sh File for non-PakInstaller Starter Deployment Environments

In case you have a starter deployment environment of CP4BA 23.0.1 that was not deployed using PakInstaller, update the two variables `ocLoginServer` and `ocLoginToken` defined at the top of the bat/sh file with your specific details:

1. **Login** to the OpenShift Web Console

2. Click the **Copy login command** option in the drop down that appears when clicking on the user name in the top right corner 

   <img src="images\openshift-copy-log-in-command.jpg" />

3. Click on **Display Token** link shown on the next page 

4. For `ocLoginServer` set the value displayed after `--server=`. For `--ocLoginToken` set the value displayed after `token=`

   <img src="images\openshift-log-in-token.jpg" />

5. Start the deployment of the Client Onboarding artifacts

### Creating users during deployment / Setting admin and/or regular user passwords

In case you want to create one or multiple users to  have user names other than user1-user10 or cp4admin and/or you want to set your own password for the administrator and/or all users (user1-user10), follow these steps:

1. Download the file [AddUsersToPlatform.json (22.0.2)](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/22.0.2/Deployment_Automation/Starter/AddUsersToPlatform.json) or [AddUsersToPlatform.json (23.0.1)](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.1/Deployment_Automation/Starter/AddUsersToPlatform.json) and place it in the same directory where you placed the bat/sh file
2. Edit the AddUsersToPlatform.json in your favorite text editor
   1. If you want to **add a single user**, modify the existing entry for user "Henry" to match your needs (using the "members" array, you can add the new user to any of the pre-existing groups/using the "roles" array, you can determine the Cloud Pak/Zen roles the user should get when onboarded to the Cloud Pak)
   2. If you want to **add multiple users**, just duplicate the user definition and make your modifications
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

1. Clone the git repository or alternatively download the [Starter](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/23.0.1/Deployment_Automation/Starter) folder, [Solution Exports](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/23.0.1/Solution%20Exports) folder, and the [«date»_DeploymentAutomation.jar](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/Deployment_Automation/Current) file
2. Copy both folders and the jar file into the directory previously created in you put the bat/sh file
3. Uncomment the line `disableAccessToGitHub="-disableAccessToGitHub=true"` to disable access to github.com and only use local files

### Configuring Java Heap Size to Avoid Out-of-Memory

In case you experience an Out Of Memory (OOM) situation while deploying the Client Onboarding scenario perform these steps:

1. Uncomment the line containing `jvmSettings=`
2. Set an appropriate heap size

### Removing the Email Server and Client from the Environment

In case you want to clean up your environment and remove the email server and client you previously imported perform these steps:

1. **Save the undeployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)

   **Linux/Mac** 

   *CP4BA 22.0.2* - Starter deployment - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/22.0.2/Deployment_Automation/undeployEmailServerStarter.sh)** or *CP4BA 23.0.1* - Starter deployment - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.1/Deployment_Automation/undeployEmailServerStarter.sh)** (*Ensure to make the sh file executable by performing `chmod +x deployClientOnboardingStarter.sh`*)

   **Windows**

   *CP4BA 22.0.2* - Starter deployment - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/22.0.2/Deployment_Automation/undeployEmailServerStarter.bat)** or CP4BA 23.0.1* - Starter deployment - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.1/Deployment_Automation/undeployEmailServerStarter.bat)**

2. Update the variable `pakInstallerPortalURL` defined at the top of the file with the link from your TechZone reservation details (**PakInstaller Portal URL** at the bottom of the page). Alternatively use the approach described above in the 'Updating bat/sh File for non-Pak Installer Starter Deployment Environments' section.

## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.