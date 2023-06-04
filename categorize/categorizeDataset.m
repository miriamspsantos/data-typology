function [S,B,R,O,dataTax,D] = categorizeDataset(X, T, featureTypes, class, distMetric)
% CATEGORIZEDATASET Provides a categorization of a given dataset
% into SAFE, BORDER, RARE or OUTLIER examples. It makes use of
% categorizeExamples function.
% 
%
%   INPUT:
%       filename = string name of the file (e.g. 'nursery.arff')
%       class = value of the desired class (e.g. 1/0/2)
%
%
%   OUTPUT:
%       S = percentage of SAFE examples
%       B = percentage of BORDER examples
%       R = percentage of RARE examples
%       O = percentage of OUTLIER examples
%
%
% Copyright: Miriam Santos 2018

nExamples = length(find(T == class));

% Determine the metric distance
switch distMetric
    case 'HVDM-original'
        D = hvdmDist(X,T,featureTypes, 'original');
    case 'HEOM-original'
        D = heomDist(X,featureTypes, 'original');
    case 'HVDM-redef'
        D = hvdmDist(X,T,featureTypes, 'redef');
    case 'HEOM-redef'
        D = heomDist(X,featureTypes, 'redef');
    case 'HVDM-special'
        D = hvdmDist(X,T,featureTypes, 'special');
    case 'SIMDIST'
        D = similarityDistance(X, featureTypes);
    case 'MDE'
        D = mdeDist(X, featureTypes);  
end

% Determine the categories of examples
dataTax = categorizeExamples(D, T, class);

nSafe = numel(strfind(dataTax,'S'));
nBorder = numel(strfind(dataTax,'B'));
nRare = numel(strfind(dataTax,'R'));
nOutlier = numel(strfind(dataTax,'O'));

S = round(nSafe/nExamples*100,2);
B = round(nBorder/nExamples*100,2);
R = round(nRare/nExamples*100,2);
O = round(nOutlier/nExamples*100,2);


end
