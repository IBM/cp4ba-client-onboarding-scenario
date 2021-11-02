# Step 5 - Import objects into FileNet Content Manager

### Pepare the environment for the end-to-end scenario

Perform the following steps:

1. Login to ACCE. You can switch to english locale if needed by clicking on the persona icon in upper right corner, and select `Change Language and Locale Settings`.

2. Open the target object store, its name is `BAWTOS`, by clicking on it.
   <br/><img src="images/content-open-bawtos.png" />
   
3. Create a new folder named `Client Documents` under the root folder.
   1. On the navigation area on the left side, open `Browse` and click on `Root folder`.
      <br/><img src="images/content-open-rootfolder.png" />
   2. Click on the `Actions` pulldown menu and click on `New Folder`.
      <br/><img src="images/content-create-folder.png" />
   3. The `Define New Folders Dialog` opens on the right side. Set the Folder name to `Client Documents`. Then click on `Next >` two times, then on `Finish`.
      <br/><img src="images/content-create-client-documents.png" />
   
4. In the `Client Documents` folder, create the documents from the table below:
   
   | Document                                                     | Document Title | Document Class  | Document Properties                                          |
   | ------------------------------------------------------------ | -------------- | --------------- | ------------------------------------------------------------ |
   | [Banking Information - Automation Elite Inc.pdf](Solution%20Exports/FileNet%20Content%20Manager/Client%20Documents/Banking%20Information%20-%20Automation%20Elite%20Inc.pdf) | Banking Information - Automation Elite Inc | Client Document | Client Name: Automation Elite Inc.                           |
   | [Certificate of Incorporation - Automation Elite Inc.pdf](Solution%20Exports/FileNet%20Content%20Manager/Client%20Documents/Certificate%20of%20Incorporation%20-%20Automation%20Elite%20Inc.pdf) | Certificate of Incorporation - Automation Elite Inc | Client Document | Client Name: Automation Elite Inc.                           |
   | [June Marie - Driver's License.png](Solution%20Exports/FileNet%20Content%20Manager/Client%20Documents/June%20Marie%20-%20Driver's%20License.png) | June Marie - Driver's License | Identification  | Client Name: Automation Elite Inc.<br />Identification Number: S 100 100 100 100<br />First Name: June Marie<br />Last Name: Sample |
   | [Legacy Consulting - Banking Information.pdf](Solution%20Exports/FileNet%20Content%20Manager/Client%20Documents/Legacy%20Consulting%20-%20Banking%20Information.pdf) | Legacy Consulting - Banking Information | Client Document | Client Name: Legacy Consulting                               |
   | [Legacy Consulting - Certificate of Incorporation.pdf](Solution%20Exports/FileNet%20Content%20Manager/Client%20Documents/Legacy%20Consulting%20-%20Certificate%20of%20Incorporation.pdf) | Legacy Consulting - Certificate of Incorporation | Client Document | Client Name: Legacy Consulting                               |
   
   1. In the navigation area, navigate to "Browse", and "Root Folder". Click on "Client Documents" to bring up the contents of the folder. From the opened "Client Documents" folder, invoke "New Document" from the Actions pulldown menu.
      <br/><img src="images/content-createdocs1.png" />
   2. In the New Document wizard, on the first page provide the document title, and select the Document Class from the table. Then click "Next".
      <br/><img src="images/content-createdocs2.png" />
   3. On the "Document Content Source" page, click on "Add" in the "Content Element" section. Use the popup window to upload the document. Click "Browse" and locate the document on your harddisk, then click on "Add Content" to close the dialog. Then click "Next" on the "New Document" wizard.
      <br/><img src="images/content-createdocs3.png" />
   4. On the next page, provide the property values, according to the table above. No further changes are required, so press "Next" until the final page, then "Finish" and then "Close".
   
   
   
5. Create a `File Identification Event Action` using the below JavaScript.

   1. Open `Event, Actions, Processes`. Right-click on `Event Actions` and select `New Event action` from context menu.
      <br/><img src="images/content-create-eventaction.png" />
   2. The Name and Describe the Event Action dialog opens on the right. Set the name to `File Identification Event Action`, click `Next >`
      <br/><img src="images/content-event-action-name.png"/>
   3. Select `Javascript`, click `Next >`
      <br/><img src="images/content-event-action-javascript.png" />
   4. Mark all text in the `Event Action Script` text box and remove it. Paste the Javascript text from contents of [File Identification Event Action.js](Solution%20Exports/FileNet%20Content%20Manager/File%20Identification%20Event%20Action.js) into the `Event Action Script`text box, then click `Next >` then `Finish`.
      <br/><img src="images/content-event-action-script.png" />

6. For the `Identification` document class, add an event subscription `File Identification` and use the event action from the previous step.
   1. Open `Event, Actions, Processes`. Right-click on `Subscriptions` and select `New Subscription` from context menu.
      <br/><img src="images/content-subscription1.png"/>
   2. Set the name to `File Identification Subscription`, click `Next >`
      <br/><img src="images/content-subscription2.png"/>   
   3. Set the class type to `Document`, and the class to `Identification`, click `Next >` twice
      <br/><img src="images/content-subscription3.png"/> 
   4. Select `Checkin Event` to trigger the subscription, click `Next >`
      <br/><img src="images/content-subscription4.png"/>  
   5. Set the event action to `File Identification Event Action`, click `Next >`
      <br/><img src="images/content-subscription5.png"/>
   6. Click on `Include Subclasses`, click `Next` and `Finish`
      <br/><img src="images/content-subscription6.png"/>

### Prepare a shared environment for labs

If you are using an environment that will be shared by multiple users, it is important to disable certain permissions so that the objects defined for the Client Onboarding scenario are immuatable. Perform the following steps:

1. For the `Identification` document class, update the security settings: remove the shared group (eg: cp4bausers) from the **Default Instance Security**. Update the **Security** and lower the access level for the cp4bausers group to `Modify properties`.
   1. On the Navigation area on the left side, open `Data Design`, `Classes`, `Document` and click on the `Identification` class to bring up its properties on the right side.
      <br/><img src="images/content-security-id1.png"/>
   2. Select the `Default Instance Security` tab. Select the checkbox in front of the line with the shared user group (eg: cp4bausers) group and click on `Remove`. Then click on `Save`.
      <br/><img src="images/content-security-id2.png"/>
   3. Select the `Security` tab. Select the checkbox in front of the line with the shared user group (eg: cp4bausers) and click on `Edit...`. In the dialog, set the permission group to `Modify properties`, then click on `Ok`. Click on `Save` again on the `Identification` class properties.
      <br/><img src="images/content-security-id3.png"/>
2. For the `Client Document` document class, update the security settings: remove the shared user group (eg: cp4bausers) from the **Default Instance Security**. Update the **Security** and lower the access level for the cp4bausers group to `Modify properties`. Follow the same steps as before, just replace `Identification` class by `Client Document` class.

With that, you have successfully imported the objects required for the solution into Filenet Content Manager. Next, [import the Business Automation Application into IBM Business Automation Navigator](Step%206%20-%20Business%20Automation%20Application.md).
