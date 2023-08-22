clc, clear, close 
% Benchmark data set contains 351 instances and 34 features (binary class)
%load ionosphere.mat; % Matlab also provides this dataset (load Ionosphere.mat)
% Call features & labels
%Y=cell2mat(Y);

a = fopen('normalized_F.csv');
b = fopen('labels_features.csv');
%b = textscan(a, '%s %s %s %s', 'delimiter', ',')
fmt = repmat('%f', 1, 58);
data = ( textscan(a,fmt, 'Delimiter', ',','CollectOutput',true))
labels = ( textscan(b,'%f', 'Delimiter', ',','CollectOutput',true))
X=data{1,1};
Y=labels{1,1};
feat=X; label=Y; 
nFeat=58;
[sFeat,Sf,Nf,Fscore]=f_score(feat,label,nFeat);