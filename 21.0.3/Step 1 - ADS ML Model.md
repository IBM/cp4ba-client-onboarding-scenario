# Step 1 - Import the ADS ML Model

1. Open the ADS ML Service (Open Prediction Service) in your browser

2. Under `manage`, expand the `POST /models Add Model` section

   ![image-20210601220850676](images/ads-ml-service-add-model.png)

3. Click on `Try it out`

4. Use the contents of the [addModel.json](Solution%20Exports/Automation%20Decision%20Services/ML/addModel.json) file as the request body

5. Click on `Execute`

6. Copy the ID of the created model from the response body. It is usually `1`.

  ![image-2021ID](images/ads-ml-model-id.png)

7. Under `manage`, expand the `POST /models/{model_id} Add Binary` section

   ![image-20210601221731687](images/ads-ml-service-add-model-binary.png)

8. Click on `Try it out`

9. Use the ID copied from the last API call

10. In the request body, keep `pickle` selected as the `format` 

11. Download this [pickle file](Solution%20Exports/Automation%20Decision%20Services/ML/service-payment-default-risk-v0-archive.pkl) onto your computer and use it as as the selected file

 ![image-2021Binary](images/ads-ml-add-binary.png)

12. Click on `Execute`. The response code is 201. The model named `service-payment-default-risk` is succesfully deployed. 
The following instructions validate that this deployment can be safely executed.

13. Under `run`, expand the `/predictions` section

14. Click on `Try it out`

15. Use the contents of the [runModel.json](Solution%20Exports/Automation%20Decision%20Services/ML/runModel.json) file as the request body

16. Update the `$PREDICTION-ID$` in the json to the `ID` copied before

17. Click on `Execute`. The result should be as follows:

    `{ "result": {  "predictions": 0,  "scores": [   0.9068544064724676,   0.0931455935275324  ]}}`

 ![image-2021Check](images/ads-ml-check.png)


Once you have imported the ADS ML Service, you will need to [import the ADS Project in IBM Business Automation Studio](Step%202%20-%20ADS%20Project.md).

