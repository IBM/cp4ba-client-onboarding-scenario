# Step 4 - Import objects into FileNet Content Manager

### Pepare the environment for the end-to-end scenario

You can import the content objects via FileNet Deployment Manager OR create the objects manually.

To import the the content objects via FDM, use the exported zip here.

To create the objects manually, perform the following steps:

1. Login to ACCE.
2. Open the target object store.
3. Create a `Client Documents` folder under `Root folder`.
4. Create a `File Identification Event Action` using the following JavaScript.
5. For the `Identification` document class, add an event subscription `File Identification` and use the event action from the previous step.

### Prepare a shared environment for labs

If you imported the content objects via FDM and the shared users belong to the `cp4bausers` group, no further action is required. If you created the objects manually, or need to modify the access for another group of users, perform the following steps:

1. For the `Identification` document class, update the security.
2. For the `Client Document` document class, update the security.
3. For the `Client Documents` root folder, update the security.

Once you have imported the content objects to the target object store, create the automation mobile capture scenario.
