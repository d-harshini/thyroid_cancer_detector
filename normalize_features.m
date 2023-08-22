data = xlsread('Features_TIRADS5.xls');
nor = normalize(data,'range');
xlswrite('normalized_Features_TIRADS5.xls',nor);