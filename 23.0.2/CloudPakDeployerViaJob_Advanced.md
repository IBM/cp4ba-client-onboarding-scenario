# Advanced configuration scenarios when deploying the Client Onboarding scenario into an Enterprise Deployment created by Cloud Pak Deployer using an OCP Job (for CP4BA 23.0.2 IF002 and above) 

## Introduction

> [!IMPORTANT]
>
> These instructions only apply in case you want to perform advanced configuration of an [OCP Job-based deployment](CloudPakDeployerViaJob.md) of the Client Onboarding scenario to a CP4BA 23.0.2 Enterprise deployment deployed by [**Cloud Pak Deployer**](CloudPakDeployerViaJob.md).



## Advanced Configuration Scenarios

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

### Performing the Workflow labs using business users (instead of or in addition to the admin user)

As part of the YAML to start the deployment, set the env variable `enableWorkflowLabsForBusinessUsers` to `true`.

This will extend the deployment time to about 45 minutes. This is due to the fact that the security settings for elements in two Content Service object stores need to be updated and the CPE pods need to be restarted twice due to other changes.

### Adding users/setting admin and/or regular user passwords during deployment

In case you want to create one or multiple users to have user names other than cpuser, cpuser1, cpuser2 or cpadmin and/or you want to set your own password for all users (cpuser, cpuser1, cpuser2), follow these steps:

1. Use the YAML file below instead of the one provided in step 4 of chapter [Import Instructions](CloudPakDeployerViaJob.md#import-instructions)
2. Modify the setting as described in step 4 of chapter [Import Instructions](CloudPakDeployerViaJob.md#import-instructions)
3. In addition, modify the first part of the YAML file, that is defining a ConfigMap called `client-onboarding-config`
   1. If you want to **add a single user**, modify the existing entry for user "Henry" to match your needs 
      - Ensure to update ALL properties like "dn", "cn", "sn", "uid", "mail"
      - Using the "members" array, you can add the new user to any of the pre-existing groups
      - Using the "roles" array, you can determine the Cloud Pak/Zen roles the user should get when onboarded to the Cloud Pak
   2. If you want to **add multiple users**, just duplicate the user definition, separating the entries by a comma, and make your modifications (again making sure to update all properties)
   3. If you **don't want to add users** **but modify the password of the regular users**, then either remove the whole "entities" array or set the attribute "enabled" of the existing entry to false
   4. If you want to **set the password for all regular users** (cpuser, cpuser1, cpuser2) to a value of your choice, add element "userPwd" with the password to be set on the same level as the "entities" attribute. (e.g. "userPwd": "password"). Be aware that all three users will get the same password

> [!IMPORTANT]
>
> If your CP4BA instance is not deployed into the namespace `cp4ba`, you need to modify the **2  (two)** locations where it is used to match your deployment namespace.


```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: client-onboarding-config
  namespace: cp4ba
data:
  AddUsersToPlatform.json: |
    {
        "comment": "Specify an array of users that should be added to the LDAP including their roles that will be assigned when onboarded to the Cloud Pak",
        "entities": [
           {
                "enabled": true,
                "type": "user",
                "dn": "uid=henry,ou=Users,dc=cp,dc=internal",
                "cn": "henry",
                "sn": "henry",
                "uid": "henry",
                "userPassword": "pwd",
                "homeDirectory": "/home/henry/",
                "mail": "henry@cp.internal",
                "members": [
                    {
                         "dn": "cn=cpusers,ou=Groups,dc=cp,dc=internal"
                    }
                ],
                "roles": [
                    "iaf-automation-admin",
                    "iaf-automation-developer"
                ]
            }
        ]
    }
---
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
        - name: client-onboarding-config
          configMap:
            name: client-onboarding-config
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
            echo 'Downloaded client onboarding deploy sh file';
            chmod u+x deployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh;
            ./deployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh --ocls `oc whoami --show-server=true` --oclt `oc whoami -t` --op '$(LOG_DIR)' --ns '$(NAMESPACE)' --cl '$(configureLabs)' --ewflbu '$(enableWorkflowLabsForBusinessUsers)' --cu '$(createUsers)' --rpau '$(rpaBotExecutionUser)' --rpas '$(rpaServer)' --pdmtoc '$(printDetailedMessageToConsole)';"]
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
            - name: createUsers
              value: "true"
            - name: rpaBotExecutionUser
              value: cp4admin2
            - name: rpaServer
              value: https://rpa-server.com:1111
            - name: printDetailedMessageToConsole
              value: "false"
          volumeMounts:
            - name: log-pvc
              mountPath: /logs/application
            - name: client-onboarding-config
              mountPath: /usr/client-onboarding/AddUsersToPlatform.json
              subPath: AddUsersToPlatform.json
      restartPolicy: Never
  backoffLimit: 2
```



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
> If your CP4BA instance is not deployed into the namespace `cp4ba`, you need to modify the **single** namespace location to match your deployment namespace.

> [!IMPORTANT]
>
> As part of the undeployment, resources are pulled from java.net, openshift.com, and github.com/githubusercontent.com. Therefore, your OCP environment needs to be connected to the Internet and these sites need to be reachable. 

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  generateName: client-onboarding-undeploy-
  namespace: cp4ba
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
            curl -sLO https://raw.githubusercontent.com/IBM/cp4ba-client-onboarding-scenario/main/$deploymentversion/Deployment_Automation/undeployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh;
            echo 'Downloaded client onboarding undeploy sh file';
            chmod u+x undeployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh;
            ./undeployClientOnboardingCloudPakDeployerEnterpriseWithGiteaParam.sh --ocls `oc whoami --show-server=true` --oclt `oc whoami -t` --op '$(LOG_DIR)' --ns '$(NAMESPACE)' --cCOLUD '$(cleanupClientOnboardingLabs_UserData)' --cCOL '$(cleanupClientOnboardingLabs)' --cCOS '$(cleanupClientOnboardingScenario)' --pdmtoc '$(printDetailedMessageToConsole)';"]
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
<img src="images\ocp-undeploy-job-created-inprogress.jpg"/>

2. **Follow the progress** of the undeployment using one of two methods:

   1. The easiest way is to **watch the job** created by importing the undeploy YAML, to get to the **Complete** (or Failed) state. 

      <img src="images\ocp-undeploy-job-created-complete.jpg" />

      > [!TIP]
      >
      > The ConfigMap named `client-onboarding-information` will only be deleted when `cleanupClientOnboardingScenario` is set to true.

   2. In case you want to follow the execution of the Client Onboarding scenario undeployment in detail, click on the **Pods** tab.
      <img src="images\ocp-undeploy-job-created-pods.jpg" />

      From there click on the pod and switch to the **Logs** tab.
      <img src="images\ocp-undeploy-job-created-pod-logs.jpg" />

      You can follow the progress of the deployment tool as it prints an overview of the actions it performs and their results to the console. 

      Once the deployment tool completes without a fatal error, it will output a status message that declares successful undeployment of the Client Onboarding scenario.

      <img src="images\ocp-undeploy-job-created-pod-logs-complete.jpg" />

3. **Troubleshooting undeploy errors**

   Please refer to the section **[Troubleshooting the Client Onboarding Deployment](CloudPakDeployerViaJob_Troubleshooting.md)** above for instructions on how to get to the log files created during undeployment.

## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.