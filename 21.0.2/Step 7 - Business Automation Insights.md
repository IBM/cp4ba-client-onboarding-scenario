# Step 7 - Import the Business Automation Insights data

### Pepare the environment for the end-to-end scenario

**Note:** The data is currently based on a Mortgage Application solution

1. Download the contents of the following directory - [Business Automation Insights](Solution%20Exports/Business%20Automation%20Insights).

2. From the folder where you've downloaded the files, run the following command to import Case data.

   (Replace `{esadmin}` with the elasticsearch admin user ID, replace `{espassword}` with the elastichsearch admin user password & replace `{eshost}` with the elasticsearch URL).

   ```
   curl -k -XPOST -H 'Content-Type: application/json' -u {esadmin}:{espassword} '{eshost}/_bulk' --data-binary @icmt.json
   ```

3. Run the following command to import BPM data:

   ```
   curl -k -XPOST -H 'Content-Type: application/json' -u {esadmin}:{espassword} '{eshost}/_bulk' --data-binary @processt.json
   ```

4. Open **Business Performance Center** and click **Import.**

> ![](images/BAI-1.png)

4.  Click **Browse.**

5.  Select **Mortgage Application Complete.json** (downloaded earlier) and click **Import**.

> ![](images/BAI-2.png)

### Prepare a shared environment for labs

1. Open **Business Performance Center**

2.	On **Mortgage Application Completed** dashboard select the **ellipses** and click **Set public**.

> ![](images/BAI-3.png)



### With that, you have successfully setup your environment with the Client Onboarding scenario.



