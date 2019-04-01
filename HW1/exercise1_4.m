clear all
close all
clc

%% Calculate Boundary
mu1 = [3 3];
mu2=[6 6];
SIGMA1 = [1.2 -0.4; -0.4 1.2];
SIGMA2 = [1.2  0.4;  0.4 1.2];

values = [0.1 0.25 0.5 0.75 0.9];
colors = ["red"; "blue"; "black"; "green"; "red"];

for i= [1:5]
    Pw1 = values(i);
    Pw2 = 1 - Pw1;

    syms x y
    C = log( (Pw1*det(SIGMA2))/(Pw2*det(SIGMA1)) );
    y = -x + C*2/5 + 9;
    fig =ezplot(y,[-4 10 -4 12]);
    set(fig,'color',colors(i),'LineWidth',2);
    hold on
end

%% Draw the gaussians (likelihoods)
DT=0.01;
x1=[-4:DT:10]; %Horizontal axis
x2=[-4:DT:12];
[X1,X2]=meshgrid(x1,x2);

Y1=mvnpdf([X1(:) X2(:)],mu1,SIGMA1);
Y1R=reshape(Y1,length(x2),length(x1));
Y2=mvnpdf([X1(:) X2(:)],mu2,SIGMA2);
Y2R=reshape(Y2,length(x2),length(x1));
contour(x1,x2,Y1R,[.0001 .001 .01 .05:.1:.95 .99 .999 .9999],'LineColor','r')
contour(x1,x2,Y2R,[.0001 .001 .01 .05:.1:.95 .99 .999 .9999],'LineColor','b') 
grid on
