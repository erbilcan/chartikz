function [angle] = majority_vote_angles(P)

target = P(:,2);
[N,edges] = histcounts(target, 0:18:360);

[M, idx] = max(N);

lower_limit = edges(idx);
upper_limit = edges(idx+1);

bin_vals = find(target>=lower_limit & target<=upper_limit);

angle = mean(target(bin_vals));
end

