# Estimating the Effect of Climate Change on Sea Level Using Machine Learning

This project investigates the impact of climate change on sea level rise by leveraging machine learning techniques. The goal is to develop predictive models to estimate sea level variations using environmental parameters such as temperature, precipitation, greenhouse gas concentrations, and population data.

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Getting Started](#getting-started)
- [Results](#results)
- [Conclusions](#conclusions)
- [References](#references)

## Introduction
Climate change has led to significant sea level rise, threatening coastal regions and their inhabitants. This project aims to enhance predictions by considering multiple parameters and applying machine learning models like polynomial regression, support vector machines (SVM), random forests, and neural networks.

## Features
- **Data Preprocessing**: Data from NOAA, NASA, and other sources normalized and prepared for analysis.
- **Dimensionality Reduction**: Principal Component Analysis (PCA) for efficient feature selection.
- **Machine Learning Models**:
  - Regression models (Linear, Polynomial)
  - Random Forest
  - Neural Networks
  - Support Vector Machines (SVM)
- **Evaluation Metrics**: RMSE and cross-validation to measure model performance.

## Technologies Used
- **Languages**: Python, MATLAB
- **Libraries**: Scikit-learn, NumPy, Matplotlib
- **Data Sources**: NOAA, NASA, UHSLC, EPI, WRCC

## Getting Started
1. Clone the repository:
   ```bash
   git clone https://github.com/rajvi-patel-22/sea-level-prediction.git

2. Run the cells sequentially to preprocess data, train models, and view results.

## Results
The study demonstrates that neural networks provide the most accurate predictions for global sea level rise, with random forests excelling in local predictions. PCA effectively reduced dimensionality, improving computational efficiency and model accuracy.
<p align="center">
  <img width="400" alt="Screenshot 2025-01-09 at 6 02 09 PM" src="https://github.com/rajvi-patel-22/Estimating-the-effect-of-climate-change-on-sea-level-using-ML/blob/master/Figures/figure1.jpg" />
  <img width="400" alt="Screenshot 2025-01-09 at 6 02 09 PM" src="https://github.com/rajvi-patel-22/Estimating-the-effect-of-climate-change-on-sea-level-using-ML/blob/master/Figures/figure2.jpg" />
  <img width="400" alt="Screenshot 2025-01-09 at 6 02 09 PM" src="https://github.com/rajvi-patel-22/Estimating-the-effect-of-climate-change-on-sea-level-using-ML/blob/master/Figures/figure4.jpg" />
</p>
<p align="center">
  <img width="600" alt="Screenshot 2025-01-09 at 6 02 09 PM" src="https://github.com/user-attachments/assets/eda6b020-1da7-4880-b677-df0ce0cfb744" />

</p>

## Conclusions
Machine learning models, particularly neural networks, are powerful tools for predicting sea level changes.
Dimensionality reduction using PCA is critical for handling high-dimensional datasets.
The project underscores the importance of selecting appropriate features and models for specific use cases.
## References
- National Oceanic and Atmospheric Administration (NOAA)
- National Aeronautics and Space Administration (NASA)
- Various academic research papers (listed in the project documentation)
