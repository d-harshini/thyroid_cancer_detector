
%SPECTF=xlsread('optfeat_train_test_80.xlsx','train');
SPECTF=xlsread('f_train_test.xlsx','train');
%SPECTF=csvread('feature15_train_test_80.csv','train');
label_x = SPECTF(:, 1);
X = SPECTF(:, 2:end);
%SPECTF1=xlsread('optfeat_train_test_80.xlsx','test');
SPECTF1=xlsread('f_train_test.xlsx','test');
%SPECTF1=csvread('feature15_train_test_80.csv','test');
label_y = SPECTF1(:, 1);
Y = SPECTF1(:, 2:end);

Mdl = fitcdiscr(X,label_x);
label_y_p = predict(Mdl,Y);
cm = confusionchart(label_y,label_y_p);
cm = confusionmat(label_y,label_y_p);
sc=sum(sum(cm));
sdc=sum(diag(cm));
accuracy =( sdc / sc ) *100

cm = cm';
precision = diag(cm)./sum(cm,2)
overall_precision = mean(precision)
recall= diag(cm)./sum(cm,1)'
overall_recall = mean(recall)

%{
%SPECTF=xlsread('optfeat_train_test.xlsx','train');
SPECTF=csvread('feature15_train.csv');
label_x = SPECTF(:, 1);
X = SPECTF(:, 2:end);
%SPECTF1=xlsread('optfeat_train_test.xlsx','test');
SPECTF1=csvread('feature15_test.csv');
label_y = SPECTF1(:, 1);
Y = SPECTF1(:, 2:end);

Mdl = fitcecoc(X,label_x);
label_y_p = predict(Mdl,Y);
c = confusionmat(label_y,label_y_p);
sc=sum(sum(c));
sdc=sum(diag(c));
accuracy =( sdc / sc ) *100

%}
