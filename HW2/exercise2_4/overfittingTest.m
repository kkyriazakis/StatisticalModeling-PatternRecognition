% overfittingTest.m
clear all; close all; clc;

%% -------------PART A-------------------------------------------------------
numFeatures = 1000;
numSelectedFeatures = 100;
numPositiveExamples = 15;  % E.g., Autism
numNegativeExamples = 10;  % E.g., Typically developing subjects
numExamples = numPositiveExamples + numNegativeExamples;
labels = ones(numExamples, 1);
labels(1:numNegativeExamples) = -1;
features = randn(numExamples, numFeatures);



disp('Classify without feature selection')
% Cross validation. Leave one out
numCorrectlyClassified = 0;
for i = 1:numExamples
    idx = [1:i-1, i+1:numExamples]; % Leave out example i 
    SVMStruct = fitcsvm(features(idx, :), labels(idx));
    predictedLabel = predict(SVMStruct, features(i, :)); % Classify example i
    if (predictedLabel == labels(i))
        numCorrectlyClassified = numCorrectlyClassified + 1;
    end
end

% Proportion of true results (both true positives and true negatives) among the total number of cases examined
accuracy = numCorrectlyClassified/numExamples;  
disp(strcat('accuracy : ', num2str(accuracy)))
disp(' ')


%% -------------PART C-------------------------------------------------------

disp('Classify with feature selection inside the cross validation')

% Cross validation. Leave one out
numCorrectlyClassified = 0;
for i = 1:numExamples
    idx = [1:i-1, i+1:numExamples]; % Leave out example i 
    
    for j = 1:numFeatures   % Feature selection          
          r(j) = similarityMeasure(features(idx,j), labels(idx)); % Compute the similarity measure
    end
    [rSorted, sortedFeatureIndices] = sort(r, 'descend');
    selectedIndices = sortedFeatureIndices(1:numSelectedFeatures);

    SVMStruct = fitcsvm(features(idx, selectedIndices), labels(idx));
    predictedLabel = predict(SVMStruct, features(i, selectedIndices)); % Classify example i
    
    if (predictedLabel == labels(i))
        numCorrectlyClassified = numCorrectlyClassified + 1;
    end
end

% Proportion of true results (both true positives and true negatives) among the total number of cases examined
accuracy = numCorrectlyClassified/numExamples;  
disp(strcat('accuracy : ', num2str(accuracy)))
disp(' ')


%% ------------PART D--------------------------------------------------------

disp('Classify with feature selection outside the cross validation')

% Feature selection
for j = 1:numFeatures
      % Compute the similarity measure
      r(j) = similarityMeasure(features(:,j), labels);
end
[rSorted, sortedFeatureIndices] = sort(r, 'descend');
% The indices of the selected features.
selectedIndices = sortedFeatureIndices(1:numSelectedFeatures);


% Cross validation. Leave one out
numCorrectlyClassified = 0;
for i = 1:numExamples
    idx = [1:i-1, i+1:numExamples]; % Leave out example i 
    
    SVMStruct = fitcsvm(features(idx, selectedIndices), labels(idx));
    predictedLabel = predict(SVMStruct, features(i, selectedIndices)); % Classify example i
    
    if (predictedLabel == labels(i))
        numCorrectlyClassified = numCorrectlyClassified + 1;
    end
end

% Proportion of true results (both true positives and true negatives) among the total number of cases examined
accuracy = numCorrectlyClassified/numExamples;  
disp(strcat('accuracy : ', num2str(accuracy)))
disp(' ')
