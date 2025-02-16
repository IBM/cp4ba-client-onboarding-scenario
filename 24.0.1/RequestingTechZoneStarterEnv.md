# Requesting a CP4BA 24.0.1 Starter deployment from IBM TechZone

> [!WARNING]
>
> Currently no CP4BA 24.0.1 Starter deployment pattern is available from TechZone. Hopefully to be added soon.

## Introduction

This document describes the steps required to request a CP4BA 24.0.1 Starter deployment environment from iBM Technology Zone (for short IBM TechZone), that is suitable to deploy the Client Onboarding scenario to.

## Reserving an IBM TechZone environment

Reserve a Business Automation environment from IBM TechZone. For that select the **CP4BA 24.0.0 - OCPv** tile from the [this page](https://techzone.ibm.com/collection/tech-zone-certified-base-images/journey-pre-installed-software).

Provide and select the required information. The selection you make for 'Purpose' determines if you need to specify a 'Sales Opportunity number' and the 'reservation policy' (how long the environment is available and how often it can be extended).

<img src="images\techzone-reservation_2401_starter.jpg" />

Once you have reserved an environment in IBM TechZone, it is first **Scheduled** for provisioning. After a while it moves into status **Provisioning**, and after about 2-3 hours it finally becomes **Ready**. You will receive an email when provisioning starts and a second email with the subject '**Reservation Ready on IBM Technology Zone**' when it completes. 

> [!WARNING]
>
> Ready in this case only means that OpenShift has been provisioned and that deploying Cloud Pak for Business Automation has been started but **not** that it is deployed yet. This may take another 3-4 hours to complete. 

There are no additional emails being sent. You need to periodically check if the deployment completed successfully. To do perform the following steps:

1. Click on the link '**View My Reservations**' at the bottom of the email to get to your reservations. Then click on the tile that represents your reservation.

<img src="images\your-environment-is-ready_2401_starter.jpg" />

2. Towards the top of the screen you will find the **link to the OpenShift console**, the **Username** (which is always **kubeadmin**) to log into the OpenShift console, and the unique **Password** for the environment.
   Click the link and login with the credentials for your reservation.
      <img src="images\techzone-reserved-env_2401_starter.jpg" />

3. Click on **Pipelines** -> **Pipelines** on the left hand side and then on **PipelineRuns** on the right hand side. Make sure that **All Projects** is selected as Project.
   <img src="images\techzone-pipelineruns-2401_starter.jpg" />
4. When the deployment completed successfully, the **Status** of the pipeline run is **Succeeded** with the Task status bar solid green. When it is still in progress come back later.
5. For details about how to access the different parts of the Cloud Pak and the admin credentials click on **Workloads** -> **ConfigMaps** on the left. Type **access-info** next to the name field to filter the list of ConfigMaps down to **icp4adeploy-cp4ba-access-info**.
   <img src="images\techzone-configmaps-2401_starter.jpg" />techzone-



## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.