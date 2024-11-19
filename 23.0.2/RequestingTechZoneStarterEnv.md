# Requesting a CP4BA 23.0.2 Starter deployment from IBM TechZone

## Introduction

This document describes the steps required to request a CP4BA 23.0.2 Starter deployment environment, that is suitable to deploy the Client Onboarding scenario to.

## Reserving an IBM TechZone environment

Reserve a Business Automation environment from IBM TechZone. For that select the **CP4BA 23.0.x - Multi-Pattern Starter** tile from the [Pre-Installed Software](https://techzone.ibm.com/collection/tech-zone-certified-base-images/journey-pre-installed-software) tab.

Provide and select the required information. The selection you make for 'Purpose' determines if you need to specify a 'Sales Opportunity number' and the 'reservation policy' (how long the environment is available and how often it can be extended).

<img src="images\techzone-reservation_2302_starter.jpg" />

Once you have reserved an environment in IBM TechZone, it is first **Scheduled** for provisioning. After a while it moves into status **Provisioning**, and after about 2-3 hours it finally becomes **Ready**. You will receive an email when provisioning starts and a second email with the subject '**Reservation Ready on IBM Technology Zone**' when it completes. 

> [!WARNING]
>
> Ready in this case only means that OpenShift has been provisioned and that deploying Cloud Pak for Business Automation has been started but **not** that it is fully deployed yet. This may take another 4-5 hours to complete. 
> See below for how to check that CP4BA has been successfully deployed.

The final email contains a link '**View My Reservations**' to get to your reservations. Click on this link and click on the tile that represents your reservation.

<img src="images\your-environment-is-ready_2302_starter.jpg" />

Towards the top of the screen you will find the **link to the OpenShift console**, the **Username** (which is always **kubeadmin**) to log into the OpenShift console, and the unique **Password** for the environment.

   <img src="images\techzone-reserved-env_2302_starter.jpg" />



## Support

**Business Partners (may require an invitation) and IBMers** 

To engage us, drop us a message at [#jam-in-a-box-business-automation](https://ibm-cloudpak-partners.slack.com/archives/C04SMFNLA3T).

**All others**

Open a new issue in this GitHub.

## Disclaimer

The information, tools, and artifacts describes and linked are provided AS-IS and without any warranty. Please also refer to the license that is part of this repository for details.