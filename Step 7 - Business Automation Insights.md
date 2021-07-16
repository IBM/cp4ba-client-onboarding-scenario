# Step 7 - Import the Business Automation Insights data

### Pepare the environment for the end-to-end scenario

**Note:** The data is currently based on a Mortgage Application solution

1. Run the following command to import Case data (replace `{esadmin}` with the elasticsearch admin user ID, replace `{espassword}` with the elastichsearch admin user password & replace `{eshost}` with the elasticsearch URL).

   ```
   curl -k -XPOST -H 'Content-Type: application/json' -u {esadmin}:{espassword} '{eshost}/_bulk' --data-binary @icmt.json
   ```

2. Run the following command to import BPM data:

   ```
   curl -k -XPOST -H 'Content-Type: application/json' -u {esadmin}:{espassword} '{eshost}/_bulk' --data-binary @processt.json
   ```
3.  Open IBM Cloud Pal for Business Automation - Business Automation Insights and click **Import.**

> ![](images/BAI-1.png){width="6.768055555555556in" height="1.9381944444444446in"}

4.  Click **Browse.**

5.  Select **Mortgage Application Complete.json** and click Import.

> ![](images/BAI-2.png){width="5.135416666666667in" height="2.0729254155730534in"}

6.  Optionally follow the instruction in **Lab Guide - Operational Intelligence - BAI - Build Business Performance Center Dashboard.pdf** to add and configure Goals.

 

### Prepare a shared environment for labs

1. In Business Performance Center, change the permissions of the Mortgage Application dashboard from private to public.

With that, you have successfully setup your lab for the end-to-end and preapred a shared environment for the CP4BA labs.



