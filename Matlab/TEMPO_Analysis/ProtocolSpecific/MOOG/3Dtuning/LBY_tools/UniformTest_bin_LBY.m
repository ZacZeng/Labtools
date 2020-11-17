% Uniform test for general 
% adapted from GY
% LBY 20201003
% matlab function-> chi2gof is effective
% if p<0.05, it's uniformly distributed

function [h,p] = UniformTest_bin_LBY(data,num_perm)

if nargin == 1
    num_perm = 2000;
end

dim = length(data);

hist_raw = data;
R = sum( (hist_raw - mean(hist_raw)).^2 );

% do permutation now, bin first, and then permute the bin
for nn = 1 : num_perm

    uniform_data = rand(1,round(sum(hist_raw)));
    hist_uniform = hist(uniform_data,dim);
    R_perm(nn) = sum( (hist_uniform - mean(hist_raw)).^2 );
%     plot(hist_raw_perm,'b-');
    hold on;
end


% return p value
p =length(find(R_perm<R)) / num_perm;
if p < 0.05
    h = 1;
else
    h = 0;
end

end

