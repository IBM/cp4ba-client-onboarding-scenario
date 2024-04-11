# Deploying the Client Onboarding scenario into a Starter deployment environment - Using an OCP Job (for CP4BA 23.0.2 IF002 and above) 

## Introduction

Use these instruction to deploy the end-to-end [Client Onboarding solution](https://github.com/IBM/cp4ba-client-onboarding-scenario) and its accompanying [labs](https://github.com/IBM/cp4ba-labs/tree/main/23.0.2/README.md) to a self-provisioned **Cloud Pak for Business Automation (CP4BA) 23.0.2** environment using an OpenShift Job.

This deployment approach does not require a separate machine with Java on it to run the deployment or the manual download of any resources. 

I different approach using a separate machine, that offers more customization options, is described [here](StarterDeploymentViaJob.md).


## Prerequisites

**Cloud Pak for Business Automation (CP4BA) 23.0.2 IF002 or newer Starter deployment environment**

### IBM TechZone provided environment

Reserve a Business Automation environment from IBM TechZone. For that select the **CP4BA 23.0.x - Multi-Pattern Starter TechZone Deployer powered CP4BA 2023.x** tile from the [Pre-Installed Software](https://techzone.ibm.com/collection/tech-zone-certified-base-images/journey-pre-installed-software) tab.

Provide and select the required information. The selection you make for 'Purpose' determines if you need to specify a 'Sales Opportunity number' and the 'reservation policy' (how long the environment is available and how often it can be extended).

<img src="..\images\techzone-reservation_2302_starter.jpg" />

Once you have reserved an environment in IBM TechZone, it is first **Scheduled** for provisioning. After a while it moves into status **Provisioning**, and after about 2-3 hours it finally becomes **Ready**. You will receive an email when provisioning starts and a second email with the subject '**Reservation Ready on IBM Technology Zone**' when it completes. 

> [!WARNING]
>
> Ready in this case only means that OpenShift has been provisioned and that deploying Cloud Pak for Business Automation has been started but **not** that it is fully deployed yet. This may take another 4-5 hours to complete. 
> See below for how to check that CP4BA has been successfully deployed.

The final email contains a link '**View My Reservations**' to get to your reservations. Click on this link and click on the tile that represents your reservation.

<img src="..\images\your-environment-is-ready_2302_starter.jpg" />

Towards the top of the screen you will find the **link to the OpenShift console**, the **Username** (which is always **kubeadmin**) to log into the OpenShift console, and the unique **Password** for the environment.

   <img src="..\images\techzone-reserved-env_2302_starter.jpg" />

### Bring Your Own CP4BA environment

Alternatively, create or use a CP4BA 23.0.2 IF002 or newer Starter deployment authoring environment with at least the following capabilities: Business Applications, Automation Decision Services, Workflow, Business Automation Insights, Process Federation Server.

> [!IMPORTANT]
>
> IF002 or later is required due to bugs in earlier versions that prohibit the deployment and successful working of the scenario.

## Import Instructions

1. **Log into the OpenShift console** of your environment (for TechZone environments use the information from the tile representing your reservation as shown above)

2. **Validate the environment is fully deployed**

   > [!WARNING]
   >
   > Only proceed once you have successfully validated your environment. Otherwise, the deployment of the Client Onboarding scenario will fail.

   In the **OpenShift console**

   - Make sure that the **Project** selected is **cp4ba-starter**  (or the name of the project you have deployed your instance of CP4BA into)
   - Click on **Workloads -> ConfigMaps** in the left-hand side navigator
   - Type '**access-info**' in the field next to 'Name'

   If the ConfigMap '**icp4adeploy-cp4ba-access-info**' is shown, your CP4BA cluster is fully deployed. **If not, periodically check until it is listed.** 

   > [!NOTE]
   >
   > For an environment provisioned from TechZone, this can take up to 4-5 hours after you have received the email, for the environment to be ready.

3. **Import** the following **YAML** to **create a Service Account** and **assign** it the **required rights** 

   > [!TIP]
   >
   > **How to import a YAML using the OpenShift console**
   >
   > 1. Once logged into the OpenShift console, **click** the **+** sign in the top right corner
   >
   > <img src="..\images\openshift-import-YAML-button.jpg" />
   >
   > 2. **Paste** your **YAML** into the large text box and **click Create** at the bottom left to have OpenShift apply your YAML
   >
   >    <img src="..\images\openshift-import-YAML.jpg"/>

   

   > [!NOTE]
   >
   > 1. If your CP4BA instance is not deployed into the namespace `cp4ba-starter`, you need to modify the **4** **(four)** locations where it is used to match your deployment namespace.
   >
   > 2. This import only needs to and can be performed once. In case you want to modify something, or later remove the scenario, you need to skip this step.

   ```yaml
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: cb4ba-deployment-tool-sa
     namespace: cp4ba-starter
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: RoleBinding
   metadata:
     name: system:openshift:scc:privileged
     namespace: cp4ba-starter
   roleRef:
     apiGroup: rbac.authorization.k8s.io
     kind: ClusterRole
     name: system:openshift:scc:privileged
   subjects:
   - kind: ServiceAccount
     name: cb4ba-deployment-tool-sa
     namespace: cp4ba-starter
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: ClusterRoleBinding
   metadata:
     name: cb4ba-deployment-tool-cluster-admin
   roleRef:
     apiGroup: rbac.authorization.k8s.io
     kind: ClusterRole
     name: cluster-admin
   subjects:
   - kind: ServiceAccount
     name: cb4ba-deployment-tool-sa
     namespace: cp4ba-starter
   ```

   As a result you should see a similar screen as below:

   <img src="..\images\sa-yaml-import-complete.jpg" />

4. **Import** the following **YAML** to **deploy the Client Onboarding scenario** itself 
   If required customize any of the settings starting with a lower-case character in the **env** section of the YAML.

   | Parameter                            | Value                      | Description                                                  |
   | ------------------------------------ | -------------------------- | ------------------------------------------------------------ |
   | ocpStorageClassForInternalMailServer | Valid storage OCP class    | Depending on where and how OpenShift is deployed, it has different Storage classes. <br />Go to **Storage -> StorageClasses**, select a storage class that provides RWO and RWX filesystem volumes, and use the storage class name.<br />(The default value normally works for TechZone OCP clusters.) |
   | configureLabs                        | true/false                 | Should the artifacts for the labs be deployed too (true) or only those for the Client Onboarding scenario (false) |
   | enableWorkflowLabsForBusinessUsers   | true/false                 | Should the environment be configured so that business users (user1-user10)  can perform the Workflow labs (true) and not just the admin (cp4admin) user (true).<br />If set to true, this will significantly increase the deployment time to up to 45 minutes. |
   | rpaBotExecutionUser                  | User short name            | User (e.g. cp4admin) for who the RPA bot is executed (specifying a non-existing user always skips the RPA bot execution) |
   | rpaServer                            | RPA  Asynch Server API URL | In case the RPA bot execution is enabled via above parameter need to set this to the **Asynch Server API** URL of the RPA environment to be used. <br />For more details see **Configuring an RPA environment** topic as part of the **Advanced Configuration** entry below. |
   | printDetailedMessageToConsole        | true/false                 | Should detailed log messages be printed to the console (true) or just the summary (false). |

   > [!IMPORTANT]
   >
   > If your CP4BA instance is not deployed into the namespace `cp4ba-starter`, you need to modify the **single** namespace location to match your deployment namespace.

   > [!IMPORTANT]
   >
   > As part of the deployment, resources are pulled from java.net, openshift.com, and github.com/githubusercontent.com. Therefore, your OCP environment needs to be connected to the Internet and these sites need to be reachable. 

   ```yaml
   apiVersion: batch/v1
   kind: Job
   metadata:
     generateName: client-onboarding-deploy-
     namespace: cp4ba-starter
   spec:
     template:
       metadata:
         labels:
           app: client-onboarding-deploy
       spec:
         serviceAccountName: cb4ba-deployment-tool-sa
         volumes:
           - name: log-pvc
             persistentVolumeClaim:
               claimName: cp4a-shared-log-pvc
         containers:
           - name: client-onboarding-deploy
             image: ubi9/ubi:9.3
             command: ["/bin/bash"]
             args:
               ["-c","
               
               currentowner=`ls -n -l '$(LOG_DIR_BASE)/CaseInit.log' | awk 'NR==1 {print $3}'`;
               mkdir -p '$(LOG_DIR)';
               chown -R $currentowner '$(LOG_DIR_BASE_CO)';
               mkdir /usr/client-onboarding;
               cd /usr/client-onboarding;
               curl -sO https://download.java.net/java/GA/jdk9/9/binaries/openjdk-9_linux-x64_bin.tar.gz;
               echo 'Downloaded OpenJDK 9';
               tar -xf openjdk-9_linux-x64_bin.tar.gz;
               ln -fs `pwd`/jdk-9/bin/java /usr/local/bin/java;
               curl -sO https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz;
               echo 'Downloaded OpenShift CLI';
               tar -xzf openshift-client-linux.tar.gz;
               ln -fs `pwd`/oc /usr/local/bin/oc;
               oc project $(NAMESPACE);
               deploymenttype=`oc get icp4acluster -o json | grep -Po '\"olm_deployment_type\":.*\",' | awk -F': \\\"|\\\",' '{print $2}'`;
               deploymentversion=`oc get icp4acluster -o json | grep -Po '\"appVersion\":.*\",' | awk -F': \"|\",' '{print $2}'`;
               curl -sLO https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/$deploymentversion/Deployment_Automation/deployClientOnboardingStarterParam.sh;
               echo 'Downloaded client onboarding deploy sh file';
               chmod u+x deployClientOnboardingStarterParam.sh;
               ./deployClientOnboardingStarterParam.sh --ocls `oc whoami --show-server=true` --oclt `oc whoami -t` --op '$(LOG_DIR)' --ns '$(NAMESPACE)' --cl '$(configureLabs)' --ewflbu '$(enableWorkflowLabsForBusinessUsers)' --rpau '$(rpaBotExecutionUser)' --rpas '$(rpaServer)' --pdmtoc '$(printDetailedMessageToConsole)';"]
             imagePullPolicy: IfNotPresent
             env:
               - name: PODNAME
                 valueFrom:
                   fieldRef:
                     fieldPath: metadata.name
               - name: NAMESPACE
                 valueFrom:
                   fieldRef:
                     fieldPath: metadata.namespace
               - name: LOG_DIR_BASE
                 value: /logs/application
               - name: LOG_DIR_BASE_CO
                 value: $(LOG_DIR_BASE)/client-onboarding
               - name: LOG_DIR
                 value: $(LOG_DIR_BASE_CO)/$(PODNAME)
               - name: ocpStorageClassForInternalMailServer
                 value: ocs-storagecluster-cephfs
               - name: configureLabs
                 value: "true"
               - name: enableWorkflowLabsForBusinessUsers
                 value: "false"
               - name: rpaBotExecutionUser
                 value: cp4admin2
               - name: rpaServer
                 value: https://rpa-server.com:1111
               - name: printDetailedMessageToConsole
                 value: "false"
             volumeMounts:
               - name: log-pvc
                 mountPath: /logs/application
         restartPolicy: Never
     backoffLimit: 2
   ```

   As soon as you **click Create**, a job will be created and opened in the console, showing as **In progress**.
   <img src="..\images\ocp-deploy-job-created-inprogress.jpg" />

5. **Follow the progress** of the deployment using one of two methods:

   1. The easiest way is to **watch the job** created by importing the second YAML, to get to the **Complete** (or Failed) state. 

      <img src="..\images\ocp-deploy-job-created-complete.jpg" />

      Once completed, in the left-hand navigator expand `Workloads`, click on `ConfigMaps`, and enter `client` into the field next to `Name`. (Make sure that either *All Projects* or the project of the CP4BA deployment is selected).
      A ConfigMap named `client-onboarding-information` will provide you with all required access details.

      ```
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
      ```

   2. In case you want to follow the execution of the Client Onboarding scenario deployment in detail, click on the **Pods** tab.
      <img src="..\images\ocp-deploy-job-created-pods.jpg" />

      From there click on the pod and switch to the **Logs** tab.
      <img src="..\images\ocp-deploy-job-created-pod-logs.jpg" />

      You can follow the progress of the deployment tool as it prints an overview of the actions it performs and their results to the console. 

      Once the deployment tool completes without a fatal error, it will output a status message that declares successful deployment of the Client Onboarding scenario. In addition, it provides key links and user names/passwords for you to use. These links/values are specific to your environment. 

      This is the same information, that is also available in the `client-onboarding-information` ConfigMap as shown above.deploy-

### Troubleshooting the Client Onboarding Deployment

The deployment tool performs a lot of validations and will report any issues it encounters. It can be execute sequentially multiple times without causing any issues, but should not be executed multiple times in parallel. It will skip over those deployment steps that have already been successfully performed. 

**Sometimes the deployment fails because of timing or network issues.** Therefore, the job is configured to attempt the deployment a maximum of three times in case deployment attempts end in error, before the job is marked as Failed. 
**Other failures have been observed where the CP4BA environment or some of its pods had issues and needed to be restarted manually.** In such cases, once you resolved issue, you can create a new Job by just importing the YAML artifact again.

If the deployment finally failed, you will see three different pods all in **Error** state and the Job in **Failed** state.

<img src="..\images\ocp-deploy-job-created-failed.jpg" />

For the purpose of analyzing the execution details or failures, the deployment tool creates four log files in a directory specific to the pod the deployment is run from (using the pod's name) that is located in the **/logs/application/client-onboarding** directory:
- deployClientOnboarding_23.0.2_Starter_output.txt - Contains the messages printed to the console
- deployClientOnboarding_23.0.2_Starter_detailedOutput.txt - Everything printed to the console plus details about the deployment steps
- deployClientOnboarding_23.0.2_Starter_trace.txt - Contains very detailed trace messages about everthing that is done as part of running a deployment
- deployClientOnboarding_23.0.2_Starter_combined.txt - Contains a combination of the detailedOutput and trace files

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
4. **Enter** `ls -l` to list the files in the directory. Using `vi deployClientOnboarding_23.0.2_Starter_output|detailedOutput|trace|combined.txt`, you can look at content of the different log files

#### Copying log/collector zip file to local machine

1. Download and unpack the OpenShift CLI client to your local machine (download it from https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/ using the `openshift-client-<platform>` archive that fits your operating system)

2. In the OpenShift Console click the **Copy login command** option in the drop down that appears when clicking on the user name in the top right corner 

      <img src="..\images\openshift-copy-log-in-command.jpg" />

   Click on **Display Token** link shown on the next page 

3. Copy the complete string listed below **Log in with this token**<img src="..\images\openshift-oc-log-in.jpg" />

4. Open a console window on your machine in the directory where you unpacked the OCP CLI and paste the string you copied from the **Copy login command** screen. This will connect you to the remote OCP cluster.

5. Type `oc project cp4ba-starter` to switch to the project/namespace where your CP4BA installation is located

   > [!IMPORTANT]
   >
   > If your CP4BA instance is not deployed to the namespace `cp4ba-starter`, you need to modify cp4ba-starter to match your deployment namespace.

6. Type `oc cp icp4adeploy-bastudio-deployment-0:/logs/application/client-onboarding/client-onboarding-deploy-<id of the pod>/deployClientOnboarding_23.0.2_Starter_output|detailedOutput|trace|combined.txt ./deployClientOnboarding_23.0.2_Starter_output|detailedOutput|trace|combined.txt` to copy the respective file to your local machine.

   The command consists of 

   - the name of the BA Studio pod (that should always be icp4adeploy-bastudio-deployment-0),
   - the directory that contains the log file (that you copied from the console of the pod performing the deployment),
   - the name of the file you want to copy (could also be the collector zip file),
   - and the target directory and name where the file should be copied to

## Advanced Configuration

### Performing the Workflow labs using business users (instead of or in addition to the admin user)

As part of the YAML to start the deployment, set the env variable `enableWorkflowLabsForBusinessUsers` to `true`.

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

As part of the YAML to start the deployment, set the env variable `rpaBotExecutionUser` and `rpaServer`.

1. `rpaBotExecutionUser` - Set to the user for who the RPA bot should be executed for (would normally be `cp4admin`). Setting it to a non-existing user like cp4admin2 will always skip the actual bot invocation.

2. `rpaServer` - Set this to the URL of the RPA environment that you provisioned as described above. Use the URL listed as `RPA Asynch Server API` at the top of your reservation on IBM TechZone. 

   <img src="..\images\rpa-reservation-async-url.jpg" />

If you have previously run the deployment, run it again by importing the YAML again. It will recognize that your RPA configuration has changed and will redeploy the artifact that contains the changed RPA information.

### Removing the Client Onboarding Artifacts from the Environment

1. **Import** the following **YAML** to **undeploy the Client Onboarding scenario** 
   If required customize any of the settings starting with a lower-case character in the **env** section of the YAML.

   Modify the three settings starting with **cleanupClientOnboarding** according to your needs. Only if the previous option is set to true, the next option can be set to true, too (e.g. only when cleanupClientOnboardingLabs_UserData is set to true, cleanupClientOnboardingLabs can be set to true)
   Potential use-cases:

   - You ran a workshop and want to reuse the environment, you may want to only remove user-data but keep the lab and scenario artifacts deployed (change cleanupClientOnboardingLabs and cleanupClientOnboardingScenario to false).

   - You want to remove the whole Client Onboarding Artifacts including! custom artifacts created by business users. Then leave all three settings set to true.


   | Parameter                            | Value      | Description                                                  |
   | ------------------------------------ | ---------- | ------------------------------------------------------------ |
   | cleanupClientOnboardingLabs_UserData | true/false | Should all artifacts created by users be removed<br />**Warning:** This option when set to true does **not** remove data in CPE that was created using the admin user of the environment, only data created by the business users.<br />If the admin user created data undeploying the content lab artifacts may fail and manual cleanup may be required of the data created by the admin user before content lab artifacts can be undeployed successfully. |
   | cleanupClientOnboardingLabs          | true/false | Should the artifacts required for the labs be removed        |
   | cleanupClientOnboardingScenario      | true/false | Should the artifacts for the Client Onboarding scenario be removed |
   | printDetailedMessageToConsole        | true/false | Should detailed log messages be printed to the console (true) or just the summary (false). |

    > [!IMPORTANT]
    >
    > If your CP4BA instance is not deployed into the namespace `cp4ba-starter`, you need to modify the **single** namespace location to match your deployment namespace.

    > [!IMPORTANT]
    >
    > As part of the undeployment, resources are pulled from java.net, openshift.com, and github.com/githubusercontent.com. Therefore, your OCP environment needs to be connected to the Internet and these sites need to be reachable. 

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
      generateName: client-onboarding-undeploy-
      namespace: cp4ba-starter
    spec:
      template:
        metadata:
          labels:
            app: client-onboarding-undeploy
        spec:
          serviceAccountName: cb4ba-deployment-tool-sa
          volumes:
            - name: log-pvc
              persistentVolumeClaim:
                claimName: cp4a-shared-log-pvc
          containers:
            - name: client-onboarding-undeploy
              image: ubi9/ubi:9.3
              command: ["/bin/bash"]
              args:
                ["-c","
                
                currentowner=`ls -n -l '$(LOG_DIR_BASE)/CaseInit.log' | awk 'NR==1 {print $3}'`;
                mkdir -p '$(LOG_DIR)';
                chown -R $currentowner '$(LOG_DIR_BASE_CO)';
                mkdir /usr/client-onboarding;
                cd /usr/client-onboarding;
                curl -sO https://download.java.net/java/GA/jdk9/9/binaries/openjdk-9_linux-x64_bin.tar.gz;
                echo 'Downloaded OpenJDK 9';
                tar -xf openjdk-9_linux-x64_bin.tar.gz;
                ln -fs `pwd`/jdk-9/bin/java /usr/local/bin/java;
                curl -sO https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/latest/openshift-client-linux.tar.gz;
                echo 'Downloaded OpenShift CLI';
                tar -xzf openshift-client-linux.tar.gz;
                ln -fs `pwd`/oc /usr/local/bin/oc;
                oc project $(NAMESPACE);
                deploymenttype=`oc get icp4acluster -o json | grep -Po '\"olm_deployment_type\":.*\",' | awk -F': \\\"|\\\",' '{print $2}'`;
                deploymentversion=`oc get icp4acluster -o json | grep -Po '\"appVersion\":.*\",' | awk -F': \"|\",' '{print $2}'`;
                curl -sLO https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/$deploymentversion/Deployment_Automation/undeployClientOnboardingStarterParam.sh;
                echo 'Downloaded client onboarding undeploy sh file';
                chmod u+x undeployClientOnboardingStarterParam.sh;
                ./undeployClientOnboardingStarterParam.sh --ocls `oc whoami --show-server=true` --oclt `oc whoami -t` --op '$(LOG_DIR)' --ns '$(NAMESPACE)' --cCOLUD '$(cleanupClientOnboardingLabs_UserData)' --cCOL '$(cleanupClientOnboardingLabs)' --cCOS '$(cleanupClientOnboardingScenario)' --pdmtoc '$(printDetailedMessageToConsole)';"]
              imagePullPolicy: IfNotPresent
              env:
                - name: PODNAME
                  valueFrom:
                    fieldRef:
                      fieldPath: metadata.name
                - name: NAMESPACE
                  valueFrom:
                    fieldRef:
                      fieldPath: metadata.namespace
                - name: LOG_DIR_BASE
                  value: /logs/application
                - name: LOG_DIR_BASE_CO
                  value: $(LOG_DIR_BASE)/client-onboarding
                - name: LOG_DIR
                  value: $(LOG_DIR_BASE_CO)/$(PODNAME)
                - name: cleanupClientOnboardingLabs_UserData
                  value: "true"
                - name: cleanupClientOnboardingLabs
                  value: "true"
                - name: cleanupClientOnboardingScenario
                  value: "true"
                - name: printDetailedMessageToConsole
                  value: "false"
              volumeMounts:
                - name: log-pvc
                  mountPath: /logs/application
          restartPolicy: Never
      backoffLimit: 2
    ```

    As soon as you **click Create**, a job will be created and opened in the console, showing as **In progress**.
    <img src="..\images\ocp-undeploy-job-created-inprogress.jpg" style="zoom:40%;" />

2. **Follow the progress** of the undeployment using one of two methods:

   1. The easiest way is to **watch the job** created by importing the undeploy YAML, to get to the **Complete** (or Failed) state. 

      <img src="..\images\ocp-undeploy-job-created-complete.jpg" />

      > [!TIP]
      >
      > The ConfigMap named `client-onboarding-information` will only be deleted when `cleanupClientOnboardingScenario` is set to true.
   
   2. In case you want to follow the execution of the Client Onboarding scenario undeployment in detail, click on the **Pods** tab.
      <img src="..\images\ocp-undeploy-job-created-pods.jpg" />
   
      From there click on the pod and switch to the **Logs** tab.
      <img src="..\images\ocp-undeploy-job-created-pod-logs.jpg" />
   
      You can follow the progress of the deployment tool as it prints an overview of the actions it performs and their results to the console. 
   
      Once the deployment tool completes without a fatal error, it will output a status message that declares successful undeployment of the Client Onboarding scenario.
   
      <img src="..\images\ocp-undeploy-job-created-pod-logs-complete.jpg" />

3. **Troubleshooting undeploy errors**

   Please refer to the section **Troubleshooting the Client Onboarding Deployment** above for instructions on how to get to the log files created during undeployment.

## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.