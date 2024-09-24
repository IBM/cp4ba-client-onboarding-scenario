# Troubleshooting deploying the Client Onboarding scenario into a Starter deployment environment - Using an OCP Job (for CP4BA 24.0.0) 

## Introduction

> [!IMPORTANT]
>
> These instructions only apply in case you want to troubleshoot the [OCP Job-based deployment](StarterDeploymentViaJob.md) of the Client Onboarding scenario to a CP4BA 24.0.0 Starter deployment.



## Troubleshooting the Client Onboarding Deployment

The deployment tool performs a lot of validations and will report any issues it encounters. It can be execute sequentially multiple times without causing any issues, but should not be executed multiple times in parallel. It will skip over those deployment steps that have already been successfully performed. 

**Sometimes the deployment fails because of timing or network issues.** Therefore, the job is configured to attempt the deployment a maximum of three times in case deployment attempts end in error, before the job is marked as Failed. 
**Other failures have been observed where the CP4BA environment or some of its pods had issues and needed to be restarted manually.** In such cases, once you resolved issue, you can create a new Job by just importing the YAML artifact again.

If the deployment finally failed, you will see three different pods all in **Error** state and the Job in **Failed** state.

<img src="images\ocp-deploy-job-created-failed.jpg" />

For the purpose of analyzing the execution details or failures, the deployment tool creates four log files in a directory specific to the pod the deployment is run from (using the pod's name) that is located in the **/logs/application/client-onboarding** directory:
- deployClientOnboarding_24.0.0_Starter_output.txt - Contains the messages printed to the console
- deployClientOnboarding_24.0.0_Starter_detailedOutput.txt - Everything printed to the console plus details about the deployment steps
- deployClientOnboarding_24.0.0_Starter_trace.txt - Contains very detailed trace messages about everything that is done as part of running a deployment
- deployClientOnboarding_24.0.0_Starter_combined.txt - Contains a combination of the detailedOutput and trace files

In case your deployment fails and you get stuck, please reach out using the contact information that is given when the deployment fails and provide the `<date>_collector.zip` file created in this instance in the same directory as the log files.

To get to the logs and optionally copy them to your local machine , follow these steps:

1. **Click** on the pod that you are interested in getting the logs for (e.g. the last one that failed)
2. Go to the **Logs** tab to bring up the console log of the pod. Towards the top of the output, you should find a line like this 
   `Using tmp storage directory '/usr/client-onboarding/', Using output directory '/logs/application/client-onboarding/client-onboarding-deploy-<id of the pod>/'` .
   Store the full path `/logs/application/client-onboarding/client-onboarding-deploy-<id of the pod>/` for later usage.

#### Viewing log file content

1. In the left-hand navigator expand `Workloads`, click on `Pods`, and enter `bastudio-d` into the field next to `Name`. (Make sure that the project of your CP4BA deployment is selected)
2. **Open** the `icp4adeploy-bastudio-deployment-0` **pod** that should be shown in running state
3. Switch to the **Terminal** tab and enter `cd /logs/application/client-onboarding/client-onboarding-deploy-<id of the pod>/`to switch to the correct sub-directory (using the specific directory name that you captured before)
4. **Enter** `ls -l` to list the files in the directory. Using `vi deployClientOnboarding_24.0.0_Starter_output|detailedOutput|trace|combined.txt`, you can look at content of the different log files

#### Copying log/collector zip file to local machine

1. Download and unpack the OpenShift CLI client to your local machine (download it from https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/ using the `openshift-client-<platform>` archive that fits your operating system)

2. In the OpenShift Console click the **Copy login command** option in the drop down that appears when clicking on the user name in the top right corner 

   <img src="images\openshift-copy-log-in-command.jpg" />

   Click on **Display Token** link shown on the next page 

   1. Copy the complete string listed below **Log in with this token**<img src="images\openshift-oc-log-in.jpg" />

3. Open a console window on your machine in the directory where you unpacked the OCP CLI and paste the string you copied from the **Copy login command** screen. This will connect you to the remote OCP cluster.

4. Type `oc project cp4ba-starter` to switch to the project/namespace where your CP4BA installation is located

   > [!IMPORTANT]
   >
   > If your CP4BA instance is not deployed to the namespace `cp4ba-starter`, you need to modify cp4ba-starter to match your deployment namespace.

5. Type `oc cp icp4adeploy-bastudio-deployment-0:/logs/application/client-onboarding/client-onboarding-deploy-<id of the pod>/deployClientOnboarding_24.0.0_Starter_output|detailedOutput|trace|combined.txt ./deployClientOnboarding_24.0.0_Starter_output|detailedOutput|trace|combined.txt` to copy the respective file to your local machine.

   The command consists of 

   - the name of the BA Studio pod (that should always be icp4adeploy-bastudio-deployment-0),
   - the directory that contains the log file (that you copied from the console of the pod performing the deployment),
   - the name of the file you want to copy (could also be the collector zip file),
   - and the target directory and name where the file should be copied to

## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.