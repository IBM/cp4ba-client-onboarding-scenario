# Step 5 - Import the Workflow Solution

### Pepare the environment for the end-to-end scenario

1. Download the [Workflow twx file](Solution%20Exports/Business%20Automation%20Workflow/Client_Onboarding.twx).

2. Login to **IBM Business Automation Studio**

3. In the top-right corner, click on the menu icon and go to **Business automations**.

   ![wf-studio-automations](images/wf-studio-automations.png)

4. Click on **Workflow**.

   ![wf-workflow-option](images/wf-workflow-option.png)

5. Click on the **Import** button.

6. Click on **Browse** and select the twx file downloaded in Step 1. 

7. Click on OK.

8. Once the import completes, click on tile for the **Client Onboarding** Workflow project (Don't click on the open button but just the tile).

9. Click on the 3-dot menu next to the Open button on the right and select **Open in Process Designer**

   ![wf-open-in-pd](images/wf-open-in-pd.png)

   Note: The version numbers and dates in the screenshots maybe different from what you see in your system

10. In Process Designer, click on the **Environment Variables** tab.

11. Fill out credentials for a gmail account in the **emailID** and **emailPassword** fields under the **Default** column. Note that the password here must be an [App Password](https://support.google.com/accounts/answer/185833?hl=en) and not your gmail password. 

    ![wf-env-variables](images/wf-env-variables.png)

12. If you are showcasing ADP as a part of the scenario, enter the ADP host, username, password, and projectID in their respective fields. If you are not, set **adpEnabled** to false.

13. For the **documentUploadPage** environment variable, enter the URL for the navigator admin and replace the `admin` at the end with `CODocumentUpload`. You will add this desktop to the navigator in a later step.

14. The RPA bot is currently only executed if the user running the scenario matches the **rpaBotExecutionUser**. You can change this by updating the value of the **rpaBotExecutionUser** environment variable.

15. If you are executing the RPA bot, update the value for the **rpaServer** environment variable from the environment you reserved using the previous step.

16. The default target object store name is **BAWTOS**. If you have changed this, update the value for the **tosName** environment variable. Demo environments have the default target object store name of **TARGET**.

17. In the top-right corner, click on the **Finish Editing** button.

    ![wf-finish-editing](images/wf-finish-editing.png)

18. In the top-left corner, click on **Business automations** to go back to the BA Studio.

    ![wf-back-to-studio](images/wf-back-to-studio.png)

19. Click on **Open** for the **Client Onboarding** Workflow automation project to open it in the Case Builder.

    ![wf-co-open](images/wf-co-open.png)

20. In the top-right corner, click on the **Deploy** button. The deployment will take a few seconds. Wait until there is a green checkmark next to the button.

    ![wf-deploy-solution](images/wf-deploy-solution.png)

21. In the top-left corner, click on **Automations** to go back to the BA Studio.

    ![wf-case-builder-automations](images/wf-case-builder-automations.png)

22. Click on the tile for the **Client Onboarding** Workflow automation project.

23. Click on the 3-dot menu for latest version of the project and click on **Publish**.

    ![wf-publish](images/wf-publish.png)

24. Close the dialog that shows that the automation services were published successfully.

25. In the top-left corner, click on the menu icon and go to **Design** --> **Business automations**.

26. Click on **Create** --> **External**.

27. Select **Business Automation Workflow** under **Select the connection type**.

28. Click on **Next**.

29. In the **Connection name** field, enter **External BAW System**.

30. In the **System URL** field, enter the host name of the BAW server (you can take the URL to Process Admin or Process Portal and remove the `/ProcessAdmin` or `/ProcessPortal` suffix from the URL)

31. Enter the admin credentials and click **Next**.

32. In the **Select a process application** dropdown, select **Client Onboarding**.

33. Select the checkbox for **New Client Onboarding Request**.

    ![studio-external-aut-service](images/studio-external-aut-service.png)

34. Click on **Next**.

35. In the **Name** field, enter **Client_Onboarding_Workflows_External**.

36. Click on **Publish**.

### Prepare a shared environment for labs

1. In BA Studio, within Business Automations --> Workflow, click on **Toolkits**.

   ![wf-toolkits](images/wf-toolkits.png)

2. Click on the tile for the **Client Onboarding Toolkit** toolkit.

3. Click on the **Collaborators** tab.

4. Click on the **Add** button.

   ![wf-add-group](images/wf-add-group.png)

5. Select the **Group** radio button.

6. Search for the group that contains your shared users (eg: cp4bausers) and select the checkbox for the result.

   ![wf-add-cp4bausers](images/wf-add-cp4bausers.png)

7. Click on the **Add** button to close the dialog.

Once you have imported the Workflow solution, [import the required objects in Filenet Content Manager](Step%206%20-%20Content%20Manager.md).

