# My_first_project
This is my first project to be published on github

## Use Case

- Objective statement :
  - Get insight from "boston.csv" data about how much the prices for a house on those housing area based on several factors that related
  - To reduce risk in deciding the amount of money to be spend on a house from boston housing agency

- Analytic Technique :
  - Regularized Regression Analysis Using Ridge and Lasso Models
  - Heatmap Correlation Analysis

- Expected Outcome:
  - Get the prediction about house pricing from boston housing agency, so we can make more efficient decision to spend money for a house in boston

## Data Understanding

Each record in the database describes a Boston suburb or town which consist of some features, such :
- Criminal rate (crim)
- Residential land zoned proportion (zn)
- Non-retail business acres proportion (indus)
- Is bounds with river (chas)
- Nitrogen oxides concentration (nox)
- Number rooms average (rm)
- Owner age proportion (age)
- Weighted distance to cities (dis)
- Accessibillity index (rad)
- Tax rate (tax)
- Pupil-teacher ratio (ptratio)
- Black proportion (black)
- Percent lower status (lstat)

## Data preparation

- Codes were simulated on Rstudio
- Packages :
  - ggplot2
  - caTools
  - car
  - psych
  - dplyr
  - glmnet

## Data Splitting

- Data would be splitted into train, validation, and test

## Exploratory Data Analysis

- How do we know if our features in data set did'nt have multicollinearity?

![WhatsApp Image 2022-02-22 at 19 52 03](https://user-images.githubusercontent.com/95845867/155504596-f550f1d8-a1c5-4a84-bc4f-9312f05f15ca.jpeg)

Using the pair plot (heatmap) on top of training data so we can make sure which one of these features having tight correlation each other. Based on the heatmap, we are informed that 'rad' feature and 'tax' feature are correlated each other. In order to solve multicollinearity from this data set, we will delete 'tax' feature from our data set, because this feature has low impact on our objective function (medv) to predicting house pricing, Which is showed by having lower correlation number than 'rad' feature on our objective function.

## Modeling Data : Ridge regression

- In this part, training data will be used to ridge regression model with various lambdas in 0.01, 0.1, 1, 10 and also alpha = 0, the numbers were chosen for lambda's were supposed to studied more in the next step.
- After some iterations were made to model's, when lambdas at 0.1 came out as the best result for the model, this thought was based on RMSE parameter which showed to be the smallest one among other lambdas.
- Thus we get best model on ridge regression from training data which shown below :

![Best ridge regress model](https://user-images.githubusercontent.com/95845867/155529954-2ec1e99f-0bf3-433f-aa7b-de88929fe26a.PNG)

## Modeling Data : Lasso regression

- Training data will be used to Lasso regression model with various lambdas in 0.01, 0.1, 1, 10 and also alpha = 1, the numbers were chosen for lambda's were supposed to studied more in the next step.
- Through several iterations, we understand from model's, when lambdas at 0.1, it turn out to be as the best result for the model, it was implied based on RMSE parameter which showed to be the smallest one among other lambdas.
- Thus we get best model on lasso regression from training data which shown below :

![Best lasso regress model](https://user-images.githubusercontent.com/95845867/155531487-5408ea2f-0543-4ff4-b95c-30ee2f380e65.PNG)

## Reasoning best lambdas value

- On this occasion, we used RMSE as metric to determine the best lambdas. The values were used is 0.01, 0.1, 1, 10 to test performance of models to do prediction on data set. This test were conducted on validation data in 'boston.csv' data set. From the tests were runned by Rstudio, we understand from ridge regression and lasso regression model, when lambdas used is 0.1 then RMSE generated the smallest value which is 4.357310 and 4.350384 respectively.

## Interpretation from 1 sample of the coefficients in the best model

- Ridge regression model's

  - Based on the output from the model that we generate, we can understand the interpretation for Sample coeff interpretation using ridge regression is when there is an increase of 1 point in rad, while the other features are kept fixed, is associated with an increase of 0.091535571 point in medv (predicting house price)

- Lasso regression model's

  - Based on the output from the model that we generate, we can understand the interpretation for Sample coeff interpretation using lasso regression is when there is an increase of 1 point in rad, while the other features are kept fixed, is associated with an increase of 0.02922899 point in medv (predicting house price)

## Evaluate the best models on the test data

- Ridge regression model

  - First attempt, we used RMSE to evaluate the model which shown below :
  
    ![RMSE test data ridge](https://user-images.githubusercontent.com/95845867/155537067-23761731-c2cc-4ab1-82bb-6a5be5262fe0.PNG)
    
    We can interpret from the value is standard deviation of prediction errors is 6.671366 i.e. from the regression line, the residuals mostly deviate between +- 6.671366
  
  - Second attempt, we used MAE to evaluate the model which shown below :
    
    ![MAE test data ridge](https://user-images.githubusercontent.com/95845867/155537471-314d195f-0389-40de-8e5f-a16ff9bd18b2.PNG)
    
    We get the MAE value of 3.893445, This means that the average absolute error between the actual value and the prediction value is 3.893445
    
  - Third attempt, we used MAPE to evaluate the model which shown below :

    ![MAPE test data ridge](https://user-images.githubusercontent.com/95845867/155537979-b51574d8-e377-4f77-9134-8a0685f5e67c.PNG)
    
    The MAPE value of 17.33% can be interpreted from the model that show the difference between the average prediction value and the actual value is 17.33%.
    
- Lasso regression model

  - First attempt, we used RMSE to evaluate the model which shown below :
  
    ![RMSE test data lasso](https://user-images.githubusercontent.com/95845867/155538661-4c56cd70-2d4d-4e6c-9ee5-5575282ac4ad.PNG)
    
    We can interpret from the value is standard deviation of prediction errors is 6.789957 i.e. from the regression line, the residuals mostly deviate between +- 6.789957
  
  - Second attempt, we used MAE to evaluate the model which shown below :
    
    ![MAE test data lasso](https://user-images.githubusercontent.com/95845867/155538752-224eb06a-4ff9-4240-a221-3b0086342bcb.PNG)

    We get the MAE value of 3.825055, This means that the average absolute error between the actual value and the prediction value is 3.825055
    
  - Third attempt, we used MAPE to evaluate the model which shown below :

    ![MAPE test data lasso](https://user-images.githubusercontent.com/95845867/155538851-da10fd58-3b93-4b50-8a82-f9d34ab9ef4a.PNG)

    The MAPE value of 16.92% can be interpreted from the model that show the difference between the average prediction value and the actual value is 16.92%
    
## When to use : Ridge vs Lasso

- Ridge
  - Only make the coefficients small, NOT zero (e.g. model with business requirement)
  - Works well if there are many large parameters of about the same value

- Lasso
  - Can set same coefficients to zero
  - Tends to do well if there are a small number of significant parameters and the others are close to zero 

