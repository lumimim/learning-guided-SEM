clc
clear
addpath(genpath('./dpp'))
addpath(genpath('./dpp/helpers'))

error_predict_bicubic=double(readvolume('error_prediction'))/255;

%similarity matrix
N=64;
[x y] = meshgrid((1:N)/N);
sigma = 0.1; % kernel width
% gaussian kernel
L = exp(- (bsxfun(@minus,x(:),x(:)').^2 + ...
           bsxfun(@minus,y(:),y(:)').^2) / sigma^2);

window=1:N;
ic_thre=0:0.1:0.9;
for iz =1:100
    for ic=1:size(ic_thre,2)
         for lam=1:8
                  map_pred_error_bicubic=error_predict_bicubic(window,window,iz-50)>=1-ic_thre(ic);
                  rec_rate_pred_error_bicubic(ic,iz)=sum(map_pred_error_bicubic,'all')/(N*N);
                  k_dpp=sum(map_pred_error_bicubic,'all');
                  diag_matrix=diag(reshape((255*error_predict_bicubic(window,window,iz-50)).^lam,[N*N 1]));
                  C = decompose_kernel(diag_matrix*L*diag_matrix);
                  dpp_sample=sample_dpp(C,k_dpp);
                  map_dpp_pred_error_bicubic = zeros(size(map_pred_error_bicubic));
                  sample_index_x=x(dpp_sample)*N;
                  sample_index_y=y(dpp_sample)*N;
                  for index_i = 1: size(sample_index_x)
                        map_dpp_pred_error_bicubic(sample_index_y(index_i),sample_index_x(index_i))=1;
                  end
                  Map_c_dpp_pred_error_bicubic(iz,ic,lam,:,:)=map_dpp_pred_error_bicubic;
                  Map_c_pred_error_bicubic(iz,ic,lam,:,:)=map_pred_error_bicubic;
        end
    end
end


