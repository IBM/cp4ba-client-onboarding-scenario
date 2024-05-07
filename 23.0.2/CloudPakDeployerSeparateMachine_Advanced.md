# Advanced configuration scenarios when deploying the Client Onboarding scenario into an Enterprise Deployment created by Cloud Pak Deployer (for CP4BA 23.0.2 IF002 and above)  

## Introduction

> [!IMPORTANT]
>
> These instructions only apply in case you want to perform advanced configuration of deployment of the Client Onboarding scenario to a CP4BA 23.0.2 Enterprise deployment deployed by [**Cloud Pak Deployer**](CloudPakDeployerSeparateMachine.md).



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

1. `rpaBotExecutionUser` - Set to the user for who the RPA bot should be executed for (would normally be `cpadmin`). Setting it to a non-existing user like cpadminNotExist will always skip the actual bot invocation.

2. `rpaServer` - Set this to the URL of the RPA environment that you provisioned as described above. Use the URL listed as `RPA Asynch Server API` at the top of your reservation on IBM TechZone. 

   <img src="..\images\rpa-reservation-async-url.jpg" />

If you have previously run the deployment, run it again. It will recognize that your RPA configuration has changed and will redeploy the artifact that contains the changed RPA information.

### Configuring an external email server (gmail)

By default a Cloud Pak Deployer deployed environment has an internal email server and web-based email client. Emails being sent as part of the Client Onboarding scenario can only be send and received using the internal email addresses of the email server.

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
   4. If you want to **set the password for all regular users** ("user1" to "user10") to a value of your choice, add element "userPwd" with the password to be set on the same level as the "entities" attribute. (e.g. "userPwd": "password"). Be aware that all of the users 1-10 will get the same password
3. In the sh/bat file modify the line "**createUsers**=" and set the value from false to true

### Using a proxy server to access github.com

In case you need to go through a proxy to access github.com perform these steps: 

1. Uncomment the three lines starting with `proxyScenario=GitHub`, `proxyHost=`, and `proxyPort=` 
2. Specify the host and port values for your proxy
3. In case your proxy requires authentication do the same for the lines `proxyUser=` and `proxyPwd=`

### Executing the deployment without access to github.com

In case don't have access to github.com and want to perform the deployment in air-gap mode perform these steps: 

1. Clone the git repository or alternatively download the [Enterprise](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/23.0.2/Deployment_Automation/Enterprise) folder, [Solution Exports](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/23.0.2/Solution%20Exports) folder, and the [«date»_DeploymentAutomation.jar](https://github.com/IBM/cp4ba-client-onboarding-scenario/tree/main/Deployment_Automation/Current) file
2. Copy both folders and the jar file into the directory previously created in you put the bat/sh file
3. Uncomment the line `disableAccessToGitHub="-disableAccessToGitHub=true"` to disable access to github.com and only use local files

### Configuring Java Heap Size to Avoid Out-of-Memory

In case you experience an Out Of Memory (OOM) situation while deploying the Client Onboarding scenario perform these steps:

1. Uncomment the line containing `jvmSettings=`
2. Set an appropriate heap size

### Removing the Client Onboarding Artifacts from the Environment

In case you want to clean up your environment and remove the Client Onboarding artifacts you previously imported perform these steps:

1. **Save the undeployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)

   **Linux/Mac** *CP4BA 23.0.2* - Enterprise deployment via Cloud Pak Deployer - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.2/Deployment_Automation/undeployClientOnboardingCloudPakDeployerEnterpriseWithGitea.sh)** (*Ensure to make the sh file executable by performing `chmod +x deployClientOnboardingStarter.sh`*)

   **Windows** - *CP4BA 23.0.2* - Enterprise deployment via Cloud Pak Deployer - **[undeploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/23.0.2/Deployment_Automation/undeployClientOnboardingCloudPakDeployerEnterpriseWithGitea.bat)**

2. Update the two variables `ocLoginServer` and `ocLoginToken` defined at the top of the bat/sh file with your specific details.

## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.