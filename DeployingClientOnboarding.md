# -- Under Construction --



# Deploying the Client Onboarding scenario to a Jam-in-a-box environment

## Introduction

Use these instruction to deploy the out-of-box end-to-end [Client Onboarding solution](https://github.com/IBM/cp4ba-client-onboarding-scenario) to a self-provisioned Jam-in-a-box environment. For more information about Jam-in-a-box refer to the [Jam-in-a-box overview](https://github.com/IBM/cp4ba-client-onboarding-scenario/JamInABox.md) page.


## Prerequisites

1. **Cloud Pak for Business Automation (CP4BA) cluster**
   IBM Business Partners and IBMers can reserve a [Jam-in-a-box for Business Automation](https://techzone.ibm.com/collection/jam-in-a-box-for-business-automation) cluster from IBM TechZone.
   (An alternative is to create or use a CP4BA 22.0.1 starter deployment authoring environment that has configured at least the following capabilities: Automation Decision Services, Workflow, Business Automation Insights)

   ***Environment verification***

   Once you have reserved a cluster in IBM TechZone, it is first **Scheduled** for provisioning. After a while it moves into status **Provisioning**, and after some time finally becomes **Ready**. At that time you'll also get an email that your cluster is Ready. ***This only means that the Red Hat OpenShift part is now available.*** Once the cluster is Ready, the deployment of the CP4BA starter deployment will automatically be performed. Therefore, you have to wait until not only the OCP cluster has been provisioned but also until CP4BA starter deployment has been completely deployed. ***Combined this may take several hours (~5-6 hours).***

   In rare cases a bug in Red Hat OpenShift may block the successful deployment of CP4BA starter deployment. To identify that your TechZone provisioned environment has hit this issue, please **check your cluster about *one* hour after the cluster has become ready**. For this, please perform the following steps:

   a. Open the **OpenShift web console** in a browser

   b. In the left-hand side navigator go to **Operators -> Installed Operators**

   c. Make sure the **project scope** is set to **All Projects**

   d. Verify that **all** **Operators** show in the column **Status** the value **Succeeded**

   e. If there are one or multiple Operators **NOT with Status 'Succeeded'** (for example in Status 'Failed', 'Unknown', or 'Cannot update'), your environment is affected by the mentioned bug and **applying a manual workaround is required**. For this, please reach out for **[Support](#support)**

   f. Once all Operators show in column **Status 'Succeeded'**, you can proceed with the next prerequisite

   

   Verify that your CP4BA cluster is completely deployed and ready for deploying the Client Onboarding scenario:
   
   - Open the **OpenShift web console** in a browser
   - Click on **Workloads -> ConfigMaps** in the left-hand side navigator
   - Type '**access-info**' in the field next to 'Name'

   If the ConfigMap '**icp4adeploy-cp4ba-access-info**' is shown, your CP4BA cluster is fully deployed.
   
2. **Gmail account**
   The Client Onboarding scenario uses the Gmail SMTP server to send emails with status updates for individual client onboarding requests. If you don't have a suitable Gmail account, set up a new account first. For the credentials, create an **[App Password](https://support.google.com/accounts/answer/185833?hl=en)**. You will need both the email address and the app password for the deployment.

3. **RPA environment** (IBM Business Partners and IBMers only)
   In case you want to experience or demo how the RPA bot is executed as part of running the Client Onboarding scenario, please provision an instance of [**IBM Business Automation - Traditional and On-premise. V4 Updated 2023-02-14** ](https://techzone.ibm.com/collection/ibm-business-automation-traditional-and-on-premise) (make sure to use **V4**). Wait until you receive an email from IBM TechZone with the title "Your environment is ready". As explained below you need information from this email to deploy the Client Onboarding solution.

   Once the environment is ready select your reservation. At the bottom of the screen you find a large blue button below the header 'VM Remote Console'. This is the recommended way to connect to the RPA VM for demoing the bot. ***Prior to testing/demoing:*** Start Firefox, the browser used by the bot, once and ensure that no update or similar is pending which could interfere with executing the bot. Afterwards close the browser again.

4. **Machine to start deployment from**
   Windows, Linux, or Mac with **Java 8** or later installed is required to start the deployment. Ensure that the **bin** directory of your Java installation is part of the operation system path. If you receive an error like **'Java' is not recognized as an internal or external command** then this is not the case.

## Import Instructions

### Download Required Files

   1. **Create a new directory** on your machine from which to start the deployment (e.g. "co_depl")
      
   2. **Save the deployment file** that corresponds to the operating system of your deployment machine into the directory created in step 1 (in the context menu of your browser select **Save as.../Save page as...** or similar)
      **Linux/Mac** 	*CP4BA 22.0.1* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/22.0.1/Deployment_Automation/deployClientOnboardingStarter.sh)** (*Ensure to make the sh file executable by performing `chmod +x deployClientOnboardingStarter.sh`*)
      **Windows** - *CP4BA 22.0.1* - Starter deployment - **[deploy](https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/22.0.1/Deployment_Automation/deployClientOnboardingStarter.bat)**

### Update bat/sh File
On Windows open the file **deployClientOnboardingStarter.bat**/on Linux or Mac open the file **deployClientOnboardingStarter.sh** in the text editor of your choice. **Update the variables defined at the top of the file with your specific details**:

  1. `ocLoginServer` and `ocLoginToken` -  Set to the value of the **server** respectively **token** parameter as shown on the '***Copy login command***' page in the OpenShift web console (click on your name in the top right corner to get to the drop down with the 'Copy login command' option)

  2. `gmailAddress` and `gmailAppKey` - Set to the values of your Gmail account as described under 'Prerequisites' step 2.

  3. In case you want to observe or demo the RPA bot being invoked as part of the Client Onboarding scenario, set the following two variables:
     1. `rpaBotExecutionUser` - Set to the user for who the RPA bot should be executed (would normally be `cp4admin`). Setting it to a non-existing user like cp4admin2 will always skip the bot invocation.

     2. `rpaServer` - Set this to the URL of the RPA environment that you provisioned in step '3. RPA environment' above. Use the URL listed as `RPA Asynch Server API` in the email that you received when your environment became ready.

  4. In case you need to go through a proxy to access github.com uncomment the lines `proxyScenario=GitHub`, `proxyHost=`, and `proxyPort=` and specify the host and port values for your proxy. In case your proxy requires authentication do the same for the lines `proxyUser=` and `proxyPwd=`.

  5. If you experience an Out Of Memory (OOM) situation while deploying the Client Onboarding scenario, you might need to uncomment the line containing `jvmSettings=`. 

### Perform Import
*As part of the deployment the deployment tool pulls additional resources from the GitHub repository. Ensure the machine you are executing the tool from has access both to GitHub (github.com/githubusercontent.com) and the location where your CP4BA instance is running.*

In a console window execute **deployClientOnboardingStarter.bat** or **./deployClientOnboardingStarter.sh** to perform the import of the Client Onboarding scenario.

In case you are using Java 9 or later, you will see a message `WARNING: sun.reflect.Reflection.getCallerClass is not supported. This will impact performance.` . This can safely be ignored.

After about 10 minutes the import should complete successfully. The deployment tool will print an overview of the actions it performs and their results to the console. In case the deployment is successful, you will find a section at the end that states this and provides key links and user names/passwords for you to use. These links/values are specific to your environment.

```
Overall execution completed after 10 mins, 42 secs

Deploying the Client Onboarding artifacts was successful.

Client Onboarding Desktop:
  - Client Onboarding desktop https://cpd-ibm-cp4ba.<clustername>/icn/navigator/?desktop=ClientOnboarding
  - Client Onboarding Document Upload https://cpd-ibm-cp4ba.<clustername>/ae-workspace/public-app/Client%20Onboarding%20Document%20Upload(CODU)?ReferenceID=<Your Reference ID>
  - IBM Business Performance Center (BPC) https://cpd-ibm-cp4ba.<clustername>/bai-bpc

For labs:
  - IBM Cloudpak Dashboard (open Business Automation Studio from there) https://cpd-ibm-cp4ba.<clustername>
  - IBM Content Services ACCE: https://cpd-ibm-cp4ba.<clustername>/cpe/acce/
  - IBM Content Services Admin Desktop: https://cpd-ibm-cp4ba.<clustername>/icn/navigator/?desktop=admin
  - IBM Content Services GraphQL: https://cpd-ibm-cp4ba.<clustername>/content-services-graphql/
  - ICN (Content/ICN lab) Desktop: https://cpd-cp4ba.<clustername>/icn/navigator/?desktop=ICN

Utilities:
  - Process Admin Console https://cpd-ibm-cp4ba.<clustername>/bawaut/ProcessAdmin
  - ICN BAWADMIN desktop: https://cpd-ibm-cp4ba.<clustername>/icn/navigator/?desktop=bawadmin/

User credentials:
  - Using user 'cp4admin' with password '<pwd>'
  - Additional user: User 'user1', Pwd '<pwd>'

Successfully created ConfigMap 'client-onboarding-information' with same information as above

--- Execution completed ---
```

This information is also stored in a ConfigMap named `client-onboarding-information`. If you need to find the information again, you can always review it in this single location. Just log into the OpenShift web console of your cluster, in the left-hand navigator expand `Workloads`, click on `ConfigMaps`, and enter `client` into the `Search by name...` field at the top.

### Troubleshooting the Client Onboarding Deployment
The deployment tool performs a lot of validation upfront and will report any issues it encounters. You can execute it multiple times without causing any issues. It will skip over those deployment steps that have already been successfully performed.
Sometimes the deployment fails because of timing issue. These may not occur again when triggering the deployment a second time. Other failures have been observed where the CP4BA cluster or some of its PODs had issues and needed to be restarted.

For the purpose of analyzing issues the deployment tool creates four files in the directory where it is located:
- deployClientOnboarding_22.0.1_Starter_output.txt - Contains the messages printed to the console
- deployClientOnboarding_22.0.1_Starter_detailedOutput.txt - Everything printed to the console plus details about the deployment steps
- deployClientOnboarding_22.0.1_Starter_trace.txt - Contains very detailed traces messages about everthing that is done as part of running a deployment
- deployClientOnboarding_22.0.1_Starter_combined.txt - Contains a combination of detailedOutput and trace files

In case your deployment fails and you get stuck, please reach out using the contact information that is given when the deployment fails and provide the `<date>_collector.zip` file created in this instance.

## Performing IBM Cloud Pack for Business Automations Labs

Once you have imported the Client Onboarding scenario successfully, you can perform the demo and labs mentioned in the **Mapping of labs to environments** table of the [Jam-in-a-box overview](https://github.com/IBM/cp4ba-client-onboarding-scenario/JamInABox.md) page.

##### Considerations

- The lab instructions refer to using the URLs found on the Tech Jam event page. For Jam-in-a-box (self-paced) learning environments, please use those URLs provided when the deployment completes and/or refer to the `client-onboarding-information` ConfigMap that is created when the deployment is successful.
- The lab instructions mention how to receive your user credentials using a link on the Tech Jam event page. For Jam-in-a-box (self-paced) learning environments, please use the admin user and admin password provided when the deployment completes and/or refer to the `client-onboarding-information` ConfigMap that is created when the deployment is successful.
- The lab instructions mostly mention to prefix your artifacts with "usrXYZ". This is important when working in a shared environment. You may choose to still follow the instructions in this point, even when this is not strictly required for the Jam-in-a-box environment that is considered a single-user environment.
- In the lab instructions for the *Introduction to IBM Business Automation Application* lab and the *Consume & Publish Automation Services in Workflow* lab an Automation Service called `Client_Onboarding_Decisions` is referenced. In the Jam-in-a-Box learning environment this automation service is called `co_decisions` instead.

## Support

**Business Partners and IBMers** 

To engage us, drop us a message at #jam-in-a-box-business-automation.

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.