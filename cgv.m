clc;

%SPECTF = xlsread('optfeat_train_test_80.xlsx','train');  %read a csv file
SPECTF=xlsread('f_train_test.xlsx','train');
labels = SPECTF(:, 1); % labels from the 1st column
features = SPECTF(:, 2:end); 
features_sparse = sparse(features); % features must be in a sparse matrix
libsvmwrite('trainingdataset.txt', labels, features_sparse);

%SPECTF = xlsread('optfeat_train_test_80.xlsx','test'); % read a csv file
SPECTF=xlsread('f_train_test.xlsx','test');
labels = SPECTF(:, 1); % labels from the 1st column
features = SPECTF(:, 2:end); 
features_sparse = sparse(features); % features must be in a sparse matrix
libsvmwrite('testingdataset.txt',labels, features_sparse);

%G = 0.0078125;
%C = 32768;

G=0.001953125;
C=32768;


    [label_vector, instance_matrix] = libsvmread('trainingdataset.txt');
    [N D] = size(instance_matrix);
    cmd = ['-c ',num2str(1*C), ' -g ', num2str(1*G)];
    model = svmtrain(label_vector, instance_matrix,cmd);
    [label_v,instance_matrix1] = libsvmread('testingdataset.txt');
    [predict_label, accuracy, dec_values] = svmpredict(label_v,instance_matrix1, model); % test the training data
    %kk(j)=accuracy(1);
    kk=accuracy(1);
    disp(cmd);
    
    cm = confusionchart(label_v,predict_label);
    cm = confusionmat(label_v,predict_label);

disp(kk)

cm = cm';
precision1 = diag(cm)./sum(cm,2)
overall_precision = mean(precision1)
recall1= diag(cm)./sum(cm,1)'
overall_recall = mean(recall1)





 