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
        P(i) = length(find(Labels == 0))/NumLabels;
        
        %Calculate the Class Mean 
        mu(i,:) = mean(Samples( Labels == i-1 ,:),1);
    end
    
    %Calculate the Global Mean
    m0 = mean(mean(Samples));

    Sw = 0;
    Sb = 0;
    for i=1:NumClasses    
        %Calculate the Within Class Scatter Matrix
        Sw = Sw + cov(Samples( Labels==i-1,:));
            
        %Calculate the Between Class Scatter Matrix
    	Sb = Sb + length(find(Labels == i-1))*(mu(i,:) - m0)*(mu(i,:) - m0)';        
    end

    %Eigen matrix EigMat=inv(Sw)*Sb
    EigMat = inv(Sw)*Sb;
    
    %Perform Eigendecomposition
    [V,D] = eig(EigMat);
    
    eigenvalues = diag(D);
    [eigenvalues, pos]= sort(eigenvalues ,1,'descend');
    eigenvectors = V(:,pos);

    A = eigenvectors(:,[1:NewDim]);
    
    
    
