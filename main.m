% Import necessary libraries
addpath('arff-to-mat');
addpath('categorize');
addpath('distances');
addpath('data');
addpath('utils');

% Load the dataset (must contain the .arff extension)
filename = 'thoracic.arff';
data = arff2double(filename);
X = data.X; % features
T = data.Y; % class
min_class = 1; % In this project, 1 is the minority and positive class
feature_types = data.isNomBin; % bool array of nominal (1) or numeric (0) features
distance_metric = 'HVDM-original';

% Calculate data typology
[S,B,R,O,data_types,D] = categorizeDataset(X, T, feature_types, min_class, distance_metric);
