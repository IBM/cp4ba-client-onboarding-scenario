# Step 3 - Setup the RPA Server

**Note:** You only need to perform these steps if you want to demo the RPA execution. You can choose to skip the execution of the RPA bot when you import the Workflow solution.

1. Reserve an environment from [here](https://techzone.ibm.com/collection/cloud-pak-for-business-automation-cp4ba-rpa) using your IBMID.
   ![image-2021gitconnect](images/RPA-LandingPage.png)
2. Click **Environments** on the left panel, and then click **computer icon**.  
   ![image-2021gitconnect](images/RPA-Environments.png)
3. Click **Reserve for now**, then click **Submit**.  
   ![image-2021gitconnect](images/RPA-ReserveNow.png)
4. On the reservation page, make the appropriate selections as below. Once done, click **Submit**.  
   ![image-2021gitconnect](images/RPA-ReservationDetails.png)
5. Once you have reserved an environment, you will receive an email with a link to access the management console for the environment including a password (**Desktop Access Information**). It also contains a **URL to access the IBM RPA Rest Service remotely (Application Service Information)**, please copy the Application Service Information URL and change **HTTP** to **HTTPS**. This will be used in the Workflow solution.  
   ![image-2021gitconnect](images/RPA-ReservationEmail.png)
6. Click the **Desktop Access link** above to open your environment. When you are prompted to enter environment password, enter the desktop password above. Wait a few minutes, your environment will be started as below.  
   ![image-2021gitconnect](images/RPA-EnvironmentConsole.png)
7. Click **VM 5 – RPA** to open the RPA environment and check if RPA server and agent services are in running status.

Once you have setup the RPA server, [import the Workflow solution](Step%204%20-%20Workflow%20Solution.md).
