# Step 5 - Import objects into FileNet Content Manager

### Pepare the environment for the end-to-end scenario

Perform the following steps:

1. Login to ACCE.
2. Open the target object store, its name is `BAWTOS`.
3. Create a `Client Documents` folder under `Root folder`.
4. Create a `File Identification Event Action` using the below JavaScript.
   1. Open `Event, Action, Processes`. Right-click on `Event Actions` and select `New Event action` from context menu.
   2. Set the name to `File Identification Event Action`, click `Next`
   3. Select `Javascript`, click `Next`
   4. Paste the Javascript text into the text box, click `Next` then `Finish`.
6. For the `Identification` document class, add an event subscription `File Identification` and use the event action from the previous step.
   1. Open `Event, Action, Processes`. Right-click on `Subscriptions` and select `New Subscription` from context menu.
   2. Set the name to `File Identification Subscription`, click `Next`
   3. Set the class type to `Document`, and the class to `Identification`, click `Next` twice
   4. Select `Checkin Event` to trigger the subscription, click `Next`
   5. Set the event action to `File Identification Event Action`, click `Next`
   6. Click on `Enable Subclasses`, click `Next` and `Finish`

### Prepare a shared environment for labs

Perform the following steps:

1. For the `BAWTOS` object store, update the security for the cp4bausers group. Remove the right to `set owner of every object` from the group, as users with this right will automatically see every document in the object store.
2. For the `Identification` document class, update the security settings: remove the cp4bausers from the **Default Instance Security**. Update the **Security** and lower the access level for the cp4bausers group to `Modify properties`.
3. For the `Client Document` document class, update the security settings: remove the cp4bausers from the **Default Instance Security**. Update the **Security** and lower the access level for the cp4bausers group to `Modify properties`.


### Javascript for the File Identification Event Action

```
// ###############################################################################
// #
// # Licensed Materials - Property of IBM
// #
// # (C) Copyright IBM Corp. 2021. All Rights Reserved.
// #
// # US Government Users Restricted Rights - Use, duplication or
// # disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
// #
// ###############################################################################
importPackage(java.io);
importClass(java.lang.System);
importClass(java.lang.Integer);
importClass(Packages.com.filenet.api.engine.EventActionHandler);
importClass(Packages.com.filenet.api.util.Id);
importPackage(Packages.com.filenet.api.events);
importPackage(Packages.com.filenet.api.property);
importPackage(Packages.com.filenet.api.exception);
importPackage(Packages.com.filenet.api.core);
importPackage(Packages.com.filenet.api.constants);
importClass(Packages.com.filenet.api.query.SearchSQL);
importClass(Packages.com.filenet.api.query.SearchScope);
importClass(Packages.com.filenet.api.collection.IndependentObjectSet);

function onEvent(event, subscription) {
    // customize to some other string property symbolic name as needed
    var keyIdentifierName = "CO_ReferenceID";
    
    var os = event.getObjectStore();
    var id = event.get_SourceObjectId();

    // get document's key identifier value and net income which will be transfered into a case property
    var fe1 = new FilterElement(null, null, null, "Name " + keyIdentifierName, null);
    var pf = new PropertyFilter();
    pf.addIncludeProperty(fe1);

    var doc = Factory.Document.fetchInstance(os, id, pf);
    // TODO: It would be needed to find quote and other characters and handle properly, 
    // to prevent sql code injection attacks. This is Content Engine SQL though!
    var identifier = doc.getProperties().get(keyIdentifierName).getStringValue();
    
    // find case folder of same key identifier value
    var sqlStr = "SELECT [" + keyIdentifierName + "], [FolderName], [PathName], [CO_ClientName], [Id]" 
                + " FROM [CO_ClientOnboardingRequest] WHERE ([" 
                +   keyIdentifierName + "] = '" + identifier + "') AND ([CmAcmCaseState] < 3)";
    var sql = new SearchSQL(sqlStr);
    var ss = new SearchScope(os);
    var objectSet = ss.fetchObjects(sql, new Integer(1), null, null);
    var iter = objectSet.iterator();
    var count = 0;
    if (iter.hasNext()) {
        var folder = iter.next();
        
        // file the doc and save
        var drcr = folder.file(doc, AutoUniqueName.AUTO_UNIQUE,
                        doc.getProperties().getStringValue("Name"),
                        DefineSecurityParentage.DO_NOT_DEFINE_SECURITY_PARENTAGE);
        drcr.save(RefreshMode.NO_REFRESH);
        
        // Update Client Name property in the document. Need to load document again to prevent 
        // update sequence number errors.
        var clientName = folder.getProperties().get("CO_ClientName").getStringValue();
        var fe3 = new FilterElement(null, null, null, "Name CO_ClientName", null);
        var pf3 = new PropertyFilter();
        pf3.addIncludeProperty(fe3);
        var doc2 = Factory.Document.fetchInstance(os, id, pf3);
        doc2.getProperties().putValue("CO_ClientName", clientName);
        doc2.save(RefreshMode.NO_REFRESH);
    }
}

```
