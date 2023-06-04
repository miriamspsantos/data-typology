function dataTypes = categorizeExamples(D, T, class)
% categorizeExamples Provides a categorization of a given class into SAFE, BORDER, RARE or
% OUTLIER examples. This approach was first proposed by Napierala and
% Stefanowski, and usually consideres only the categorization of minority
% examples. This function consideres the examples with class 'class'.
%
%   INPUT:
%       T = column vector of class labels
%       class = value of the desired class (e.g. 1/0/2)
%       D = matrix of distances NxN examples
%
%   OUTPUT:
%       dataTax = array of characters XSBRO corresponding to:
%           S = SAFE
%           B = BORDER
%           R = RARE
%           O = OUTLIER
%           X = Other class rather than the chosen to categorize
% 
% References: K. Napierala and J. Stefanowski, Types of minority class
% examples and their influence on learning classifiers from imbalanced data
% Journal of Intelligent Information Systems, 2016
%
% NOTE ON PARAMETERS: On their paper, Napierala and Stefanowski consider
% HVDM distance and K = 5 to find the nearest neighbours. This function
% makes use of k = 5 and considers any distance matrix given by D.
% 
%
% Author: Miriam Seoane Santos (last-update: March 29, 2018)

N = size(D,1);
dataTypes = repmat('X',[1 N]);


% Give an infinit value to the distance matrix D, where i == j (same
% example)
D(logical(eye(size(D)))) = Inf;

cExamples = find(T==class);

D = D(:,cExamples);


% Sort the distances D
[~,Idx] = sort(D);

% Find the 5 nearest neighbours of each example
NN5 = Idx(1:5,:);

% Class labels (target) of the 5 nearest neighbours
TNN5 = T(NN5);

% Create logical array where TNN5 is equal to the desired class
logTNN5 = (TNN5 == class);

% Count how many examples each one has from the same class
countClass = sum(logTNN5);

labels = 'SBRO';

for j=1:numel(countClass)
    switch countClass(j)
        case 0
            classLabels(j) = labels(4); % OUTLIER
        case 1 % Possible rare example
            
            % Determine its solo neighbour
            idxNN = NN5(logTNN5(:,j),j); % index of its neighbour (e.g. example 3)
            jNN = find(cExamples == idxNN); % j value corresponding to that neighbour
            
            if countClass(jNN) == 0
                classLabels(j) = labels(3); % True RARE example
            elseif countClass(jNN) == 1 && ismember(cExamples(j), NN5(:,jNN))
                classLabels(j) = labels(3); % Also a true RARE example
            else
                classLabels(j) = labels(2); % Otherwise consider it a BORDER example
            end            
        case 2
            classLabels(j) = labels(2); % BORDER
        case 3
            classLabels(j) = labels(2); % BORDER
        case 4
            classLabels(j) = labels(1); % SAFE
        case 5
            classLabels(j) = labels(1); % SAFE
    end
end

% Replace desired class examples with typology label
dataTypes(cExamples) = classLabels;


end