## SVM and K-NN Classification on Credit Approval Data

## Dataset
The dataset comes from the UCI Machine Learning Repository (Credit Approval Data Set) - (https://archive.ics.uci.edu/ml/datasets/Credit+Approval).
- 654 observations
- 10 predictor variables (6 continuous, 4 binary)
- 1 binary response variable (last column)

File used: `credit_card_data-headers.txt`

## Part 1: Support Vector Machine (SVM)

- Method: Linear SVM using `ksvm` from the `kernlab` package
- Kernel: `vanilladot`
- Data scaling: Enabled (`scaled = TRUE`)
- Tested C values: 0.01, 0.1, 1, 10, 100, 1000
<img width="495" height="248" alt="1" src="https://github.com/user-attachments/assets/ebc0ec39-f06c-4681-86ec-0468d1c43317" />

### Best Model
- **C = 0.01**
- Accuracy: **86.4%** on the full dataset
<img width="381" height="37" alt="2" src="https://github.com/user-attachments/assets/36bf4bf6-17f4-4d17-974c-06e2f9170583" />

### Classifier Equation
f(x) = sign(a0 + a1*x1 + a2*x2 + ... + a10*x10)

### Coefficient and Intercept
<img width="927" height="431" alt="3" src="https://github.com/user-attachments/assets/432f227d-74d4-4524-971c-9e90f58de4f6" />


## Part 2: K-Nearest Neighbors (K-NN)

- Method: `kknn` package
- Distance scaling: Enabled (`scale = TRUE`)
- Validation: Leave-One-Out Cross-Validation
- Tested k values: 1, 3, 5, 7, 9, 11, 15, 21, 25
<img width="262" height="185" alt="4" src="https://github.com/user-attachments/assets/92f7cf06-dc13-4aa5-bb78-be983041da2a" />


### Best Model
- **k = 15**
- Accuracy: **85.3%**
<img width="613" height="72" alt="5" src="https://github.com/user-attachments/assets/7e59ffd5-96de-4838-96e3-0c0d5614e40e" />


## Conclusion
- SVM slightly outperformed K-NN (86.4% vs 85.3%).
- K-NN performance is sensitive to k.
- SVM provides better accuracy and faster prediction.

## How to Run
1. Create a local folder and download the R script and dataset files into it.
2. Open the folder in RStudio.
3. Run the script.
