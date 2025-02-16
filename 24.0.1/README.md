# Deploying the Client Onboarding scenario (for CP4BA 24.0.1)

## Introduction

The Client Onboarding scenario and its accompanying labs consist of a large set of artifacts with interdependencies. To deploy them, a deployment automation tool is used.

Depending on the target deployment environment (Starter vs. Enterprise deployment, Enterprise: Rapid Deployment Scripts LDAP with Gitea, Cloud Pak Deployer, Custom with arbitrary LDAP and external GitHub), the tool requires different configuration settings.

Choose the environment type and deployment approach below, that best matches your target environment and proceed as described in the linked document.

> [!NOTE]
>
> Depending on the target environment one or two deployment approaches exist:
>
> 1. (New and recommended) Using an OpenShift Job - Does not require a separate deployment machine with Java installed
> 2. (Traditional) Using a separate deployment machine with Java installed
>
> When available, using the OpenShift Job approach is recommended, as there is no additional requirement other than having a CP4BA 24.0.1 cluster.


## Target Deployment Type

1. **Starter Deployment**
   - Using an [OpenShift Job](StarterDeploymentViaJob.md) - **Recommended**
   - Using a [separate machine](StarterDeploymentSeparateMachine.md) to run the deployment from
2. **Enterprise Deployment**
   1. **Deployed by Cloud Pak Deployer**
      - Using an [OpenShift Job](CloudPakDeployerViaJob.md) - **Recommended**
      - Using a [separate machine](CloudPakDeployerSeparateMachine.md) to run the deployment from
   2. **Deployed using LDAP content as defined by Rapid Deployment Scripts** ([predefined.ldif & cp4ba.ldif](https://github.com/IBM/cp4ba-rapid-deployment/blob/main/cp4ba-21-0-3/03createVMForLDAP.md)) **with a co-deployed Gitea**
      - Using a separate machine to run the deployment from
   3. **Deployed using an arbitrary LDAP and an external GitHub**
      - Using a separate machine to run the deployment from

## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-ba-dl](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.