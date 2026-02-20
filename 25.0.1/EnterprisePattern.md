# Deploying the Client Onboarding scenario an Enterprise Pattern Deployment Environment (for CP4BA 25.0.1)

## Introduction

To deploy the Client Onboarding scenario to a Cloud Pak for Business Automation (CP4BA) 25.0.1 **Enterprise** Deployment environment is supported for various types of Enterprise pattern configurations.

Such an environment at minimum needs the following capabilities : Business Applications, Automation Decision Services, Workflow, Business  Automation Insights, and optionally Automation Document Processing.

This document outlines the different types and approaches to deploy the Client Onboarding scenario to an Enterprise pattern environment.

## Deployment Type Selection

The table contains all supported deployment types with increasing complexity from top to bottom. 

| Deployment Type                                              | Instructions                                                 | Comments                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Cloud Pak Deployer](https://ibm.github.io/cloud-pak-deployer/) Enterprise Deployment specifically for [CP4BA](https://ibm.github.io/cloud-pak-deployer/30-reference/configuration/cp4ba/). | Follow instructions [here](CloudPakDeployerViaJob.md).       | Least number of config options to fill as most information is known. |
| [Rapid Deployment scripts](https://github.com/IBM/cp4ba-rapid-deployment) Enterprise Deployment (not yet available for CP4BA 25.0.1) or at least using the [LDIF](https://github.com/IBM/cp4ba-rapid-deployment/blob/main/cp4ba-21-0-3/scripts/predefined.ldif) with co-deployed Gitea. | Follow instructions [here](RapidDeploymentLDAPandGiteab.md). | Some additional config options like passwords need to be provided. |
| Enterprise Deployment with custom LDAP and co-deployed Gitea. | Follow instructions [here](ArbitraryLDAPExternalGitHub.md).  | Additional configuration options for the admin user and user groups need to be specified. |
| Enterprise Deployment with custom LDAP and external GitHub.  | Follow instructions [here](ArbitraryLDAPExternalGitHub.md).  | All configuration options need to be specified as fully custom. |

## Support

**Business Partners and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-ba-dl](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.