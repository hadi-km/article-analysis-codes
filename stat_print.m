%print significant p values from the matrix of channel correlations

clc

load('/Users/hadi/Desktop/CORR/channel correlations/closeee.mat')
load('/Users/hadi/Desktop/CORR/channel correlations/openss.mat')


cond = CLOSE; close =  true ;
%  CLOSE     OPEN     true        false
var = cond.audit_total;



 c = {'Fp1','F7','T3','T5','O1','F3','C3','P3','Fp2','F8','T4','T6','O2','F4','C4','P4'};
bands = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};

if close == true
fprintf('\n CLOSED-EYE: \n      channels: \n')
else 
    fprintf('\n OPEN-EYE: \n      channels: \n')
end

inn = var.pval_rel <0.05; %index

for band= 1: length(bands)

%delta
fprintf([ '\n   ' , bands{band}, '   band: \n' ] )
% disp(bands{band})
in2 = inn(:,band);
fprintf('%s, ', c{in2});

% p value
fprintf('\n      p value: \n')
pv = var.pval_rel(in2,band);
fprintf('%.3f, ', pv);  

% r value
fprintf('\n      r value: \n')

rv = var.corr_rel(in2,band);
fprintf('%.3f, ', rv);  

end