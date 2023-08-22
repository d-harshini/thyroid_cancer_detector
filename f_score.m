function [sFeat,Sf,Nf,Fscore]=f_score(feat,label,nFeat)
%---Input------------------------------------------------------------------
% feat:  feature vector (instances x features)
% label: labelling 
% nFeat: Pre-determined number of selected features
%---Output-----------------------------------------------------------------
% sFeat: Selected features (instances x features)
% Sf:    Selected feature index
% Nf:    Number of selected features
%--------------------------------------------------------------------------
% Number of features
D=size(feat,2);
% Number of classes
class=unique(label); Nc=length(class); 
% Pre
Fsore=zeros(1,D);
% Fscore 
for d=1:D
  % Overall mean of features
  Mu=mean(feat(:,d)); 
  % Pre
  mu=zeros(Nc,1); A=zeros(Nc,1); B=zeros(Nc,1); 
  for k=1:Nc
    c=class(k); 
    % Call each dth feature for class k
    f=feat(label==c,d); 
    % Number of instances of dth feature for class k
    N=length(f); 
    % Mean of features for class k
    mu(k)=mean(f); 
    % Compute upper (A) & lower (B) parts
    A(k)=(mu(k)-Mu)^2;
    B(k)=(1/(N-1))*sum((f-repmat(mu(k),N,1)).^2);
  end
  % Fscore 
  Fsore(d)=sum(A)/sum(B)
end
% Higher F-score better features
[~,Sf]=sort(Fsore,'descend');
% Select features based on selected index
Sf=Sf(1:nFeat)
sFeat=feat(:,Sf) ;
Fscore=Fsore(Sf);
Nf=length(Sf);
end
