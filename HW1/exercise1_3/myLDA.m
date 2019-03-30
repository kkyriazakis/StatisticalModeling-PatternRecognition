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
    
    %Calculate the Within Class Scatter Matrix
    Sw = cov(Samples( Labels==0,:)) + cov(Samples( Labels==1,:)) + cov(Samples( Labels==2,:));
        
    %Calculate the Global Mean
    m0 = mean(mean(Samples));
    
    %Calculate the Between Class Scatter Matrix
	Sb = length(find(Labels == 0))*(mu(1,:) - m0)*(mu(1,:) - m0)';
    Sb = Sb + length(find(Labels == 1))*(mu(2,:) - m0)*(mu(2,:) - m0)';
    Sb = Sb + length(find(Labels == 2))*(mu(3,:) - m0)*(mu(3,:) - m0)';
    
    %Eigen matrix EigMat=inv(Sw)*Sb
    EigMat = inv(Sw)*Sb;
    
    %Perform Eigendecomposition
    [V,D] = eig(EigMat);
    
    eigenvalues = diag(D);
    [eigenvalues, pos]= sort(eigenvalues ,1,'descend');
    eigenvectors = V(:,pos);

    A = eigenvectors(:,[1:NewDim]);
    
    
    
