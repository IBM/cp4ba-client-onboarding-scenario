# Step 7 - Import the Business Automation Insights data

### Pepare the environment for the end-to-end scenario

1. Download the contents of the following directory - [Business Automation Insights](Solution%20Exports/Business%20Automation%20Insights).

2. Replace the index names in the downloaded files:

   In the `process-data.json`, `case-data.json` and `ads-data.json` files, the index name parameter must match the index names of your environment. The index names contains a suffix that is dependent on the date of the install. 

   For example, one of the index names in the provided data files is `icp4ba-bai-process-summaries-completed-idx-ibm-bai-$TIMESTAMP$`. The string `$TIMESTAMP$` must be replaced by the suffix in your environment's index. 

   You can get the index names for your environment using the following command (Replace `{esadmin}` with the elasticsearch admin user ID, replace `{espassword}` with the elastichsearch admin user password & replace `{eshost}` with the elasticsearch URL):
   ```
   curl -k -XGET -u {esadmin}:{espassword} '{eshost}/_aliases'
   ```

   In the JSON output, you will see the suffix for the index names. For example, if the index name is in your environment is `icp4ba-bai-process-summaries-completed-idx-ibm-bai-2022.05.24-000001`, then the suffix is `2022.05.24-000001`. In the downloaded files (`process-data.json` and `case-data.json`), replace the string `$TIMESTAMP$` by the suffix of your environment.

3. From the folder where you've downloaded the files and replaced the index names, run the following script to import the data (replace `{esadmin}` with the elasticsearch admin user ID, replace `{espassword}` with the elastichsearch admin user password & replace `{eshost}` with the elasticsearch URL):

   ```
   ES_ADMIN={esadmin}
   ES_PASSWORD={espassword}
   ES_HOST={eshost}
   
   curl -k -XPOST -H 'Content-Type: application/json' -u ${ES_ADMIN}:${ES_PASSWORD} ${ES_HOST}/_bulk --data-binary @case-data.json
   curl -k -XPOST -H 'Content-Type: application/json' -u ${ES_ADMIN}:${ES_PASSWORD} ${ES_HOST}/_bulk --data-binary @process-data.json
   curl -k -XPOST -H 'Content-Type: application/json' -u ${ES_ADMIN}:${ES_PASSWORD} ${ES_HOST}/_bulk --data-binary @ads-data.json
   ```

4. Open **Business Performance Center** and click **Import.**

   ![](images/BAI-1.png)

5. Click **Browse.**

6. Select **Client Onboarding Completed.json** (downloaded earlier) and click **Import**.

   ![](images/BAI-2.png)

#### Create and configure goals

1. Open **Business Perfomance Center**

2. Click on the **Goals** tab

   ![](images/BAI-goals.png)

3. Click **Create**

   ![](images/BAI-create-goal.png)

4. For Name enter **Focus Corp's top Client Onboarding KPI Completed**

5. For Description enter **Focus on the three top KPI identified by senior management team**

6. For Priority select **High**

7. Click Goal color to **Purple**

8. Your Goal definition should look exactly like this:

   ![](images/BAI-goal-definition.png)

9. Click **Save**

10. Click on the **Dashboards** tab

11. Open the **Client Onboarding Completed** dashboard

12. For the **Average Revenue from Services Fees for Approved Clients** visualization, click on the **Edit** icon.

    ![](images/BAI-add-goal-to-viz.png)

13. For the **Business goal** field, select **Focus Corp's top Client Onboarding KPI** from the drop-down list

    ![](images/BAI-select-goal.png)

14. Click **Done**

15. Repeat steps 11-14 to add the same goal to the **Highest Service Fee by Industry Sector** visualization

    ![](images/BAI-goal-completed.png)

### Prepare a shared environment for labs

1. Open **Business Performance Center**

2. On **Client Onboarding Completed** dashboard select the **3-dot menu** and click **Share with everyone**.

   ![](images/BAI-3.png)



### With that, you have successfully setup your environment with the Client Onboarding scenario.



