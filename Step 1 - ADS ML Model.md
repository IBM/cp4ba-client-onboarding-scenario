# Step 1 - Import the ADS ML Model

1. Open the ADS ML Service (Open Prediction Service) in your browser

2. Under `manage`, expand the `/models` section

   ![image-20210601220850676](/images/ads-ml-service-add-model.png)

3. Click on `Try it out`

4. Use the contents of the addModel.json file as the request body

5. Click on `Execute`

6. Copy the ID of the created model in the response.

7. Under `manage`, expand the `/models/{model_id}` section

   ![image-20210601221731687](/images/ads-ml-service-add-model-binary.png)

8. Click on `Try it out`

9. Use the ID copied from the last API call

10. In the request body, keep `pickle` selected as the `format` 

11. Download this [pickle file](/Solution%20Exports/ADS/ML/service-payment-default-risk-v0-archive.pkl) onto your computer and use it as as the selected file

12. Click on `Execute`

13. Under `run`, expand the `/predictions` section

14. Click on `Try it out`

15. Use the contents of the runModel.json file as the request body

16. Update the `{DECISION-ID}` in the json to the `ID` copied before

17. Click on `Execute`. The result should be as follows:

    `{ "result": {  "predictions": 0,  "scores": [   0.9068544064724676,   0.0931455935275324  ]}}`

Once you have imported the ADS ML Service, you will need to import the ADS Project in IBM Business Automation Studio.
