# Name : Feby Mara Pandebu
# DS Batch 9 HW_DAY 21

# Install packages that would be useful

install.packages("ggplot2")
install.packages("caTools")
install.packages("car")
install.packages("psych")
install.packages("dplyr")
install.packages("glmnet")

# import data from dataset 'boston.csv'
data <- read.csv("boston.csv")

### [POIN 1] : Split data into train - validation - test

# split training and test data
library(caTools)
set.seed(123)
sample <- sample.split(data$medv, SplitRatio = .80)
pre_train <- subset(data, sample == TRUE)
sample_train <- sample.split(pre_train$medv, SplitRatio = .80)

# train-validation data
train <- subset(pre_train, sample_train == TRUE)
validation <- subset(pre_train, sample_train == FALSE)

# test data
test <- subset(data, sample == FALSE)

### [POIN 2] : Draw correlation plot on training data and perform feature selection
###          on highly correlated features

# correlation study
library(psych)
pairs.panels(train,
             method = "pearson", # correlation method
             hist.col = "#00AFBB",
             density = TRUE,  # show density plots
             ellipses = TRUE, # show correlation ellipses
             cex.cor = 3
) # correlated features: rad, and tax. Choose: rad

# drop correlated columns
library(dplyr)
drop_cols <- c('tax')

train <- train %>% select(-drop_cols)
validation <-  validation %>% select(-drop_cols)
test <- test %>% select(-drop_cols)

### [POIN 3] : Fit model on training data

# feature pre processing
# to ensure we handle categorical features
x <- model.matrix(medv ~ ., train)[,-1]
y <-  train$medv

### [SECTION A]

# ridge regression
# fit multiple ridge regression with different lambda
# lambda = [0.01, 0.1, 1, 10]

library(glmnet)
ridge_reg_pointzeroone <- glmnet(x, y, alpha = 0, lambda = 0.01)
coef(ridge_reg_pointzeroone)

ridge_reg_pointone <- glmnet(x, y, alpha = 0, lambda = 0.1)
coef(ridge_reg_pointone)

ridge_reg_one <- glmnet(x, y, alpha = 0, lambda = 1)
coef(ridge_reg_pointone)

ridge_reg_ten <- glmnet(x, y, alpha = 0, lambda = 10)
coef(ridge_reg_ten)

### [SECTION B]

# lasso regression
# fit multiple lasso regression with different lambda
# lambda = [0.01, 0.1, 1, 10]

lasso_reg_pointzeroone <- glmnet(x, y, alpha = 1, lambda = 0.01)
coef(lasso_reg_pointzeroone)

lasso_reg_pointone <- glmnet(x, y, alpha = 1, lambda = 0.1)
coef(lasso_reg_pointone)

lasso_reg_one <- glmnet(x, y, alpha = 1, lambda = 1)
coef(lasso_reg_pointone)

lasso_reg_ten <- glmnet(x, y, alpha = 1, lambda = 10)
coef(lasso_reg_ten)

### [POIN 4] : Choose the best lambda from the validation set

### [SECTION A] : Use RMSE as metric to determine the best lambda

# comparison on validation data (ridge regression)
# to choose the best lambda

# Make predictions on the validation data
x_validation <- model.matrix(medv ~., validation)[,-1]
y_validation <- validation$medv

RMSE_ridge_pointzeroone <- sqrt(mean((y_validation - predict(ridge_reg_pointzeroone, x_validation))^2))
RMSE_ridge_pointzeroone # 4.357537

RMSE_ridge_pointone <- sqrt(mean((y_validation - predict(ridge_reg_pointone, x_validation))^2))
RMSE_ridge_pointone # 4.357310 --> best

RMSE_ridge_one <- sqrt(mean((y_validation - predict(ridge_reg_one, x_validation))^2))
RMSE_ridge_one # 4.423521

RMSE_ridge_ten <- sqrt(mean((y_validation - predict(ridge_reg_ten, x_validation))^2))
RMSE_ridge_ten # 5.382494


# comparison on validation data (lasso regression)
# to choose the best lambda
# Make predictions on the validation data

RMSE_lasso_pointzeroone <- sqrt(mean((y_validation - predict(lasso_reg_pointzeroone, x_validation))^2))
RMSE_lasso_pointzeroone # 4.350444

RMSE_lasso_pointone <- sqrt(mean((y_validation - predict(lasso_reg_pointone, x_validation))^2))
RMSE_lasso_pointone # 4.350384 --> best

RMSE_lasso_one <- sqrt(mean((y_validation - predict(lasso_reg_one, x_validation))^2))
RMSE_lasso_one # 4.95769

RMSE_lasso_ten <- sqrt(mean((y_validation - predict(lasso_reg_ten, x_validation))^2))
RMSE_lasso_ten # 9.371755


### [SECTION B] : Interpret a sample of the coefficients of the best model

## PART i (Ridge Regression)

# Best model's coefficients
# recall the best model --> ridge_reg_pointone

coef(ridge_reg_pointone)

## Based on the output from the model that we generate, we can understand the interpretation for
## Sample coeff interpretation using ridge regression :
## An increase of 1 point in rad, while the other features are kept fixed, is associated with an
## increase of 0.091535571 point in medv (predicting house price)


## PART ii (Lasso Regression)

# Best model's coefficients
# recall the best model --> lasso_reg_pointone

coef(lasso_reg_pointone)

## Based on the output from the model that we generate, we can understand the interpretation for
## Sample coeff interpretation using lasso regression :
## An increase of 1 point in rad, while the other features are kept fixed, is associated with an
## increase of 0.02922899 point in medv (predicting house price)

### [POIN 5] : Evaluate the best models on the test data

## Evaluating the model
# true evaluation on test data

x_test <- model.matrix(medv ~., test)[,-1]
y_test <- test$medv

# Ridge

# RMSE
RMSE_ridge_best <- sqrt(mean((y_test - predict(ridge_reg_pointone, x_test))^2))
RMSE_ridge_best

## interpretation :
## The standard deviation of prediction errors is 6.671366 i.e. from the regression line,
## the residuals mostly deviate between +- 6.671366

# MAE
MAE_ridge_best <- mean(abs(y_test-predict(ridge_reg_pointone, x_test)))
MAE_ridge_best

## interpretation :
## we get the MAE value of 3.893445, This means that the average absolute error 
## between the actual value and the prediction value is 3.893445

# MAPE
MAPE_ridge_best <- mean(abs((predict(ridge_reg_pointone, x_test) - y_test))/y_test)
MAPE_ridge_best

## interpretation :
## The MAPE value of 17.33% can be interpreted from the model that show the difference  
## between the average prediction value and the actual value is 17.33%.

# Lasso

# RMSE
RMSE_lasso_best <- sqrt(mean((y_test - predict(lasso_reg_pointone, x_test))^2))
RMSE_lasso_best

## interpretation :
## The standard deviation of prediction errors is 6.789957 i.e. from the regression line,
## the residuals mostly deviate between +- 6.789957

# MAE
MAE_lasso_best <- mean(abs(y_test-predict(lasso_reg_pointone, x_test)))
MAE_lasso_best

## interpretation :
## we get the MAE value of 3.825055, This means that the average absolute error 
## between the actual value and the prediction value is 3.825055

# MAPE
MAPE_lasso_best <- mean(abs((predict(lasso_reg_pointone, x_test) - y_test))/y_test)
MAPE_lasso_best

## interpretation :
## The MAPE value of 16.92% can be interpreted from the model that show the difference  
## between the average prediction value and the actual value is 16.92%.
