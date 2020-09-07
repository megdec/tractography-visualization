function [res] = dispersion(s, dim)

I = zeros(dim) +1;
I_m = apply_mask(I, s);
[x,y,z] = ind2sub(dim ,find(I_m == 1));

score = 0;
centroid = [median(x), median(y), median(z)];

for i = 1:size(x,1)
        score = score + sqrt((centroid(1) - x(i, 1))^2 + (centroid(2) - y(i, 1))^2 + (centroid(3) - z(i, 1))^2);
end

res = score/size(x,1);

% score = 0;
% num = 0;
% for k = 1:size(s,2)
%     for i = 1:size(s{k}, 1)
%         num = num + 1;
%         score = score + sqrt((centroid(1) - s{k}(i,1))^2 + (centroid(2) - s{k}(i,2))^2 + (centroid(3) - s{k}(i,3))^2);
%     end
% end
% res = score/num;