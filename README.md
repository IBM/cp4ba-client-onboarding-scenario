# Client Onboarding Scenario

## Introduction

The client onboarding scenario is an end-to-end solution that showcases the art of the possible with IBM Cloud Pak for Business Automation (CP4BA). You can see the end-to-end in action with this [pre-recorded video](http://ibm.biz/cp4ba-overview-video).

## Prerequisites

1. A CP4BA environment. You have the following options to access an evnironment:
   - Use a [Jam-in-a-box](https://techzone.ibm.com/collection/jam-in-a-box-for-business-automation) environment: This is a starter deployment of Cloud Pak for Business Automation which lets you reserve your own cluster and deploy the Client Onboarding solution to it automatically. The latest deployment instructions are available [here](https://github.com/IBM/cp4ba-client-onboarding-scenario/blob/main/22.0.2/DeployingClientOnboarding2202.md)
   - Create a new cluster on IBM Cloud using ROKS using the SWAT team's [rapid deployment scripts](https://github.com/IBM/cp4ba-rapid-deployment).
   - Use your existing enterprise cluster with the following patterns: foundation, decisions_ads, application, document_processing, workflow and content. Prior to v22.0.1, you also need to install [Open Prediction Service](https://github.com/IBM/open-prediction-service-hub/tree/main/ops-implementations/ads-ml-service) to execute some of the AI capabilities of the scenario.
2. A Gmail account (if you are not using a Jam-in-a-box environment): The end-to-end uses a Gmail SMTP server today to send out an email. For the credentials, you will need to create an [App Password](https://support.google.com/accounts/answer/185833?hl=en) which you will need later in the instructions.

## Import Instructions

Instructions to import the Client Onboarding solution are available for the following CP4BA versions:

- [CP4BA v21.0.1](/21.0.1)
- [CP4BA v21.0.2](/21.0.2)
- [CP4BA v21.0.3](/21.0.3)
- [CP4BA v22.0.1](/22.0.1)
- [CP4BA v22.0.2](https://github.com/IBM/cp4ba-client-onboarding-scenario/blob/main/22.0.2/DeployingClientOnboarding2202.md)

Once you have imported the Client Onboarding scenario successfully, you can perform the [IBM Cloud Pak for Business Automation labs](https://github.com/IBM/cp4ba-labs).

## Support

IBMers can use this IBM internal Slack channel: [#dba-swat-asset-qna](**https://ibm-cloud.slack.com/archives/C026TD1SGCA**); everyone else can open a new issue in this github. 



