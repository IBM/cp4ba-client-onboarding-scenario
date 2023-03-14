# -- Under Construction --

# Jam-in-a-box for Business Automation

## Introduction

Use the Jam-in-a-box environments to demo the out-of-box end-to-end [Client Onboarding solution](https://github.com/IBM/cp4ba-client-onboarding-scenario), run your own mini-Tech Jam, or get self-educated on Business Automation.

Jam-in-a-box removes hurdles to Business Automation adoption through easing availability and sharing of technical enablement. Towards this it offers a set of self-provisionable environments hosted on IBM TechZone, combined with a set of [hands-on technical labs](https://github.com/IBM/cp4ba-labs/tree/main/22.0.1) spanning all capabilities of Business Automation.

## Use cases for Jam-in-a-box

### 1. Technical Enablement

1. Self-enablement - use the environment to gain hands-on experience on one or all capabilities of Business Automation using a realistic business scenario
2. Client-enablement - use the environment to host a mini-Tech-Jam for your clients

### 2. Demo/PoX

1. Demo - use out-of-box Client Onboarding to present a live demo of Business Automation capabilities
2. PoX - use the environments as a base to customize/extend the business scenario based on your client’s needs

## Table of Content

- **Software**

   - Infrastructure from TechZone (different labs use different environments, for details see below)
      - Managed Red Hat OpenShift (OCP 4.10) on IBM Cloud
      - IBM Cloud Pak for Business Automation 22.0.1 IF005
      - IBM Process Mining 1.13.2
      - IBM Robotic Process Automation 23.0.2

   - Solution (import required for one environment, for details see below)
      - Client Onboarding solution 
         (covering Automation Decision Services, Automation Document Processing, Workflow, Content, Robotic Process Automation, Business Automation Insights)

- **Assets**

   - [Nine hands-on labs](https://github.com/IBM/cp4ba-labs/tree/main/22.0.1)

      **Mapping of labs to environments**

      | Lab(s)                                                       | Environment (IBM TechZone - Business Partners and IBMers only) |
      | ------------------------------------------------------------ | ------------------------------------------------------------ |
      | [IBM Cloud Pak for Business Automation (End-to-End)](https://github.com/IBM/cp4ba-labs/blob/main/22.0.1/IBM%20Cloud%20Pak%20for%20Business%20Automation%20(End-to-End))<br/>[IBM Business Automation Application](https://github.com/IBM/cp4ba-labs/blob/main/22.0.1/Business%20Automation%20Application)<br/>[IBM Business Automation Insights](https://github.com/IBM/cp4ba-labs/blob/main/22.0.1/Business%20Automation%20Insights)<br/>[IBM FileNet Content Services](https://github.com/IBM/cp4ba-labs/blob/main/22.0.1/Content) (to be supported in 1Q)<br/>[IBM Automation Decision Services](https://github.com/IBM/cp4ba-labs/blob/main/22.0.1/Decisions)<br/>[IBM Business Automation Workflow](https://github.com/IBM/cp4ba-labs/blob/main/22.0.1/Workflow) | [Jam-in-a-box on CP4BA - V22.0.1 on Red Hat OpenShift on IBM Cloud](https://techzone.ibm.com/collection/jam-in-a-box-for-business-automation) (in case of client facing activity)<br/><br/>After successfully provisioning the environment<br/>follow the [instructions to deploy the Client Onboarding scenario](https://github.com/IBM/cp4ba-client-onboarding-scenario/blob/main/DeployingClientOnboarding.md)<br/>(Also see instructions in case you don't have access to/can't get a IBM TechZone environment) |
      | [IBM CP4BA - Bring-up Lab](https://github.com/IBM/cp4ba-labs/blob/main/22.0.1/Bring-up) | Follow the instructions provided on the respective [lab overview page](https://github.com/IBM/cp4ba-labs/tree/main/22.0.1/Bring-up) |
      | [IBM Process Mining](https://github.com/IBM/cp4ba-labs/blob/main/22.0.1/Process%20Mining) | Follow the instructions provided on the respective [lab overview page](https://github.com/IBM/cp4ba-labs/tree/main/22.0.1/Process%20Mining) |
      | [IBM Robotic Process Automation](https://github.com/IBM/cp4ba-labs/blob/main/22.0.1/Robotic Process%20Automation) | Follow the instructions provided on the respective [lab overview page](https://github.com/IBM/cp4ba-labs/tree/main/22.0.1/Robotic%20Process%20Automation) |

   - [All artifacts](https://github.com/IBM/cp4ba-client-onboarding-scenario) for the client onboarding scenario including deployment automation to quickly and easily deploy them


## Support

We aim to support successfully utilizing our Jam-in-a-box.

**Business Partners and IBMers**
To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**IBMers**
Alternatively, if you think you need more than support for the Jam-in-a-box content, you can always submit a SWAT request against Business Automation using this [link](http://ibm.biz/automation-swat).

**All others**
Open a new issue in this GitHub

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.