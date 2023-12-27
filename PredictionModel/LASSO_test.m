% LSSO model
% N = 200; % number of trials
% K = 90; % number of variables
% X = [ones(N,1),randn(N,K-1)];
% B = 1+randn(K,1);
% B(rand(K,1)<.7)=0;
% 

% Y = X*B + randn(N,1);

X = [ones(size(allinclusiveTable,1),1),allinclusiveTable(:,1:end-2)];
Y = allinclusiveTable(:,end);


% Estimation
iTr = rand(length(Y),1)<.5; % training
iHo = ~ iTr;

[BlassoAll, stats] = lasso(X(iTr,2:end),Y(iTr),'CV',10);


% lasso
lassoPlot(BlassoAll,stats,"PlotType","CV");
Blasso = [stats.Intercept(stats.Index1SE);BlassoAll(:,stats.Index1SE)];

% Evaluate predictions on holdout sample

yLasso = X(iHo,:)*Blasso;

% Assess prediciton error

fprintf('MSE, LASSO: %f\n', mean((Y(iHo)-yLasso).^2));

histogram(Blasso,20)

%figure,plot(B,Blasso,'x')

figure,plot(Y(iHo),yLasso,'x')

figure,plot(Y(iHo))
hold on
plot(yLasso)