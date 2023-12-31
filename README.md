# Analysis of Sleep Data
Since July of 2016, I have been collecting my sleep data using the [SleepCycle](https://www.sleepcycle.com/) app, available on both iOS and Android. This app uses the microphone in your phone to track various aspects of your sleep (which you can read about in [SleepCycle's Privacy Policy](https://www.sleepcycle.com/privacy-policy-2021/#:~:text=When%20using%20the%20Sleep%20Cycle,as%20snoring%20or%20other%20noises)). Among the multitude of data points captured by the app, I narrowed my focus to 12 specific variables. In particular, I was interested in Sleep Quality, exploring the influencing factors, and attempting to develop a predictive model for future sleep quality. 

## Table of Contents
- [Basic Findings](#basic-findings)
- [Process](#process)
- [Original Dataset Summary](#original-dataset-summary)
- [Training Data](#training-data)
- [Performance Metrics](#performance-metrics)
- [Final Predictions](#final-predictions)
- [Data Visualization](#data-visualization)
- [ROC Curve](#roc-curve)
- [Data Used in this Project](#data-used-in-this-project)

## Basic Findings
In addition to not walking nearly enough on average (I don't have a smart watch, so steps are recorded with my phone. When I don't carry my phone with me, no steps are tracked so don't judge me too hard), I discovered that my sleep quality is... not great.
On average, I spend **6 hours 31 minutes and 58 seconds** in bed. **5 hours 52 minutes and 4 seconds** of that time I spend asleep. The average temperature outside is **43.37°** Fahrenheit (chilly!). I set an alarm **70.81%** of the time, take an average of **2512.071** steps in the day (again, no judgment), and have an average sleep quality of **67.57%**.

## Process
### Original Dataset Summary
I began with a summary of the dataset's variables and their respective ranges, quartiles, and descriptive statistics. This gives gave me an idea of the kind of data I was dealing with. 

<div align="center">

| Variable          | Min.   | 1st Qu. | Median | Mean   | 3rd Qu. | Max.    |
|-------------------|--------|---------|--------|--------|---------|---------|
| SleepQuality      | 3.00   | 57.00   | 70.00  | 67.57  | 82.00   | 100.00  |
| Regularity        | -127.00| 54.00   | 74.00  | 59.18  | 83.00   | 100.00  |
| Steps             | 0      | 379     | 1728   | 2512   | 3715    | 20339   |
| Alarm             | 0.0000 | 0.0000  | 1.0000 | 0.7081 | 1.0000  | 1.0000  |
| PA                | 0.00   | 87.20   | 94.40  | 82.56  | 95.10   | 102.60  |
| MovementsPerHour  | 0.00   | 36.70   | 55.90  | 97.51  | 82.80   | 13911.40|
| TimeInBed         | 975.1  | 20108.8 | 24644.9| 23518.5| 28550.7 | 46359.1 |
| TimeAsleep        | 0      | 17613   | 22042  | 21125  | 26114   | 45456   |
| TimeBeforeSleep   | 0.0    | 174.3   | 303.8  | 452.0  | 526.4   | 5090.6  |
| Snore             | 0.0000 | 1.0000  | 1.0000 | 0.8666 | 1.0000  | 1.0000  |
| SnoreTime         | 0.0    | 0.0     | 0.0    | 197.4  | 180.0   | 6249.0  |
| Temperature       | -3.50  | 32.00   | 41.00  | 43.37  | 52.30   | 86.70   |

</div>
 
 ### Training Data
I built a predictive model with SleepQuality as the dependent variable using **65%** of the original dataset. The goal was to identify the top predictors that could help predict SleepQuality. Here is the summary of the predictive model, which shows us the significant predictors based on their P-Value. These include Time in Bed, Time Asleep, Temperature, Alarm and Steps. These predictors are what I used to predict SleepQuality.

<div align="center">

| Variable         	| Estimate   	| Std. Error 	| t value 	| Pr(>\|t\|)   	|
|------------------	|------------	|------------	|---------	|--------------	|
| (Intercept)      	| 4.830e+00  	| 1.265e+00  	| 3.818   	| 0.000141 *** 	|
| Regularity       	| 5.146e-03  	| 5.878e-03  	| 0.875   	| 0.381512     	|
| Steps            	| 1.930e-04  	| 8.234e-05  	| 2.344   	| 0.019251 *   	|
| Alarm            	| 1.331e+00  	| 5.068e-01  	| 2.627   	| 0.008720 **  	|
| PA               	| -2.174e-02 	| 1.537e-02  	| -1.414  	| 0.157467     	|
| MovementsPerHour 	| -7.880e-04 	| 4.055e-04  	| -1.943  	| 0.052195 .   	|
| TimeInBed        	| 1.903e-03  	| 1.222e-04  	| 15.577  	| < 2e-16 ***  	|
| TimeAsleep       	| 7.676e-04  	| 1.225e-04  	| 6.268   	| 5.03e-10 *** 	|
| TimeBeforeSleep  	| 1.424e-03  	| 4.369e-04  	| 3.259   	| 0.001149 **  	|
| Snore            	| -1.355e+00 	| 1.295e+00  	| -1.047  	| 0.295391     	|
| SnoreTime        	| -1.321e-03 	| 4.457e-04  	| -2.964  	| 0.003094 **  	|
| Temperature      	| 6.014e-02  	| 1.619e-02  	| 3.714   	| 0.000213 *** 	|

</div>
                                                                    
### Performance Metrics
In addition to identifying the top predictors, I calculated additional metrics to evaluate the performance of the predictive model. These metrics include:
* Total Sum of Squares (TSS): **875,662.8**
* Sum of Squares Regression (SSR): **762,789.7**
* Sum of Squares Error (SSE): **112,873.2**

The regression model successfully explains approximately 87.11% of the total variance in SleepQuality, as indicated by the Proportion of Total Sum of Squares Explained by Regression (SSR/TSS). This high percentage suggests that the model is fairly effective. However, there is still approximately **12.89%** of the differences in SleepQuality that remain unexplained, represented by the Sum of Squares Error (SSE).

To assess the overall significance of the regression model, I conducted an F-test, resulting in an F-value of **2626.134** and a corresponding p-value of **0**. This indicates that the model is statistically significant, suggesting that the predictors used in the model collectively have a substantial impact on SleepQuality.

Finally I created a histogram of the residuals to depict the differences between the predicted and actual values of SleepQuality. The histogram forms a bell-shaped curve, suggesting that the residuals follow a normal distribution. This indicates a good fit of the regression model to the data.

<div align="center">
   <img src="https://github.com/ericksonl/SleepData/blob/main/Graphs/SleepQualityHistogram.png" alt="drawing" width="500"/>
</div>
 
### Final Predictions
Finally, I could use my model to predict Sleep Quality. Assuming an average person with respect to the five predictors in the regression model, we find that their sleep quality will be **67.57%.** 
Additionally, I have included some other predictions using pre-selected values:

#### Prediction 1
* TimeInBed = 28800 (8 Hours)
* TimeAsleep = 28800 (8 Hours)
* Temperature = 70
* Alarm = 1 (Alarm was set)
* Steps = 10000

The model predicts my sleep quality will be **85.46%.**
 
#### Prediction 2
* TimeInBed = 18000 (5 Hours)
* TimeAsleep = 14400 (4 Hours)
* Temperature = 40
* Alarm = 1 (Alarm was set)
* Steps = 2000

The model predicts my sleep quality will be **52.34%.**

#### Prediction 3
* TimeInBed = 18000 (6.5 Hours)
* TimeAsleep = 14400 (6 Hours)
* Temperature = 52.56
* Alarm = 0 (Alarm was not set)
* Steps = 4322

The model predicts my sleep quality will be **67.08%.**

## Data Visualization
I was also interested in exploring the relationship between Sleep Quality and its top predictors through visualization. I have added the plots below that show these relationships.

<sup> Note: The README does not include the graph of Alarm vs Sleep Quality due to Alarm being a boolean variable, which limits its potential to provide meaningful insights in the visualization. </sup> 

| Time in Bed vs Sleep Quality                                         | Time Asleep vs Sleep Quality                                         |
|----------------------------------------------------------------------|----------------------------------------------------------------------|
| ![Time in Bed vs Sleep Quality](Graphs/TimeInBedVSSleepQuality.png)  | ![Time in Bed vs Sleep Quality](Graphs/TimeAsleepVSSleepQuality.png) |

| Temperature vs Sleep Quality                                           | Steps vs Sleep Quality                                               |
|------------------------------------------------------------------------|----------------------------------------------------------------------|
| ![Time in Bed vs Sleep Quality](Graphs/TemperatureVSSleepQuality.png)  | ![Time in Bed vs Sleep Quality](Graphs/StepsVSSleepQuality.png)      |

## ROC Curve
By converting the Sleep Quality data to binary values (1's and 0's), I applied a generalized linear model to predict Sleep Quality. Specifically, I categorized sleep quality as **1** for values **greater than or equal to 70**, and as **0** for values **below 70**. With **65%** of the original dataset, I developed a predictive model with Sleep Quality as the dependent variable. Using this model, I constructed an ROC curve from scratch to evaluate its performance. The calculated Area under the Curve (AUC) is **0.8464055**, indicating that the model exhibits reasonably good discriminatory power.

Here is the ROC curve:

<div align="center">

  <img src="https://github.com/ericksonl/SleepData/blob/main/Graphs/ROCCurve.png" alt="ROC Curve" width="500"/>
 
 </div>

By examing the shape of this ROC curve and the value of the AUC, we can tell the model demonstrates strong performance. This result signifies a good level of accuracy in predicting sleep quality based on the provided data.

## Data Used in this Project
* SleepQuality (Percent)
* Regularity (Percent)
* Steps	
* Alarm (Boolean)
  * 0 = No alarm set
  * 1 = Alarm was set
* Air Pressure (PA)
* MovementsPerHour
* TimeInBed (Seconds)
* TimeAsleep (Seconds)
* TimeBeforeSleep (Seconds)
* Snore (Boolean)
  * 0 = Did not snore
  * 1 = Did snore
* SnoreTime (Seconds)
* Temperature (Fahrenheit) 
