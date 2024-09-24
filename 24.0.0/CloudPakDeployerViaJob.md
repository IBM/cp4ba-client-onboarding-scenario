# Deploying the Client Onboarding scenario into an Enterprise Deployment created by Cloud Pak Deployer - Using an OCP Job (for CP4BA 24.0.0) 

## Introduction

> [!IMPORTANT]
>
> These instructions only apply in case you have set up your CP4BA 24.0.0 Enterprise deployment using [**Cloud Pak Deployer**](https://ibm.github.io/cloud-pak-deployer/30-reference/configuration/cp4ba/).
>
> You need to have deployed at least the following capabilities in your CP4BA environment: Business Applications, Automation Decision Services, Workflow, Business Automation Insights.


Use these instruction to deploy the end-to-end [Client Onboarding solution](https://github.com/IBM/cp4ba-client-onboarding-scenario) and its accompanying [labs](https://github.com/IBM/cp4ba-labs/tree/main/24.0.0/README.md) to a self-provisioned **Cloud Pak for Business Automation (CP4BA) 24.0.0** environment deployed via Cloud Pak Deployer using an OpenShift Job.

This deployment approach does not require a separate machine with Java on it to run the deployment or the manual download of any resources. A different deployment approach using a separate machine, that offers more customization options, is described [here](CloudPakDeployerSeparateMachine.md).



## Prerequisites

**Cloud Pak for Business Automation (CP4BA) 24.0.0 Enterprise deployment environment deployed via Cloud Pak Deployer**

Either

- request a CP4BA 24.0.0 Enterprise environment deployed via Cloud Pak Deployer from TechZone following these [instructions](https://techzone.ibm.com/collection/apollo-business-automation/journey-cp4ba--tech-zone-deployer) 

  or

- bring your own CP4BA 24.0.0 Enterprise deployment authoring environment deployed via [Cloud Pak Deployer](https://ibm.github.io/cloud-pak-deployer/30-reference/configuration/cp4ba/) with at least the following capabilities: Business Applications, Automation Decision Services, Workflow, Business Automation Insights, Process Federation Server.

Once you have a suitable environment proceed to the chapter [Import Instructions](#import-instructions)



## Import Instructions

1. **Log into the OpenShift console** of your environment (for TechZone environments use the information from the tile representing your reservation)

2. **Validate the environment is fully deployed**

   > [!WARNING]
   >
   > Only proceed once you have successfully validated your environment. Otherwise, the deployment of the Client Onboarding scenario will fail.

   In the **OpenShift console**

   - Make sure that the **Project** selected is **cp4ba**  (or the name of the project you have deployed your instance of CP4BA into)
   - Click on **Workloads -> ConfigMaps** in the left-hand side navigator
   - Type '**access-info**' in the field next to 'Name'

   If the ConfigMap **icp4adeploy-cp4ba-access-info** is shown, your CP4BA cluster is fully deployed. **If not, periodically check until it is listed.** 

   > [!NOTE]
   >
   > For an environment provisioned from TechZone, this can take up to 4-7 hours after you have received the email, for the environment to be ready.

3. **Import** the following **YAML** to **create a Service Account** and **assign** it the **required rights** 

   > [!TIP]
   >
   > **How to import a YAML using the OpenShift console**
   >
   > 1. Once logged into the OpenShift console, **click** the **+** sign in the top right corner
   >
   > <img src="images\openshift-import-YAML-button.jpg" />
   >
   > 2. **Paste** your **YAML** into the large text box and **click Create** at the bottom left to have OpenShift apply your YAML
   >
   >    <img src="images\openshift-import-YAML.jpg"/>

   

   > [!NOTE]
   >
   > 1. If your CP4BA instance is not deployed into the namespace `cp4ba`, you need to modify the **4** **(four)** locations where it is used to match your deployment namespace.
   >
   > 2. This import only needs to and can be performed once. In case you want to modify something, or later remove the scenario, you need to skip this step.

   ```yaml
   apiVersion: v1
   kind: ServiceAccount
   metadata:
     name: cb4ba-deployment-tool-sa
     namespace: cp4ba
   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: RoleBinding
   metadata:
     name: system:openshift:scc:privileged
     namespace: cp4ba
   roleRef:
     apiGroup: rbac.authorization.k8s.io
     kind: ClusterRole
     name: system:openshift:scc:privileged
   subjects:
   - kind: ServiceAccount
     name: cb4ba-deployment-tool-sa
     namespace: cp4ba
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
     namespace: cp4ba
   ```

   As a result you should see a similar screen as below:

   <img src="images\sa-yaml-import-complete-cpd.jpg" />

4. **Import** the following **YAML** to **deploy the Client Onboarding scenario** itself 
   If required customize any of the settings starting with a lower-case character in the **env** section of the YAML.

   | Parameter                          | Value                      | Description                                                  |
   | ---------------------------------- | -------------------------- | ------------------------------------------------------------ |
   | configureLabs                      | true/false                 | Should the artifacts for the labs be deployed too (true) or only those for the Client Onboarding scenario (false) |
   | enableWorkflowLabsForBusinessUsers | true/false                 | Should the environment be configured so that business users (cpuser, cpuser1, cpuser2)  can perform the Workflow labs (true) and not just the admin (cpadmin) user (true).<br />If set to true, this will significantly increase the deployment time to up to 45 minutes. |
   | rpaBotExecutionUser                | User short name            | User (e.g. cpadmin) for who the RPA bot is executed (specifying a non-existing user always skips the RPA bot execution) |
   | rpaServer                          | RPA  Asynch Server API URL | In case the RPA bot execution is enabled via above parameter need to set this to the **Asynch Server API** URL of the RPA environment to be used. <br />For more details see **Configuring an RPA environment** topic as part of the **[Advanced Configuration Scenarios](CloudPakDeployerViaJob_Advanced.md#configuring-an-rpa-environment)** entry below. |
   | printDetailedMessageToConsole      | true/false                 | Should detailed log messages be printed to the console (true) or just the summary (false). |
   
   > [!IMPORTANT]
   >
   > If your CP4BA instance is not deployed into the namespace `cp4ba`, you need to modify the **single** namespace location to match your deployment namespace.
   
   > [!IMPORTANT]
   >
   > As part of the deployment, resources are pulled from java.net, openshift.com, and github.com/githubusercontent.com. Therefore, your OCP environment needs to be connected to the Internet and these sites need to be reachable. 
   
   ```yaml
   apiVersion: batch/v1
   kind: Job
   metadata:
     generateName: client-onboarding-deploy-
     namespace: cp4ba
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
               curl -sLO https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/$deploymentversion/Deployment_Automation/deployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh;
               echo 'Downloaded client onboarding sh file';
               chmod u+x deployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh;
               ./deployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh --ocls `oc whoami --show-server=true` --oclt `oc whoami -t` --op '$(LOG_DIR)' --ns '$(NAMESPACE)' --cl '$(configureLabs)' --ewflbu '$(enableWorkflowLabsForBusinessUsers)' --rpau '$(rpaBotExecutionUser)' --rpas '$(rpaServer)' --pdmtoc '$(printDetailedMessageToConsole)' --bd '$(bootstrapDebugString)' --ds '$(debugString)';"]
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
               - name: configureLabs
                 value: "true"
               - name: enableWorkflowLabsForBusinessUsers
                 value: "false"
               - name: rpaBotExecutionUser
                 value: cpadminNonExist
               - name: rpaServer
                 value: https://rpa-server.com:1111
               - name: printDetailedMessageToConsole
                 value: "false"
               - name: bootstrapDebugString
                 value: "com.ibm.dba.swat.cp4ba.tools.ocp.OCPManagerUtil=finest;*=finest"
               - name: debugString
                 value: "*=finest"
             volumeMounts:
               - name: log-pvc
                 mountPath: /logs/application
         restartPolicy: Never
     backoffLimit: 2
   ```
   
   As soon as you **click Create**, a job will be created and opened in the console, showing as **In progress**.
   <img src="images\ocp-deploy-job-created-inprogress.jpg" />
   
5. **Follow the progress** of the deployment using one of two methods:

   1. The easiest way is to **watch the job** created by importing the second YAML, to get to the **Complete** (or Failed) state. 

      <img src="images\ocp-deploy-job-created-complete.jpg" />

      Once completed, in the left-hand navigator expand `Workloads`, click on `ConfigMaps`, and enter `client` into the field next to `Name`. (Make sure that either *All Projects* or the project of the CP4BA deployment is selected).
      A ConfigMap named `000-client-onboarding-information` will provide you with all required access details.

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
      - WatsonX Orchestrate: CP4BA-side configuration performed, requires additional separate WatsonX Orchestrate SaaS instance
      
      Successfully created ConfigMap '000-client-onboarding-information' with same information as above
      ```

   2. In case you want to follow the execution of the Client Onboarding scenario deployment in detail, click on the **Pods** tab.
      <img src="images\ocp-deploy-job-created-pods.jpg" />

      From there click on the pod and switch to the **Logs** tab.
      
      <img src="images\ocp-deploy-job-created-pod-logs.jpg" />
      
      You can follow the progress of the deployment tool as it prints an overview of the actions it performs and their results to the console. 
      
      Once the deployment tool completes without a fatal error, it will output a status message that declares successful deployment of the Client Onboarding scenario. In addition, it provides key links and user names/passwords for you to use. These links/values are specific to your environment. 
      
      This is the same information, that is also available in the `000-client-onboarding-information` ConfigMap as shown above.



> [!NOTE]
>
> **If everything worked, you should now have a CP4BA 24.0.0 deployment with the Client Onboarding scenario deployed and are done!**



## Troubleshooting the Client Onboarding Deployment

In case of issues during the deployment of the Client Onboarding scenario, please refer to this [document](CloudPakDeployerViaJob_Troubleshooting.md) for tips how to proceed.



## Advanced Configuration Scenarios

Refer to this [document](CloudPakDeployerViaJob_Advanced.md) for advanced configuration scenarios like:

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