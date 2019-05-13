% The following function uses the squared Pearson's correlation coefficient 
% to measure the similarity between vectors x and y
function r = similarityMeasure(x, y)
    
    x_m = mean(x);
    y_m = mean(y);

	%Pearson's correlation coefficient
    r = sum( (x-x_m).*(y-y_m) )./( sum(y-y_m).^2 * sum(x-x_m).^2 );    
    
    r = r.^2; % square


