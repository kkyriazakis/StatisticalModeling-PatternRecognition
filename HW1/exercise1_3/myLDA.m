function A = myLDA(Samples, Labels, NewDim)
% Input:    
%   Samples: The Data Samples 
%   Labels: The labels that correspond to the Samples
%   NewDim: The New Dimension of the Feature Vector after applying LDA
       
    [NumSamples NumFeatures] = size(Samples);

	A = zeros(NumFeatures,NewDim);
    
    NumLabels = length(Labels);
    if(NumSamples ~= NumLabels)
        fprintf('\nNumber of Samples are not the same with the Number of Labels.\n\n');
        exit
    end
    Classes = unique(Labels);
    NumClasses = length(Classes);  %The number of classes

    for i=1:NumClasses %Find the necessary statistics
        
        %Calculate the Class Prior Probability
        P(i) = length(find(iris_labels == 0))/NumLabels;
        
        %Calculate the Class Mean 
        mu(i,:) = mean(Samples( iris_labels == i-1 ,:),1);
    end
    
    %Calculate the Within Class Scatter Matrix
    Sw = cov(Samples( iris_labels==0,:)) + cov(Samples( iris_labels==1,:)) + cov(Samples( iris_labels==2,:));
        
    %Calculate the Global Mean
    m0 = mean(mean(Samples));
    
    %Calculate the Between Class Scatter Matrix
	Sb = length(find(iris_labels == 0))*(mu(1,:) - m0)*(mu(1,:) - m0)';
    Sb = Sb + length(find(iris_labels == 1))*(mu(2,:) - m0)*(mu(2,:) - m0)';
    Sb = Sb + length(find(iris_labels == 2))*(mu(3,:) - m0)*(mu(3,:) - m0)';
    
    %Eigen matrix EigMat=inv(Sw)*Sb
    EigMat = inv(Sw)*Sb;
    
    %Perform Eigendecomposition
    
    
    %Select the NewDim eigenvectors corresponding to the top NewDim
    %eigenvalues (Assuming they are NewDim<=NumClasses-1)
	A = zeros(NumFeatures,NewDim);  % Return the LDA projection vectors
    
    
